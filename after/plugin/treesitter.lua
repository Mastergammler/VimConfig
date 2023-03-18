require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "help", "cpp", "javascript", "typescript", "json", "java", "haskell", "html", "c_sharp" },


    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    ignore_install = { "c", "cpp" },

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    rainbow = {
        enable = true,
        extended_mode = false,
        termcolors = {
            "#ffff66",
            "#66ff66",
            "#33ccff",
            "#ff66ff",
            "#ff9966",
            "#00ffcc",
            "#cc00ff"
        },
        colors = {
            "#ffff66",
            "#66ff66",
            "#33ccff",
            "#ff66ff",
            "#ff9966",
            "#00ffcc",
            "#cc00ff"
        }
    },

    indent = { enable = true },
    incremental_selection = {
        enabled = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-[>',
            node_decremental = '<c-]>'
        }
    }
}
