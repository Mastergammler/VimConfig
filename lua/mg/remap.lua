vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set("v","<leader>fs",vim.cmd.update)

vim.keymap.set("n","<leader>fs",function()
    vim.cmd('update') 
    vim.lsp.buf.format()
end, {silent = true})
--vim.keymap.set("n","<leader>fs",

