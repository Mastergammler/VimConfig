local nsUtils = require('examples.nsTest.testingFunctions')
local MARKDOWN_TEST_FILE = "lua/tooling/testing/res/simplemarkdown.md"
local BIG_FILE = "lua/tooling/testing/res/bigfile.md"

function getLines()
    local currentBuf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(currentBuf, 0, -1, false)
    return lines;
end

local outputBuffer = nil;

function writeToBuffer(lines)
    if not outputBuffer then
        outputBuffer = vim.api.nvim_create_buf(true, false)
    end

    vim.api.nvim_buf_set_lines(outputBuffer, 0, -1, false, lines)

    vim.api.nvim_command("belowright split")
    vim.api.nvim_command("buffer " .. outputBuffer)
end

function highlightStuff(lines)
    for index = 0, #lines, 1 do
        --vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Comment", index, 0, -1)
    end

    local heading = "#"
    local bullets = "-"
    local open = "%[%["
    local close = "%]%]"
    local sectionOpened = false;
    local codeBlock = "```"

    for idx, val in ipairs(lines) do
        -- for some reason ipair index starts at 1
        local bufferIndex = idx - 1;

        local codeBlockThisLine = false
        if string.sub(val, 1, #codeBlock) == codeBlock then
            codeBlockThisLine = true
            sectionOpened = not sectionOpened
        end

        if sectionOpened or codeBlockThisLine then
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Comment", bufferIndex, 0, -1);
            goto continue;
        end

        if string.sub(val, 1, #heading) == heading then
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Function", bufferIndex, 0, -1);
        elseif string.sub(val, 1, #bullets) == bullets then
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, "ErrorMsg", bufferIndex, 0, -1)
        end

        local openStart, _ = val:find(open);
        local _, closeEnd = val:find(close);

        if openStart and closeEnd then
            -- again the find function doesn't use 0 index apparently
            local startIndex = openStart - 1;
            vim.api.nvim_buf_add_highlight(outputBuffer, 0, "@conditional", bufferIndex, startIndex, closeEnd)
        end
        ::continue::
    end

    --vim.api.nvim_buf_add_highlight(outputBuffer, 0, "ErrorMsg", 0, 0, 22);
    --vim.api.nvim_buf_add_highlight(outputBuffer, 0, "Function", 2, 7, 25);
end

function test()
    local startTime = os.clock();
    local lines = loadFileInLines()
    writeToBuffer(lines);
    highlightStuff(lines)

    local endTime = os.clock()
    nsUtils.printExecutionTime(startTime, endTime)
end

function loadFileInLines()
    local file = io.open(BIG_FILE, "r")
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end
        local read = file:read("*a")
        return lines
    else
        print("Error reading file ..")
    end
end

test()

vim.keymap.set("n", "<leader>th", test, { desc = "[t]est [th]is" })
