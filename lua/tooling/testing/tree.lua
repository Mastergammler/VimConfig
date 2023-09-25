-- package.loaded['tooling.testing.fileloader'] = nil
local file = require('tooling.testing.fileloader')

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
    CODE = '`',
    LINK_OPEN = '[',
    LINK_CLOSE = ']',
    COMMENT = '%',
    --NL = '\n'
}

local tree = {
    type = NodeType.ROOT,
    parent = nil,
    children = nil,

    start_line = 0,
    end_line = -1,
    start_column = 0,
    end_column = -1,
}

-- TODO: now how would call this?
-- and how would it it know this information?
function addChild(node, childNode)
    childNode.parent = node
    table.insert(node.children, childNode);
end

local outputBuffer = nil;

function setupBuffer()
    if not outputBuffer then
        outputBuffer = vim.api.nvim_create_buf(true, false)
    end

    vim.api.nvim_command("belowright split")
    vim.api.nvim_command("buffer " .. outputBuffer)
end

function buffer_print(lineIndex, text)
    vim.api.nvim_buf_set_lines(outputBuffer, lineIndex, lineIndex, false, { text })
end

-- somehow i don't like the dependance on lines
-- it makes everything so complicated, instead of just sequence of chars
-- because lines are more of a display concept right?
function createMarkdownTree(lines)
    setupBuffer()
    for idx, line in ipairs(lines) do
        local bufferIdx = idx - 1;

        buffer_print(bufferIdx, "--- " .. bufferIdx .. " ---");

        for i = 1, #line do
            local char = line:byte(i)
            for key, symbol in pairs(SyntaxElements) do
                -- TODO: this would replace right now
                if char == symbol:byte(1) then
                    buffer_print(bufferIdx, key)
                    goto continue
                end
            end
            ::continue::
        end
    end
end

function test()
    local content = file.loadFileInLines();
    local tree = createMarkdownTree(content);
end

test()
