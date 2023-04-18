require("mg/set")
require("mg/remap")
require("mg/globals")
require("mg/dap")
-- require("mg/commands")


local function highlightCurrentWord()
    local searchWord = vim.fn.expand("<cword>")
    vim.cmd(string.format("/%s", searchWord))
end

vim.keymap.set("n", "<leader>hl", highlightCurrentWord, { desc = "[h]igh[l]ight current word" })

print("Hello from MG")
