function ColorThemeRosePine(color)
    color = color or 'rose-pine'
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "#031024" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorThemeNightfly(color)
    color = color or 'nightfly'
    vim.cmd.colorscheme(color)

    --vim.api.nvim_set_hl(0,"Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#807b69" })
    --vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "NightflyRed" })
    --vim.api.nvim_set_hl(0, "DiganosticVirtualTextInfo", { link = "NightflyBlue" })
    --vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "NightflyWhite" })

    vim.g.nightflyCursorColor = true;
    vim.g.nightflyVirtualTextColor = true;
    vim.g.nightflyNormalFloat = true;
    vim.g.nightflyUnderlineMatchPran = true;
    vim.g.nightflyUndercurls = true;
end

ColorThemeNightfly()

vim.api.nvim_set_hl(0, "Boolean", { fg = "#f79d28" })
vim.api.nvim_set_hl(0, "@public.cs", { fg = "#f79d28" })

print("Colors are applied")
