local function current_module_name()
    local curFilePath = vim.api.nvim_buf_get_name(0)
    -- full path, without suffix
    local fileName = vim.fn.fnamemodify(curFilePath, ":p:r")
    -- root dir + lua dir
    local rootDir = vim.fn.getcwd() .. "\\lua\\"
    -- strings start at 1
    local relDir = string.sub(fileName, #rootDir + 1)
    local moduleName = relDir:gsub("/", "."):gsub("\\", "."):gsub("%.lua", "")
    return moduleName
end

return {
    current_module_name = current_module_name
}

