vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set("v","<leader>fs",vim.cmd.update)

vim.keymap.set("n","<leader>fs",function()
    vim.cmd('update') 
    vim.lsp.buf.format()
end, {silent = true})

-- window jumping remap
vim.keymap.set("n","<leader>wd",vim.cmd.close,{noremap = true})
vim.keymap.set("n","<leader>ww","<C-w>w",{noremap = true})
vim.keymap.set("n","<leader>wj","<C-w>j",{noremap = true})
vim.keymap.set("n","<leader>wk","<C-w>k",{noremap = true})
vim.keymap.set("n","<leader>wl","<C-w>l",{noremap = true})
vim.keymap.set("n","<leader>wm","<C-w>m",{noremap = true})
vim.keymap.set("n","<leader>w/",vim.cmd.vs, {noremap = true})

-- these don't work
vim.keymap.set("n","<leader>w1","<C-w>1",{noremap = true})
vim.keymap.set("n","<leader>w2","<C-w>2",{noremap = true})
vim.keymap.set("n","<leader>w3","<C-w>3",{noremap = true})
vim.keymap.set("n","<leader>w4","<C-w>4",{noremap = true})


