-- I don't want it to show up at startup
--vim.g.nvim_tree_hijack_netrw = false

require("nvim-tree").setup
{
    sort_by = "case_sensitive",
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
        custom = {
            "**/bin",
            "**/obj"
        }

    },
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = false,
    hijack_unnamed_buffer_when_opening = false,
    open_on_setup = false,
    open_on_setup_file = false,
}
