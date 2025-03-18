local M = {}

local opts = {
    enabled = not CFG.is_pager(),
    sections = {
        {
            section = "header",
        },
        { --- TODO: Make pretty
            pane = 2,
            section = "terminal",
            cmd = "pwd",
            height = 5,
            padding = 1,
        },
        {
            section = "keys",
            gap = 1,
            padding = 1,
        },
        {
            pane = 2,
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
        },
        {
            pane = 2,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
        },
        {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
                return require("snacks").git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
        },
        {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
                return require("snacks").git.get_root() == nil
            end,
            cmd = "(type gh &> /dev/null) && gh status",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
        },
        {
            section = "startup",
        },
    },
}

function M.setup(snacks)
    snacks.opts.dashboard = opts
    return snacks
end

return M
