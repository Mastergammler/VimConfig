-- package.loaded['tooling.testing.fileloader'] = nil
local file = require('tooling.testing.fileloader')
local nsUtils = require('examples.nsTest.testingFunctions')

local NodeType = {
    ROOT = 0x1,
    SECTION = 0x2,
}

-- these would me matched by start?
-- some elements have same start and end / others have different start and end
-- maybe just map single elements? And then look at the tree?
-- would make also sense for heading stuff, then just have some kind of count of it?
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

local SyntaxMap = {
    LINK = { SyntaxElements.LINK_OPEN, SyntaxElements.LINK_CLOSE }
}

local tree = {

    -- print value representation for debugging
    value = "I am root",

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
    vim.api.nvim_buf_set_lines(outputBuffer, -1, -1, false, { text })
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
        -- buffer_print(-1, curNode.symbol_count .. "x" .. curNode.element_type)
        --curNode.element_type = nil
        --curNode.symbol_count = 0
        curNode.end_line = lineNo
        curNode.end_column = columnNo
        curNode.value = curNode.symbol_count .. "x" .. curNode.value

        return curNode.parent
    end
    return curNode
end

function next_child_node(previousNode, nextElement, lineNo, columnNo)
    local new = {}
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

-- somehow i don't like the dependance on lines
-- it makes everything so complicated, instead of just sequence of chars
-- because lines are more of a display concept right?
function createMarkdownTree(lines)
    -- track the current node
    local curNode = tree;

    for idx, line in ipairs(lines) do
        local lineIndex = idx - 1;

        --buffer_print(bufferIdx, "--- " .. bufferIdx .. " ---");

        -- FIXME: wrong char offset on switch
        for charIndex = 1, #line do
            local char = line:byte(charIndex)
            for key, symbol in pairs(SyntaxElements) do
                if is_syntax_element(char, symbol) then
                    -- case same symbol again
                    if curNode.element_type == key then
                        curNode.symbol_count = curNode.symbol_count + 1
                    elseif curNode.element_type ~= nil then
                        -- case symbol changed
                        curNode = close_node(curNode, lineIndex, charIndex)
                        -- register new symbol
                        curNode = next_child_node(curNode, key, lineIndex, charIndex)
                    else -- first detection of symbol
                        curNode = next_child_node(curNode, key, lineIndex, charIndex)
                    end
                    goto continue
                end
            end

            -- TODO: handling for 3x``` -> or rather open/close sections

            -- case, current is not another syntax symbol
            -- in that case we don't wanna close?
            -- curNode = close_node(curNode, lineIndex, charIndex)
            ::continue::
            -- check the end, else last elements don't get printed'
            -- this is also wrong? we don't want to do this for every line!!!
            -- FIXME: some close at end of line, others don't
            if charIndex == #line then
                -- curNode = close_node(curNode, lineIndex, charIndex)
            end
        end
    end

    -- close last node? (or all still open nodes?)
    close_node(curNode, -1, -1)

    return tree
end

function test()
    local content = file.loadFileInLines();
    local tree = createMarkdownTree(content);
    setupBuffer()
    print_tree(tree, 0)
end

local startTime = os.clock();
test()
local endTime = os.clock()
nsUtils.printExecutionTime(startTime, endTime)
