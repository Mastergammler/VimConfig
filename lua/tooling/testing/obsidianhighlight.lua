local file = require('tooling.testing.fileloader')
local t = require('tooling.testing.tree')
local nsUtils = require('examples.nsTest.testingFunctions')
local debug = require('tooling.debug.printing')

function node_info_string(node)
    local nodeStr = "";
    nodeStr = nodeStr .. node.value
    nodeStr = nodeStr .. " l " .. node.start_line .. ".." .. node.end_line
    nodeStr = nodeStr .. " c " .. node.start_column .. ".." .. node.end_column

    return nodeStr
end

function highlight_by_tree(root, outputBuffer)
    if root.children == nil then
        return
    end

    for _, node in ipairs(root.children) do
        -- FIXME: seems like -1 for end line is not working for highlight
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
                local highlightGroup = t.NodeTypeColor[node.type]
                vim.api.nvim_buf_add_highlight(outputBuffer, 0, highlightGroup, lineNo, firstChar, lastChar)
            end
        else
            -- single line mode
            local highlightGroup = t.NodeTypeColor[node.type]
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, highlightGroup, node.start_line, node.start_column - 1,
                node.end_column + 1)
        end
    end
end

function test()
    local buffer = debug.setup_buffer()

    local contentLines = file.loadFileInLines(false);
    local tree = t.create_markdown_tree(contentLines);

    debug.buffer_append_lines(contentLines)
    debug.print_tree(tree, 0, node_info_string)
    highlight_by_tree(tree, buffer)
end

local startTime = os.clock();
test()
local endTime = os.clock()
nsUtils.printExecutionTime(startTime, endTime)
