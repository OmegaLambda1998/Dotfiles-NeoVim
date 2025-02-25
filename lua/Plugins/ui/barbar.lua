local barbar = CFG.spec:add("romgrk/barbar.nvim")

barbar.event = {
    "VeryLazy",
}
barbar.dependencies = {
    "nvim-tree/nvim-web-devicons",
}

barbar.opts.highlight_alternate = false
barbar.opts.highlight_inactive_file_icons = true

barbar.opts.icons = {
    buffer_index = true,
}
local lsp = CFG.spec:get("nvim-lspconfig")
if lsp then
    local icons = lsp.opts.diagnostics.signs.text
    barbar.opts.icons.diagnostics = {}
    for severity, icon in pairs(icons) do
        barbar.opts.icons.diagnostics[severity] = {
            enabled = true,
            icon = icon,
        }
    end
end

barbar.opts.icons.filetypes = {
    custom_colors = true,
    enabled = true,
}

barbar.opts.icons.pinned = {
    button = "",
    filename = true,
}

barbar.pre:insert(
    function(opts)
        --- disable auto-setup
        CFG.set:g("barbar_auto_setup", false)
        return opts
    end
)

barbar.post:insert(
    function()
        CFG.key:map(
            {
                "<C>",
                mode = {
                    "n",
                },
                desc = "Buffer",
                group = "Buffer",
                {
                    "<C-h>",
                    ":BufferPrevious<CR>",
                    desc = "Previous",
                },
                {
                    "<C-l>",
                    ":BufferNext<CR>",
                    desc = "Next",
                },
                {
                    "<C-Space>",
                    ":BufferPin<CR>",
                    desc = "Pin",
                },
                {
                    "<C-p>",
                    ":BufferPick<CR>",
                    desc = "Pick",
                },
                {
                    "<C-d>",
                    ":BufferWipeout<CR>",
                    desc = "Close",
                },
            }
        )
    end
)

CFG.colourscheme:set("barbar")
local statuses = {
    "BufferCurrent",
    "BufferAlternate",
    "BufferInactive",
    "BufferVisible",
}
local parts = {
    "ADDED",
    "Btn",
    "CHANGED",
    "DELETED",
    "ERROR",
    "HINT",
    "Icon",
    "Index",
    "INFO",
    "Mod",
    "ModBtn",
    "Number",
    "Pin",
    "PinBtn",
    "Sign",
    "SignRight",
    "Target",
    "WARN",
}
local hl_groups = {
    "BufferOffset",
    "BufferScrollArrow",
    "BufferTabpageFill",
    "BufferTabpages",
    "BufferTabpagesSep",
}
for _, status in ipairs(statuses) do
    table.insert(hl_groups, status)
    for _, part in ipairs(parts) do
        table.insert(hl_groups, status .. part)
    end
end
for _, hl in ipairs(hl_groups) do
    CFG.colourscheme:hl(
        hl, {
            bg = "none",
        }
    )
end
