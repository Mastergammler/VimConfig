local writeToCurrentBuffer = function(text)
    local currentBuffer = vim.api.nvim_get_current_buf();

    local lines = {};
    for line in string.gmatch(text, "[^\n]+") do
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(currentBuffer, 0, 1, true, lines)
end

local writeToNewFile = function(filename, text)
    local currentDir = vim.fn.expand("%:p:h")
    local newFilePath = currentDir .. "/" .. filename

    local file = io.open(newFilePath, "w")

    assert(file, "The file " .. newFilePath .. " could not be created")

    file:write(text)
    file:close()
end

return {
    writeToCurrentbuffer = writeToCurrentBuffer,
    writeToNewFile = writeToNewFile
}
