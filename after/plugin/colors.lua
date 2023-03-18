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
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "NightflyRed" })
    --vim.api.nvim_set_hl(0, "DiganosticVirtualTextInfo", { link = "NightflyBlue" })
    --vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "NightflyWhite" })

    vim.g.nightflyCursorColor = true;
    vim.g.nightflyVirtualTextColor = true;
    vim.g.nightflyNormalFloat = true;
    vim.g.nightflyUnderlineMatchPran = true;
    vim.g.nightflyUndercurls = true;
end

-- TODO: something

ColorThemeNightfly()

-- treesitter colors
vim.api.nvim_set_hl(0, "@variable", { fg = "#cccccc" })
vim.api.nvim_set_hl(0, "@string", { fg = "#afd676" })
vim.api.nvim_set_hl(0, "@storageclass", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@constant.builtin", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@variable.builtin", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@constructor", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@include", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@type", { fg = "#d9c578" })
--vim.api.nvim_set_hl(0, "@type", { fg = "#cbbb7d" })
vim.api.nvim_set_hl(0, "@boolean", { link = "@number" })
vim.api.nvim_set_hl(0, "@conditional", { fg = "#67f6f9" })

-- brakets
vim.api.nvim_set_hl(0, "TSRainbowRed", { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "TSRainbowYellow", { fg = "#ffff00" })
vim.api.nvim_set_hl(0, "TSRainbowCyan", { link = "@conditional" })
vim.api.nvim_set_hl(0, "TSRainbowViolet", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "TSRainbowBlue", { link = "@function.call" })
vim.api.nvim_set_hl(0, "TSRainbowGreen", { fg = "#86ff1c" })


-- diff colors etc
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#0c2a59" })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#4a4502" })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "none", fg = "#d95a4e" })
