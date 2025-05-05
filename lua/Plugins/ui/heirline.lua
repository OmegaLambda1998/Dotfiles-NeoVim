local heirline = CFG.spec:add("rebelot/heirline.nvim")
heirline.event = {
    "VeryLazy",
}
heirline.dependencies = {
    "Zeioth/heirline-components.nvim",
}

heirline.pre:insert(
    function(opts)
        local lib = require("heirline-components.all")
        lib.init.subscribe_to_events()
        require("heirline").load_colors(lib.hl.get_colors())

        opts.statusline = {
            lib.component.mode(),
            lib.component.virtual_env(),
            lib.component.file_info(
                {
                    filetype = false,
                    filename = {},
                    file_modified = {},
                }
            ),

            lib.component.fill(),
            lib.component.cmd_info(),
            lib.component.fill(),

            lib.component.lsp(),
            lib.component.treesitter(),
            lib.component.nav(),
        }

        return opts
    end
)

heirline.post:insert(
    function()
        --- Initial Settings
        vim.opt.cmdheight = 0
        vim.opt.laststatus = 3
    end
)
