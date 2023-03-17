require("diffview").setup {
    -- this doesn't support inline diff?!

    -- TODO: toggle functionality?
    -- And add number input for how many commits to include
    vim.keymap.set("n", "<leader>sd", vim.cmd.DiffviewOpen, { desc = "[S]how [D]iffview (git)" }),
    vim.keymap.set("n", "<leader>cd", vim.cmd.DiffviewClose, { desc = "[C]lose [D]iffview " })
}
