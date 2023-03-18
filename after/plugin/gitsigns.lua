require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}
