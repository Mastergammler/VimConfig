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


local someString = "string"
local testing = "fake hehehehe"

function getCurrentSymbol()
    local symbol = vim.api.nvim_call_function("expand", { "<cword>" })
    local curFileName = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")

    if symbol == curFileName then
        print("Refactoring allowed for:", symbol)
    else
        print("Class name doesn't match file name - Class:", symbol, "File:", curFileName)
    end
end

function isCurrentGitFile()
    -- use git ls-files <filename> and check if it's empty -> easiest way
    local gitStatusCmd = "git -c " .. vim.fn.expand('%:p') .. " rev-parse --is-inside-work-tree"
    print(gitStatusCmd)
    local gitStatus = vim.fn.systemlist(gitStatusCmd)
    P(gitStatus)
end

vim.keymap.set("n", "<leader>tt", isCurrentGitFile, { desc = "[t]est [t]est" })
