local snacks = CFG.spec:add("folke/snacks.nvim")

snacks.priority = 1000
snacks.cond = true
snacks.lazy = false
snacks.dependencies = {
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "echasnovski/mini.icons",
    },
}

local modules = {
    "animate",
    "bigfile",
    "bufdelete",
    --- "dashboard",
    "debug",
    --- "dim",
    --- "git",
    --- "gitbrowse",
    "indent",
    "input",
    "layout",
    --- "lazygit",
    "notifier",
    "notify",
    "picker",
    "quickfile",
    --- "rename",
    "scope",
    --- "scratch", --- TODO: Neorg
    "scroll",
    "statuscolumn",
    "terminal",
    "toggle", --- TODO: Fucking Broken
    --- "util",
    --- "win",
    "words",
    --- "zen"
}

if CFG.profile then
    table.insert(modules, "profiler")
end

for _, module in ipairs(modules) do
    snacks = require("Plugins.snacks." .. module).setup(snacks)
end
