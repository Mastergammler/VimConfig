function SetCustomColors(color)
	color = color or 'rose-pine'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0,"Normal", { bg = "#031024" })
	vim.api.nvim_set_hl(0,"NormalFloat", { bg = "none" })
end

SetCustomColors()
