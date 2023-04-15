require("mg")
require("packer")
require("tooling.refactoring")
--require("examples")

vim.cmd('autocmd BufNewFile,BufRead *.xaml set filetype=xml')

-- FIXME: getcwd also doesn't work 'workaround because dirchange broken on wsl?
vim.cmd('cd ' .. vim.fn.getcwd())

print("Loaded init 2302")
