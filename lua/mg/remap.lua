vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = '[P]roject [v]iew (show current folder files)' })
vim.keymap.set("n", "<leader>fs", function()
    vim.lsp.buf.format()
    vim.cmd.update()
end, { silent = true, desc = '[F]ile [s]ave (saves and runs lsp format)' })

-- NAV
-- NOT SURE IF I LIKE THOSE, this makes me a bit dizzy i think
--vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Half window [d]own with staying in the middle' })
--vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Half window [u]p with staying in the middle' })
--vim.keymap.set("n", "n", "nzzzv", { desc = 'Stay in middle during [n]ext text search result' })
--vim.keymap.set("n", "N", "Nzzzv", { desc = 'Stay in middle during Previous text search result' })
vim.keymap.set("n", "<C-h>", vim.cmd.bprevious, { desc = 'Open previous buffer' })
vim.keymap.set("n", "<C-l>", vim.cmd.bnext, { desc = 'Open next buffer' })
-- TODO: maybe change this now becaues L is now list
vim.keymap.set("n", "<leader>l", vim.cmd.nohlsearch, { desc = 'Deselects highlights after searching' })

vim.keymap.set("n", "<leader>wd", vim.cmd.close, { noremap = true, desc = '[W]indow [d]elete - closes the window' })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { noremap = true, desc = 'Jumps from one [w]indow to the next [w]indow' })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, desc = "Jump [W]indow below" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, desc = "Jump [W]indow above" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, desc = "Jump [W]indow right" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, desc = "Jump [W]indow left" })
vim.keymap.set("n", "<leader>w/", vim.cmd.vs, { noremap = true, desc = "Split window to the right" })
vim.keymap.set("n", "<leader>w-", vim.cmd.split, { noremap = true, desc = "Split window to bottom" })

-- tree stuff
vim.keymap.set("n", "<leader>lf", vim.cmd.NvimTreeToggle, { desc = "[L]ist [F]iles (NvimTree)" })
vim.keymap.set("n", "<leader>cf", function()
    vim.cmd.NvimTreeFindFile()
    vim.cmd.NvimTreeFocus()
end, { desc = "[C]urrent [F]ile (NvimTree)" })
vim.keymap.set("n", "<leader>tc", vim.cmd.NvimTreeCollapse, { desc = "[T]ree [c]ollapse (NvimTree)" })


-- terminal
--vim.keymap.set("n", "<leader>tt", function()
-- this doesn't open the same buffer, i have to do this via session management
--   vim.cmd("sp term://sh")
--end, { desc = 'Opens a new terminal horizontally' })
vim.keymap.set("t", "``", "<C-\\><C-n>", { noremap = true, desc = 'Exits terminal insert mode' })
vim.keymap.set({ "n" }, "`,", "<C-\\><C-n><C-w>wa",
    { noremap = true, desc = 'Jumps from one [w]indow to the next [w]indow' })
vim.keymap.set({ "t" }, "`,", "<C-\\><C-n><C-w>w",
    { noremap = true, desc = 'Jumps from one [w]indow to the next [w]indow' })

-- editing
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves the current selection one line up' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves the current selection one line down' })
vim.keymap.set("n", "J", "mzJ`z", { desc = 'Moves lower line to this one with cursor in place' })
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = 'Search [r]eplace all instance of word under cursor' })

-- navigation / NOT SURE IF I LIKE THOSE, this makes me a bit dizzy i think
--vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Half window [d]own with staying in the middle' })
--vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Half window [u]p with staying in the middle' })
--vim.keymap.set("n", "n", "nzzzv", { desc = 'Stay in middle during [n]ext text search result' })
--vim.keymap.set("n", "N", "Nzzzv", { desc = 'Stay in middle during Previous text search result' })
--

vim.keymap.set("n", "<C-t>g", vim.cmd.TSCaptureUnderCursor)

local someQuery = [[
        SELECT id, twitch_id, github_id
        FROM users where id = ?1
]]

local otherQuery = [[
    INSERT INTO users (id, twitch_id, github_id)
    VALUES(?1,?2,?3) ON CONFLICT (id) DO
    UPDATE
    SET twitch_id=?2, github_id=?3
]]



local justAString = [[
 Just writing some things here
 Just looking whot it will do etc
 Very interesting
]]

-- dev etc
vim.keymap.set("n", "<leader>xx", function()
        vim.cmd("w")
        -- NOTE: source % didn't seem to give me all the output '
        --  neither does it this way, something in this function messes it up
        vim.cmd("so")
    end,
    { desc = "Runs the current file (similar to SO)" })
vim.keymap.set("n", "<leader>rt", "<Plug>PlenaryTestFile", { desc = "[r]un [t]ests for the current file" })



-- yanking to clipboard
-- TODO: reset the clipboard usage for pasting
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete to void" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete to void" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>", "<nop>", { desc = "Single leader press does nothing" })

--quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>", { desc = "Quickfix previous" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>", { desc = "Quickfix next within project?" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>", { desc = "Quickfix previous within project?" })
vim.keymap.set("n", "<leader>lt", vim.cmd.TodoQuickFix, { desc = "[L]ist [T]odos (quickfix)" })


-- prep for future use
--vim.keymap.set("n","<leader>ns","<cmd>silent !tmix neww tmux-sessionizer<CR>", { desc = "New tmux session" })
