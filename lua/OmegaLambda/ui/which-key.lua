local spec, opts = OL.spec:add("folke/which-key.nvim")

spec.cond = true

OL.callbacks.colourscheme.which_key = true

opts.preset = "helix"
-- Delay before showing the popup. Can be a number or a function that returns a number.
opts.delay = function(ctx)
    return ctx.plugin and 0 or 50
end
opts.filter = function(mapping)
    return mapping.desc and mapping.desc ~= ""
end
--- You can add any mappings here, or use `require('which-key').add()` later
opts.spec = {}
-- show a warning when issues were detected with your mappings
opts.notify = true
-- Which-key automatically sets up triggers for your mappings.
-- But you can disable this and setup the triggers manually.
-- Check the docs for more info.
opts.triggers = {
    {
        "<auto>",
        mode = "nixsotc",
    },
}
-- Start hidden and wait for a key to be pressed before showing the popup
-- Only used by enabled xo mapping modes.
opts.defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
end
opts.plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
        operators = true, -- adds help for operators like d, y, ...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
    },
}
opts.win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1,
    2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "right",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
}
opts.layout = {
    width = {
        min = 20,
    }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
}
opts.keys = {
    scroll_down = "<Down>", -- binding to scroll down inside the popup
    scroll_up = "<Up>", -- binding to scroll up inside the popup
}
--- Mappings are sorted using configured sorters and natural sort of the keys
--- Available sorters:
--- * local: buffer-local mappings first
--- * order: order of the items (Used by plugins like marks / registers)
--- * group: groups last
--- * alphanum: alpha-numerical first
--- * mod: special modifier keys last
--- * manual: the order the mappings were added
--- * case: lower-case first
opts.sort = {
    "local",
    "order",
    "group",
    "desc",
    -- "alphanum",
    "mod",
}
opts.expand = 0 -- expand groups when <= n mappings
-- expand = function(node)
--   return not node.desc -- expand all nodes without a description
-- end,
-- Functions/Lua Patterns for formatting the labels
opts.replace = {
    key = {
        function(key)
            return require("which-key.view").format(key)
        end,
        -- { "<Space>", "SPC" },
    },
    desc = {
        {
            "<Plug>%(?(.*)%)?",
            "%1",
        },
        { "^%+", "" },
        {
            "<[cC]md>",
            "",
        },
        {
            "<[cC][rR]>",
            "",
        },
        {
            "<[sS]ilent>",
            "",
        },
        {
            "^lua%s+",
            "",
        },
        {
            "^call%s+",
            "",
        },
        {
            "^:%s*",
            "",
        },
    },
}
opts.icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    -- set to false to disable all mapping icons,
    -- both those explicitly added in a mapping
    -- and those from rules
    mappings = true,
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons from rules
    rules = {
        {
            pattern = "flash",
            icon = "⚡",
            color = "yellow",
        },

        {
            pattern = "error",
            icon = " ",
            color = "red",
        },
        {
            pattern = "warn",
            icon = " ",
            color = "orange",
        },
        {
            pattern = "info",
            icon = " ",
            color = "blue",
        },
        {
            pattern = "hint",

            icon = " ",
            color = "cyan",
        },
    },
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
    },
}
opts.show_help = true -- show a help message in the command line for using WhichKey
opts.show_keys = true -- show the currently pressed key and its label as a message in the command line
-- disable WhichKey for certain buf types and file types.
opts.disable = {
    ft = {},
    bt = {},
}
opts.debug = false -- enable wk.log in the current directory

OL.g("mapleader", ",")
OL.g("maplocalleader", ".")

local function keyhelp(global)
    OL.load(
        "which-key", {}, function(wk)
            wk.show(
                {
                    global = global,
                }
            )
        end
    )
end

OL.map(
    {
        group = "Local Leader",
        mode = { "n" },
        {
            "<localleader><localleader>",
            function()
                keyhelp(false)
            end,
            desc = "Buffer Local keymaps",
        },
    }
)

OL.map(
    {
        mode = { "n" },
        group = "Leader",
        {
            {
                "<leader><leader>",
                function()
                    keyhelp(true)
                end,
                desc = "Global keymaps",
            },
        },
    }
)
