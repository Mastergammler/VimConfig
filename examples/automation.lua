local bufnr = 97

-- don't forget to run :source % to register or update this file
-- so works as well

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("TestGroup", { clear = true }),
    pattern = "exec.bat",
    callback = function()
        -- command execution comes here
        vim.fn.jobstart({ "dotnet", "--version" }, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                --if data then
                    --vim.api.nvim_buf_set_lines(bufnr, 1, 1, false, data)
                --end
            end
        })
        vim.fn.jobstart({ "examples/exec.bat" }, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, data)
                end
            end,
            on_stderr = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, data)
                end
            end
        })
    end
})
