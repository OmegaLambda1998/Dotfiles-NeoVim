--- Dependencies ---
OL.spec:add(
    "nvim-neorg/lua-utils.nvim", {
        config = function(_, o)
        end,
    }
)
OL.spec:add(
    "MunifTanjim/nui.nvim", {
        config = function(_, o)
        end,
    }
)
OL.spec:add(
    "nvim-neotest/nvim-nio", {
        config = function(_, o)
        end,
    }
)
OL.spec:add(
    "pysan3/pathlib.nvim", {
        config = function(_, o)
        end,
    }
)
local spec, opts = OL.spec:add("nvim-neorg/neorg")

spec.cmd = {
    "Neorg",
    "NeorgStart",
}
spec.ft = { "norg" }

opts.load = {}
opts.load["core.clipboard.code-blocks"] = {}
opts.load["core.concealer"] = {
    folds = true,
    icon_preset = "varied",
    icons = {},
}
opts.load["core.dirman"] = {
    config = {
        workspaces = {
            home = "~/neorg",
            thesis = "~/User/Astrophysics/PhD/Thesis/Patrick-Armstrong-Thesis",
        },
        index = "index.norg",
    },
}
opts.load["core.esupports.hop"] = {}
opts.load["core.esupports.indent"] = {}
opts.load["core.esupports.metagen"] = {}
opts.load["core.export"] = {}
opts.load["core.highlights"] = {}
opts.load["core.integrations.treesitter"] = {}
opts.load["core.itero"] = {}
opts.load["core.journal"] = {}
opts.load["core.keybinds"] = {}
opts.load["core.looking-glass"] = {}
opts.load["core.neorgcmd"] = {}
opts.load["core.neorgcmd.commands.return"] = {}
opts.load["core.pivot"] = {}
opts.load["core.promo"] = {}
opts.load["core.qol.toc"] = {}
opts.load["core.qol.todo_items"] = {}
opts.load["core.storage"] = {}
opts.load["core.syntax"] = {}
opts.load["core.tangle"] = {}
opts.load["core.text-objects"] = {}
opts.load["core.todo-introspector"] = {}
opts.load["core.ui.calendar"] = {}
