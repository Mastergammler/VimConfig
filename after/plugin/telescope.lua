local tele = require('telescope')
local builtin = require('telescope.builtin')

tele.setup {
    defaults = {
        mappings = {
            i = {
                    ["<C-j>"] = require('telescope.actions').move_selection_next,
                    ["<C-k>"] = require('telescope.actions').move_selection_previous,
                    ["<C-x>"] = require('telescope.actions').select_default
            },
        },
    },
}

-- file searching
vim.keymap.set('n', '<leader>ff', builtin.find_files,
    { desc = '[F]ind [f]iles (opend dir)' })
vim.keymap.set('n', '<leader><leader>', builtin.git_files,
    { desc = 'Find git files (untracked are ignored!)' })
vim.keymap.set('n', '<leader>?', builtin.oldfiles,
    { desc = '[?] Find recently opened files' })

-- symbol / word searching
vim.keymap.set('n', "<leader>ss", "<cmd>Telescope live_grep<cr>",
    { noremap = true, silent = true, desc = '[S]earch [s]ymbols in the current dir. But live' })
vim.keymap.set('n', '<leader>ps',
    function()
        builtin.grep_string({ search = vim.fn.input("grep > ") })
    end,
    { desc = '[P]roject [s]earch - symbols in current dir. (Requires ripgrep)' })
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = '[L]ist document [s]ymbols' })
-- whats the difference to life grep?
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord (in file?)' })
vim.keymap.set('n', '<leader>/',
    function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end,
    { desc = '[/] Fuzzily search in current buffer' })

-- util searching
vim.keymap.set('n', '<leader>lb', builtin.buffers,
    { desc = '[L]ist existing [b]uffers' })
vim.keymap.set('n', '<leader>?', builtin.keymaps, { desc = "searches all defined keymaps" })
vim.keymap.set('n', '<leader>hh', builtin.help_tags, { desc = '[H]elp documents' })
vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = '[L]ist [Diagnostics] (for the project)' })
vim.keymap.set('n', '<leader>rr', builtin.lsp_references, { desc = '[R]efe[r]ences display' })
