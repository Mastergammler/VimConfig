-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Own dev plugins
    --use 'I:/02 Areas/Dev/Lua/stackmap-example-plugin'

    -- copilot testing
    --use { "zbirenbaum/copilot.lua" }

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- use 'nvim-tree/nvim-tree.lua'

    -- visual stuff
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                signs = false
            }
        end
    }

    use 'nordtheme/vim'

    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    }

    use('WhoIsSethDaniel/toggle-lsp-diagnostics.nvim')
    use { 'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim' }

    use {
        'bluz71/vim-nightfly-colors',
        as = 'nightfly',
        config = function()
            vim.cmd('colorscheme nightfly')
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- rainbow brackets for treesitter
    -- TODO: look how the styling is in VSC because that looks good
    use 'HiPhish/nvim-ts-rainbow2'


    -- navigation stuff etc
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    --use { "lunarmodules/luaexpat", rocks = "expat" }, rocks = "expat" }

    -- debugging
    use 'mfussenegger/nvim-dap'
    use 'leoluz/nvim-dap-go'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'numToStr/comment.nvim'

    use('m4xshen/autoclose.nvim')

    use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } })
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use("mbbill/undotree")
    use('tpope/vim-fugitive')
    use { 'lewis6991/gitsigns.nvim', tag = 'release' }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }
end)
