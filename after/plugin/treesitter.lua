local startTime = os.clock();
local nsUtils = require('examples.nsTest.testingFunctions')

local rainbow = require 'ts-rainbow'

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "help", "cpp", "javascript", "typescript", "json", "java", "haskell", "html",
        "c_sharp" },


    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    --ignore_install = { "c", "cpp" },

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, bufnr)
            return lang == "sql" and vim.api.nvim_buf_line_count(bufnr) > 500
        end
    },

    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" }
    },

    rainbow = {
        enable = true,
        query = {
            'rainbow-parens'
        },
        strategy = rainbow.strategy.global,
        hlgroups = {
            'TSRainbowViolet',
            'TSRainbowYellow',
            'TSRainbowBlue',
            --'TSRainbowGreen',
            'TSRainbowCyan',
            --'TSRainbowRed',
            --'TSRainbowOrange',
        },
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

--query.set_query('lua', "injections", "(comment) @field")

local endTime = os.clock()
--nsUtils.printExecutionTime(startTime, endTime)
--print("TS-time")
