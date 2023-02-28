local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n','<leader><leader>',builtin.git_files,{})
vim.keymap.set('n','<leader>ps',function()
	builtin.grep_string({ search = vim.fn.input("grep > ") })
end)
vim.keymap.set('n',"<leader>ss","<cmd>Telescope live_grep<cr>", {noremap = true, silent = true})

