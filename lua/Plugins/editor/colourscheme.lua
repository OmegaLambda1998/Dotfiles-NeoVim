local colourscheme = CFG.spec:add("catppuccin/nvim")

colourscheme.name = "catppuccin"
colourscheme.main = "catppuccin"
colourscheme.lazy = false
colourscheme.priority = 1001
colourscheme.dependencies = {
    {
        "nvim-tree/nvim-web-devicons",
    },
}

CFG.colourscheme = {
    integrations = {},
    highlights = {},
    name = colourscheme.name,
}
function CFG.colourscheme:set(name, opts)
    if opts == nil then
        opts = true
    end
    CFG.colourscheme.integrations[name] = opts
end
function CFG.colourscheme:hl(name, opts)
    CFG.colourscheme.highlights[name] = opts
end
colourscheme.opts.integrations = CFG.colourscheme.integrations
colourscheme.opts.highlight_overrides = {
    all = CFG.colourscheme.highlights,
}

colourscheme.opts.transparent_background = true
colourscheme.opts.default_integrations = false

colourscheme.opts.flavour = "mocha"
colourscheme.opts.term_colors = true
