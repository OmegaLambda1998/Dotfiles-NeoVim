local snacks = CFG.spec:add("folke/snacks.nvim")

snacks.priority = 1000
snacks.cond = true
snacks.lazy = false
local modules = {
    "animate",
    "bigfile",
    --- "bufdelete",
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
    --- "scratch", --- TODO: KMdS
    "scroll",
    "statuscolumn",
    "terminal",
    "toggle",
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

CFG.colourscheme:set("snacks")
