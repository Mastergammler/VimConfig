function ColorThemeRosePine(color)
	color = color or 'rose-pine'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0,"Normal", { bg = "#031024" })
	vim.api.nvim_set_hl(0,"NormalFloat", { bg = "none" })
end

function ColorThemeNightfly(color)
    color = color or 'nightfly'
    vim.cmd.colorscheme(color)

    -- vim.api.nvim_set_hl(0,"Normal", { bg = "none" })
    vim.api.nvim_set_hl(0,"NormalFloat",{ bg = "none" })
    
end

ColorThemeNightfly()
