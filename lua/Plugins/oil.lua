local oil = CFG.spec:add("stevearc/oil.nvim")
oil.lazy = false

oil.opts.skip_confirm_for_simple_edits = true
oil.opts.lsp_file_methods = {
    autosave_changes = "unmodified",
}
oil.opts.watch_for_changes = true

oil.opts.view_options = {
    show_hidden = true,
}

oil.opts.keymaps = {
    ["q"] = {
        "actions.close",
        mode = "n",
    },
}

oil.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>o",
                function()
                    vim.cmd(":Oil")
                end,
                mode = {
                    "n",
                },
                desc = "Open (Oil)",
            }
        )
    end
)
