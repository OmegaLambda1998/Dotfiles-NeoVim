local spec, opts = OL.spec:add("lewis6991/gitsigns.nvim")

OL.callbacks.colourscheme.gitsigns = true

opts.signs = {
    add = {
        text = "┃",
    },
    change = {
        text = "┃",
    },
    delete = {
        text = "_",
    },
    topdelete = {
        text = "‾",
    },
    changedelete = {
        text = "~",
    },
    untracked = {
        text = "┆",
    },
}
opts.signs_staged = {
    add = {
        text = "┃",
    },
    change = {
        text = "┃",
    },
    delete = {
        text = "_",
    },
    topdelete = {
        text = "‾",
    },
    changedelete = {
        text = "~",
    },
    untracked = {
        text = "┆",
    },
}
opts.signs_staged_enable = true
opts.signcolumn = false -- Toggle with `:Gitsigns toggle_signs`
opts.numhl = true -- Toggle with `:Gitsigns toggle_numhl`
opts.linehl = false -- Toggle with `:Gitsigns toggle_linehl`
opts.word_diff = false -- Toggle with `:Gitsigns toggle_word_diff`
opts.watch_gitdir = {
    follow_files = true,
}
opts.auto_attach = true
opts.attach_to_untracked = false
opts.current_line_blame = true -- Toggle with `:Gitsigns toggle_current_line_blame`
opts.current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
}
opts.current_line_blame_formatter = "<author>, <author_time:%R> - <summary>"
opts.sign_priority = 6
opts.update_debounce = 100
opts.status_formatter = nil -- Use default
opts.max_file_length = 40000 -- Disable if file is longer than this (in lines)
opts.preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
}
