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
    },
    {
        "T",
        desc = "Flash Jump Backward",
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

flash.opts.modes = {}
flash.opts.modes.char = {
    enabled = true,
    config = function(opts)
        --- Autohide flash when in operator-pending mode
        opts.autohide = opts.autohide or
                            (vim.fn.mode(true):find("no") and vim.v.operator ==
                                "y")
        opts.highlight.backdrop = vim.fn.mode(true):find("o")
        --- Disable jump labels when using a count, or when recoding / executing registers
        opts.jump_labels = opts.jump_labels and vim.v.count == 0 and
                               vim.fn.reg_executing() == "" and
                               vim.fn.reg_recording() == ""
    end,
    autohide = false,
    jump_labels = true,
    label = {
        exclude = "hjkliardcx",
    },
    char_actions = function(motion)
        return {
            [";"] = "next",
            [","] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
        }
    end,
    search = {
        wrap = false,
        incremental = false,
    },
    highlight = {
        backdrop = true,
    },
    jump = {
        register = false,
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
