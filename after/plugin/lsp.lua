local lsp = require("lsp-zero")


--lsp.configure('clangd',{
--    cmd = {"clangd","--background-index"},
--    on_attach = function(client,bufnr)
--        print("clangd says hello")
--    end,
--    flags = {
--        debounce_text_changes = 150
--    },
--    init_options = {
--        clangdFileStates = true,
--        usePlaceholders = true,
--        completeUnimported = true,
--        semanticHighlighting =true
--    },
--    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--})



lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
    -- TODO: what is this for????
        ['<M-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.configure('lemminx', {
    settings = {
        xml = {
            format = {
                splitAttributes = true,
                splitBeforeFirstAttribute = false,
                indentAttributes = true,
                splitAttributesIndentSize = 1,
                spaceBeforeEmptyCloseTag = true,
                preservedNewlines = 1,
                emptyElements = 'collapse'
            }
        }
        --["xml.format.splitAttributes"] = true,
        --["xml.format.preserveAttributeLineBreaks"] = true,
        --["xml.format.splitBeforeFirstAttribute"] = true,
    },
    single_file_support = true,
    on_attach = function(client, bufnr)
        print('lemminx init')
    end,
    -- FIXME: has no impact on the types
    filetypes = { "xml", "svg", "cshtml", "xaml" },
})




lsp.set_preferences({
    sign_icons = {
        error = '',
        hint = '',
        warn = '',
        info = ''
    }
})

--vim.lsp.handlers["textDocument/publishDiagnostics"] =
--   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
--      { underline = true })
--


lsp.on_attach(function(client, bufnr)
    print("履 READY TO ROCK 履")
    local options = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, options)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, options)
    vim.keymap.set("n", "<leader>ee", function() vim.diagnostic.open_float() end, options)
    vim.keymap.set("n", "<leader>en", function() vim.diagnostic.goto_next() end, options)
    vim.keymap.set("n", "<leader>ep", function() vim.diagnostic.goto_prev() end, options)
    vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, options)
    -- Defined by telescope becauese better overview + coloring
    -- vim.keymap.set("n","<leader>rr",function() vim.lsp.buf.references() end, opts)

    -- Rename and save everything, that i don't have to manually go through it again
    vim.keymap.set("n", "<leader>R", function()
        vim.lsp.buf.rename()
        vim.cmd("wall")
    end, options)
    vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, options)
    vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, options)
end)

lsp.setup()
