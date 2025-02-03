local flash = CFG.spec:add("folke/flash.nvim")

flash.keys = {
    {
        "/",
        desc = "Flash Search Forward",
    },
    {
        "?",
        desc = "Flash Search Backward",
    },
    {
        "t",
        desc = "Flash Jump Forward",
        mode = { "n" },
    },
    {
        "T",
        desc = "Flash Jump Backward",
        mode = { "n" },
    },
    {
        "f",
        desc = "Flash Jump Forward",
    },
    {
        "F",
        desc = "Flash Jump Backward",
    },
    {
        ";",
        mode = {
            "v",
            "x",
            "o",
            "s",
        },
        desc = "Flash Next",
    },
    {

        ",",
        mode = {
            "v",
            "x",
            "o",
            "s",
        },
        desc = "Flash Prev",
    },
}

local keys = {
    {
        "s",
        function()
            require("flash").treesitter_search()
        end,
        mode = {
            "n",
            "v",
            "x",
            "o",
            "s",
        },
        desc = "Flash Treesitter Search",
    },
    {
        "S",
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter Select",
        mode = {
            "n",
            "v",
            "x",
            "o",
            "s",
        },
    },
}
vim.list_extend(flash.keys, keys)

flash.opts.search = {
    mode = "fuzzy",
    incremental = true,
}

flash.opts.label = {
    current = false,
    style = "inline",
    rainbow = {
        enabled = true,
        shade = 9,
    },
}

flash.opts.mode = {}
flash.opts.mode.char = {
    autohide = false,
    jump_labels = true,
    label = {
        exclude = "hjkliardcx",
    },
    jump = {
        autojump = true,
    },
}

CFG.key:map(
    {
        group = "Flash",
        keys,
    }
)

CFG.colourscheme:set("flash")

