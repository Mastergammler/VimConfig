-- what do i need?
-- refactor class names
--   file name
--   class usages? (lsp?)
--   git mv?
--   ? How would i trigger it?
--   ! Check that it only works when filename = symbol name
--
-- move file
--   git mv
--   adjust file ns
--   adjust ns on it's usecases (this is probably more difficult)
--   (this would require full project search & search if not other types in the folders are used)
--
-- move xaml file (+ code behind)
--   needs more ns adjustments
--   adjust xaml stuff
--   not just xaml file -> also code behind
--
-- move folders
--   move every file in the folder
--   special case xaml
--

function gitMoveCurrent()
    assert(isThisGitTracked(), "Only files under version control can be moved")
    vim.cmd.w()

    local thif_fullPath = vim.fn.expand("%:p")
    local thif_dir = vim.fn.fnamemodify(thif_fullPath, ":h") .. "/"

    vim.ui.input({ prompt = "New path: ", default = thif_dir, completion = "file" }, function(input)
        if input == nil or #input == #thif_dir then return end

        local res = vim.fn.systemlist("git mv "
            .. string.format('"%s"', thif_fullPath) .. " "
            .. string.format('"%s"', input))

        -- no response from the git action means success
        if res[1] == nil then
            vim.cmd.bd()
            vim.cmd.e(input)
        else
            -- in any other case it returns the error message
            P(res)
            error(res[1] .. "\nTarget was: " .. input)
        end
    end)
end

function validateClassIsFilename()
    local symbol = vim.api.nvim_call_function("expand", { "<cword>" })
    local curFileName = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")

    if symbol == curFileName then
        print("Refactoring allowed for:", symbol)
    else
        print("Class name doesn't match file name - Class:", symbol, "File:", curFileName)
    end
end

function isThisGitTracked()
    local filePath = vim.fn.expand("%:p")
    --local filePath = vim.fn.bufname()
    local fileString = string.format('"%s"', filePath)
    local gitStatus = vim.fn.systemlist("git ls-files " .. fileString)
    P(gitStatus)
    print("path: ", fileString, " git status: ", gitStatus[0], " 1:", gitStatus[1])

    if gitStatus[1] ~= nil then
        return true
    else
        return false
    end
end

--vim.keymap.set("n", "<leader>tt", gitMoveCurrent, { desc = "[t]est [t]est" })

return {
    git_move_current = gitMoveCurrent
}
