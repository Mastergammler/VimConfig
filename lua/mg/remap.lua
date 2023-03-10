vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = '[P]roject [v]iew (show current folder files)' })
vim.keymap.set("n", "<leader>fs", function()
    vim.cmd('update')
    vim.lsp.buf.format()
end, { silent = true, desc = '[F]ile [s]ave (saves and runs lsp format)' })

-- NAV
-- NOT SURE IF I LIKE THOSE, this makes me a bit dizzy i think
--vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Half window [d]own with staying in the middle' })
--vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Half window [u]p with staying in the middle' })
--vim.keymap.set("n", "n", "nzzzv", { desc = 'Stay in middle during [n]ext text search result' })
--vim.keymap.set("n", "N", "Nzzzv", { desc = 'Stay in middle during Previous text search result' })
vim.keymap.set("n", "<C-h>", vim.cmd.bprevious, { desc = 'Open previous buffer' })
vim.keymap.set("n", "<C-l>", vim.cmd.bnext, { desc = 'Open next buffer' })
vim.keymap.set("n", "<leader>l", vim.cmd.nohlsearch, { desc = 'Deselects highlights after searching' })

vim.keymap.set("n", "<leader>wd", vim.cmd.close, { noremap = true, desc = '[W]indow [d]elete - closes the window' })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { noremap = true, desc = 'Jumps from one [w]indow to the next [w]indow' })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, desc = "Jump [W]indow below" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, desc = "Jump [W]indow above" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, desc = "Jump [W]indow right" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, desc = "Jump [W]indow left" })
vim.keymap.set("n", "<leader>w/", vim.cmd.vs, { noremap = true, desc = "Split window to the right" })

-- terminal
vim.keymap.set("n", "<leader>tt", function()
    -- this doesn't open the same buffer, i have to do this via session management
    vim.cmd("sp term://sh")
end, { desc = 'Opens a new terminal horizontally' })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = 'Exits terminal insert mode' })

-- editing
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves the current selection one line up' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves the current selection one line down' })
vim.keymap.set("n", "J", "mzJ`z", { desc = 'Moves lower line to this one with cursor in place' })
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = 'Search [r]eplace all instance of word under cursor' })

-- yanking to clipboard
-- TODO: reset the clipboard usage for pasting
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete to void" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete to void" })

vim.keymap.set("n", "Q", "<nop>")

--quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>", { desc = "Quickfix previous" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>", { desc = "Quickfix next within project?" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>", { desc = "Quickfix previous within project?" })
vim.keymap.set("n", "<leader>tl", vim.cmd.TodoQuickFix, { desc = "[T]odo quickfix [l]ist " })

-- prep for future use
--vim.keymap.set("n","<leader>ns","<cmd>silent !tmix neww tmux-sessionizer<CR>", { desc = "New tmux session" })
