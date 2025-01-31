local M = {}
local opts = {
    enabled = true,
}

opts.indent = {
    enabled = true,
    priority = 200,
    only_scope = false,
    only_current = false,
    hl = {
        "SnacksIndent1",
        "SnacksIndent2",
        "SnacksIndent3",
        "SnacksIndent4",
        "SnacksIndent5",
        "SnacksIndent6",
        "SnacksIndent7",
        "SnacksIndent8",
    },
    char = ".",
}

opts.animate = {
    enabled = true,
    duration = {
        step = 10,
        total = 300,
    },
}

opts.scope = {
    enabled = true,
    priority = opts.indent.priority,
    underline = true,
    only_current = opts.indent.only_current,
    hl = opts.indent.hl,
    char = "",
}

opts.chunk = {
    enabled = true,
    priority = opts.indent.priority,
    underline = true,
    only_current = opts.indent.only_current,
    hl = opts.indent.hl,
    char = {
        --- corner_top = "┌",
        --- corner_bottom = "└",
        corner_top = "╭",
        corner_bottom = "╰",
        horizontal = "─",
        vertical = "│",
        arrow = ">",
    },
}

function M.setup(snacks)
    snacks.opts.indent = opts
    snacks.post:insert(
        function()
            CFG.set:opt("expandtab")
            CFG.set:opt("shiftround")
            CFG.set:opt("shiftwidth", 4)
        end
    )
    return snacks
end

return M
