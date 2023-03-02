local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'eslint',
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-h>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-l>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = 
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                { underline = true })
        

lsp.on_attach(function(client,bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n","gd",function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n","gi",function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("n","K",function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n","<leader>vws",function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n","<leader>ee",function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n","<leader>en",function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n","<leader>ep",function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n","<leader>.",function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n","<leader>rr",function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n","<leader>R",function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i","<C-?>",function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
