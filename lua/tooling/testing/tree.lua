-- Basic highlighting is working
-- Basic syntax tree is created
--
-- TODO:
-- - [x] introduce line end termiators
-- - [x] multi line handling (``` etc)
-- - [ ] handling for multi symbol stuff ( - [ ] )
-- - [ ] handling for conditional stuff ( - [x] )
-- - [ ] Ordered lists
-- - [ ] color coding per type
--
-- FIXME:
-- - [x] empty line is detected within the current node
-- - [x] last line is not detected correctly (because -1 doesn't work)
--
local file = require('tooling.testing.fileloader')
local nsUtils = require('examples.nsTest.testingFunctions')

local NodeType = {
    ROOT = 0x1,
    SECTION = 0x2,
}

local SyntaxElements = {
    H1 = '#',
    LI = '-',
    BOLD = '*',
    CODE = '`',
    LINK_OPEN = '[',
    LINK_CLOSE = ']',
    COMMENT = '%',
    --NL = '\n'
}

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
    OTHER = 0x2
}

local SemanticMap = {
    [SyntaxElements.LINK_OPEN] = ElementType.LINK,
    [SyntaxElements.LINK_CLOSE] = ElementType.LINK
}

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

    -- how many symbols detected
    symbol_count = 0,
    -- type of sybol (kinda like node type) this represents
    element_type = nil,

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

-- printing stuff

local outputBuffer = nil;

function setupBuffer()
    if not outputBuffer then
        outputBuffer = vim.api.nvim_create_buf(true, false)
    end

    vim.api.nvim_command("belowright split")
    vim.api.nvim_command("buffer " .. outputBuffer)
end

function buffer_print(lineIndex, text)
    -- use this to append at the end of the buffer
    -- NOTE: -1 as first line skips the first line somehow (because it always appends?)
    -- so the first line stays empty?
    vim.api.nvim_buf_set_lines(outputBuffer, -1, -1, false, { text })
end

function buffer_write_lines(lines)
    vim.api.nvim_buf_set_lines(outputBuffer, 0, -1, false, lines)
end

-- creating the tree

function is_syntax_element(char, syntax)
    return char == syntax:byte(1)
end

function get_symbol(key)
    return SyntaxElements[key]
end

function node_info_string(node)
    local nodeStr = "";
    nodeStr = nodeStr .. node.value
    nodeStr = nodeStr .. " l " .. node.start_line .. ".." .. node.end_line
    nodeStr = nodeStr .. " c " .. node.start_column .. ".." .. node.end_column

    return nodeStr
end

function print_tree(tree, indent)
    buffer_print(-1, string.rep("    ", indent) .. node_info_string(tree))

    if tree.children ~= nil then
        for idx, node in ipairs(tree.children) do
            print_tree(node, indent + 1)
        end
    end
end

function close_node(curNode, lineNo, columnNo)
    if curNode.element_type ~= nil then
        curNode.end_line = lineNo
        curNode.end_column = columnNo
        curNode.value = curNode.symbol_count .. "x" .. curNode.value

        return curNode.parent
    end
    return curNode
end

function next_child_node(previousNode, nextElement, lineNo, columnNo)
    local new = {}
    new.has_content = false
    new.is_closed = false
    new.element_type = nextElement
    new.symbol_count = 1
    new.start_line = lineNo
    new.start_column = columnNo
    new.end_line = -1
    new.end_column = -1
    new.value = get_symbol(new.element_type)

    add_child(previousNode, new)

    return new
end

-- checks than opening and closing an element will count as the same
function is_repeating_element(syntaxElementA, syntaxElementB)
    if syntaxElementA == syntaxElementB then return true end

    local valueA = get_symbol(syntaxElementA)
    local valueB = get_symbol(syntaxElementB)
    local syntaxA = SemanticMap[valueA]
    local syntaxB = SemanticMap[valueB]

    if syntaxA ~= nil then
        return syntaxA == syntaxB
    end

    return false
end

-- this only works because we check before if it is actually a syntax element
-- maybe i should make a distinction between syntax and other text elements?
function is_different_element(previousElement)
    if previousElement == nil then return false end
    return true
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

function increase_symbol_counter(node)
    node.symbol_count = node.symbol_count + 1

    -- if we revisit a node, that had text elements within it
    -- that means we must have reached the end symbols
    if node.has_content then
        node.is_closed = true
    end
end

function is_not_multi_line(node)
    local syntaxValue = SyntaxElements[node.element_type];

    if syntaxValue == SyntaxElements.CODE or
        syntaxValue == SyntaxElements.COMMENT then
        return false
    end

    return true
end

function createMarkdownTree(lines)
    -- track the current node
    local curNode = tree;
    local prevLineLength = 0

    for idx, line in ipairs(lines) do
        local lineIndex = idx - 1;

        for charIndex = 1, #line do
            local char = line:byte(charIndex)
            for key, symbol in pairs(SyntaxElements) do
                if is_syntax_element(char, symbol) then
                    if is_repeating_element(curNode.element_type, key) then
                        increase_symbol_counter(curNode)
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

        if #line > 0 then prevLineLength = #line end
    end

    -- close last node? (or all still open nodes?)
    --close_node(curNode, -1, -1)

    return tree
end

function highlight_by_tree(root)
    if root.children == nil then
        return
    end

    for _, node in ipairs(root.children) do
        -- FIXME: seems like -1 for end line is not working for highlight
        -- TODO: different colors per type

        -- NOTE: seems that the offset for the column is -1 from the actual text buffer
        -- both lines and chars start at 0, but line:byte(1) gives you the first character
        if node.start_line ~= node.end_line then
            for lineNo = node.start_line, node.end_line do
                local lastChar = -1
                local firstChar = 0;

                if lineNo == node.start_line then
                    firstChar = node.start_column - 1
                end
                if lineNo == node.end_line then
                    lastChar = node.end_column
                end
                vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Function", lineNo, firstChar, lastChar)
            end
        else
            -- single line mode
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Comment", node.start_line, node.start_column - 1,
                node.end_column + 1)
        end
    end
end

function test()
    setupBuffer()

    local contentLines = file.loadFileInLines();
    local tree = createMarkdownTree(contentLines);

    buffer_write_lines(contentLines)
    print_tree(tree, 0)
    highlight_by_tree(tree)
end

local startTime = os.clock();
test()
local endTime = os.clock()
nsUtils.printExecutionTime(startTime, endTime)
