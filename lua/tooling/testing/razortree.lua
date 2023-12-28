-- Testing the tree structure for razor layouts
-- chanaging the default obs tests for razor stuff
-- testing how much i would have to adjust for it to be working
--
--- Node Type for coloring
local NodeType = {
    ROOT = 0x1,
    COMMENT = 0x2,
    CODE = 0x3,
    LINK = 0x4,
    ERROR = 0x5,
    CODE_DIRECTIVE = 0x6,
    TODO_OPEN = 0x7,
    TODO_DONE = 0x8,
    BOLD = 0x9
}
--- Mapping node types to highlight groups
local NodeTypeColor = {
    [NodeType.COMMENT] = "Comment",
    [NodeType.CODE] = "StatusLineNC",
    [NodeType.LINK] = "Function",
    [NodeType.ERROR] = "ErrorMsg",
    [NodeType.CODE_DIRECTIVE] = "WildMenu",
    [NodeType.TODO_OPEN] = "@text.todo",
    [NodeType.TODO_DONE] = "@string",
    [NodeType.BOLD] = "Constant"
}

local ColorMap = {
    TAG = "Function",
    BLOCK = "StatusLineNC",
    DIRECTIVE = "WildMenu",
    STRING = "@string"
}

-- TODO: do i want to have these as references?
-- - [ ] how do i handle eol / eof ? -> automatically?
--   - [ ] TEST: Auto, via multiline flag?
-- - [x] how do i handle multiline? -> ez, just var
-- - [ ] Multilpe terminators? -> make it an array?
local SyntaxNodes = {
    DIRECTIVE = {
        Start = "@",
        End = ' ', -- EOL | EOF
        EndInclusive = false,
        -- TODO: is multiline only relevant for auto ending?
        -- because else, it would just be handleed by the  tree?
        -- but it is important for the tree to know?
        Multiline = false,
        Color = ColorMap.DIRECTIVE
    },
    TAG = {
        Start = "<",
        End = ">",
        EndInclusive = true,
        Multiline = false,
        Color = ColorMap.TAG
    },
    SECTION = {
        Start = "{",
        End = "}",
        EndInclusive = true,
        Multiline = true,
        Color = ColorMap.BLOCK
    },
    -- TODO: strings and directives can interact with each other
    -- need to handle this as well
    STRING = {
        Start = '"',
        End = '"',
        EndInclusive = true,
        Multiline = false,
        Color = ColorMap.STRING

    }
}

-- most important elements
-- @ :: till space
-- " .. " :: for quotes
-- < .. > :: html blocks
-- { .. } :: code sections
-- @code :: special keyword
-- // :: code comments (enable todo stuff)
local SyntaxElements = {
    DIRECTIVE = '@',
    DIRECTIVE_END = ' ',
    BOLD = '*',
    CODE = '`',
    LINK_OPEN = '[',
    LINK_CLOSE = ']',
    CB_OPEN = '{',
    CB_CLOSE = '}',
    TAG_OPEN = '<',
    TAG_CLOSE = '>',
    -- TODO: comment for // and <!-- -->
    COMMENT = '%',
    --NL = '\n'
}

--- Mapping the syntax elements to node types
--- only for the default / simple types
local SyntaxToNodeType = {
    [SyntaxElements.DIRECTIVE] = NodeType.CODE_DIRECTIVE,
    [SyntaxElements.DIRECTIVE_END] = NodeType.CODE_DIRECTIVE,
    --[SyntaxElements.LI] = NodeType.COMMENT,
    [SyntaxElements.BOLD] = NodeType.BOLD,
    [SyntaxElements.CODE] = NodeType.CODE,
    [SyntaxElements.LINK_OPEN] = NodeType.LINK,
    [SyntaxElements.CB_OPEN] = NodeType.LINK,
    [SyntaxElements.TAG_OPEN] = NodeType.LINK,
    [SyntaxElements.COMMENT] = NodeType.COMMENT
}

P(SyntaxToNodeType)

-- create a reverse lookup for easier access
-- maybe an array structure would be better?
-- but then i don't have as nice of access?
-- -> I could, if i use another table as enum with values?
local SE_ReverseLookup = {}
for key, value in pairs(SyntaxElements) do
    SE_ReverseLookup[value] = key
end

local ElementType = {
    LINK = 0x1,
    LI = 0x2
}

local SemanticMap = {
    [SyntaxElements.LINK_OPEN] = ElementType.LINK,
    [SyntaxElements.LINK_CLOSE] = ElementType.LINK,
    [SyntaxElements.CB_OPEN] = ElementType.LINK,
    [SyntaxElements.CB_CLOSE] = ElementType.LINK,
    [SyntaxElements.TAG_OPEN] = ElementType.LINK,
    [SyntaxElements.TAG_CLOSE] = ElementType.LINK,
    [SyntaxElements.DIRECTIVE] = ElementType.LINK,
    [SyntaxElements.DIRECTIVE_END] = ElementType.LINK,

    -- FIXME: this doesn't quite work right, need another solution
    --[SyntaxElements.LI] = ElementType.LINK
}

--- Tree (Node)
--- @type Node
--- @field value string: Debugging value
--- @field children Node[]: Children nodes of this tree element
--- @field partent Node: Reference to the parent, nil for the root node
local tree = {

    -- print value representation for debugging
    value = "I am root",

    -- flag that indicates, that inbetween the syntax elements of the node
    -- there is text content, in order to know if i should close the node
    has_content = false,

    -- flag that indicates that the node has a start and an ending part
    -- this should only occur when has_content is true as well
    -- it is when we found the end matching section for a node
    is_closed = false,

    --- weather or not the type node is set customly
    --- prevents the default setting at the end
    custom_type = false,

    -- how many symbols detected
    symbol_count = 0,
    -- type of sybol (kinda like node type) this represents
    definition = nil,

    -- kind of section for highlight info
    type = NodeType.ROOT,
    -- parent node
    parent = nil,
    -- children node 'array'
    children = {},

    -- line where the node was created
    start_line = 0,
    -- line where the node was closed
    end_line = -1,
    -- column (line position) where the start symbol was found on
    start_column = 0,
    -- column (line position) where the end symbol was found on
    end_column = -1,
}

function add_child(node, childNode)
    childNode.parent = node

    if node.children == nil then
        node.children = {}
    end

    table.insert(node.children, childNode);
end

-- creating the tree

--- Compares the first chars of the elements
--- bceause simple string to char matches don't work
function matches_first(char, stringEl)
    return char == stringEl:byte(1)
end

function get_symbol(key)
    return SyntaxElements[key]
end

function close_node(curNode, lineNo, columnNo)
    -- if definition is missing, then this is the root node
    -- every other node has to have the definition applied
    if curNode.definition ~= nil then
        curNode.end_line = lineNo
        curNode.end_column = columnNo
        curNode.value = curNode.symbol_count .. "x" .. curNode.value
        -- FIXME: this works different now
        -- maybe i don't even need this anymore
        -- because this type thing has been replaced by the definition?
        if not curNode.custom_type then
            curNode.type = SyntaxToNodeType[SyntaxElements[curNode.element_type]]
        end

        -- TODO: this tells us not much, do i even need it?
        curNode.is_closed = true

        return curNode.parent
    end
    return curNode
end

-- TODO: this can probably be simplified a bit
-- because now i don't need all this stuff here
function next_child_node(previousNode, elementDefinition, lineNo, columnNo)
    local new = {}
    new.has_content = false
    new.is_closed = false
    new.definition = elementDefinition
    new.symbol_count = 1
    new.start_line = lineNo
    new.start_column = columnNo
    new.end_line = -1
    new.end_column = -1
    -- TODO: do i need this?
    -- do i maybe want to collect the content?
    -- -> Or would that be sufficient via start and end tags and then get the stuff?
    new.value = elementDefinition.Start --get_symbol(new.element_type)
    new.type = NodeType.COMMENT

    add_child(previousNode, new)

    return new
end

function switch_to_next_node(activeNode, syntaxElement, lineIndex, charIndex, previousLineLength)
    -- case symbol changed
    local lineIdx = lineIndex
    -- it should be the previous char?
    local charIdx = charIndex - 1
    -- case were on the next line
    if charIndex == 1 then
        -- were actually supposed to end on the previous line
        lineIdx = lineIndex - 1
        -- previous line means we need to take the last one
        charIdx = previousLineLength -- - 1
    end

    activeNode = close_node(activeNode, lineIdx, charIdx)
    -- register new symbol
    return next_child_node(activeNode, syntaxElement, lineIndex, charIndex)
end

function parse_line_node(line, lineIndex, node, prevLineLength)
    local curNode = node

    for charIndex = 1, #line do
        local char = line:byte(charIndex)

        -- check first, if the symbol ends the current element
        -- else nodes with same start and end node can't be detected properly
        -- assuming the same node can't contain itself
        if curNode.definition ~= nil and matches_first(char, curNode.definition.End) then
            local idx = charIndex;
            if not curNode.definition.EndInclusive then idx = charIndex - 1 end
            curNode = close_node(curNode, lineIndex, idx)
        else
            -- PERF: also very inefficient if i find more syntax tokens
            -- -> Will there be that many -> probably not! => mabye 10-20?
            for _, def in pairs(SyntaxNodes) do
                -- then check, if it is a new node type
                if matches_first(char, def.Start) then
                    curNode = next_child_node(curNode, def, lineIndex, charIndex)
                    -- found a match, next char
                    goto continue
                else
                    -- not a syntax element, skip
                end
            end
        end

        :: continue ::
    end

    return curNode
end

--- TODO: refactor, this is very complicated, not really understandable anymore
--
--- Algorithm to determine how to parse the line into the node
--- @param node Node: previous node
--- @param line string: content of the current line
--- @param lineIndex number: index of the line
--- @param prevLineLength number: length of the previous line
--- @return Node: the current or new node
function parse_line_node_old(line, lineIndex, node, prevLineLength)
    local curNode = node

    for charIndex = 1, #line do
        local char = line:byte(charIndex)
        for key, symbol in pairs(SyntaxElements) do
            if matches_first(char, symbol) then
                if is_repeating_element(curNode.element_type, key) then
                    increase_symbol_counter(curNode, key)
                elseif is_different_element(curNode.element_type) then
                    curNode = switch_to_next_node(curNode, key, lineIndex, charIndex, prevLineLength)
                else -- first detection of symbol
                    curNode = next_child_node(curNode, key, lineIndex, charIndex)
                end
                goto continue
            end
        end

        -- case it didn't match any of the syntax elements
        if char ~= nil then
            if curNode.is_closed then
                -- -1 because this is the symbol after
                curNode = close_node(curNode, lineIndex, charIndex - 1)
            else
                -- this means the current node, has at least one text element within it?
                -- TODO: handle text only nodes?

                -- check if i'm actually in a syntax node
                if curNode.element_type ~= nil then
                    curNode.has_content = true
                end
            end
        else
            print("Unhandled case!")
        end

        ::continue::

        if charIndex == #line and is_not_multi_line(curNode) then
            curNode = close_node(curNode, lineIndex, charIndex)
        end
    end

    return curNode
end

function createMarkdownTree(lines)
    local curNode = tree;
    local prevLineLength = 0

    for idx, line in ipairs(lines) do
        local lineIndex = idx - 1;

        curNode = parse_line_node(line, lineIndex, curNode, prevLineLength)

        if #line > 0 then prevLineLength = #line end
    end

    return tree
end

return {
    create_markdown_tree = createMarkdownTree,
    NodeTypeColor = NodeTypeColor
}
