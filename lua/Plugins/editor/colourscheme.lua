local colourscheme = CFG.spec:add("catppuccin/nvim")

colourscheme.name = "catppuccin"
colourscheme.main = "catppuccin"
colourscheme.lazy = false
colourscheme.cond = true
colourscheme.priority = 1001
colourscheme.dependencies = {
    {
        "nvim-tree/nvim-web-devicons",
        cond = true,
    },
}

CFG.colourscheme = {
    integrations = {},
    highlights = {},
    opts = {},
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

colourscheme.opts = CFG.colourscheme.opts

colourscheme.opts.integrations = CFG.colourscheme.integrations
colourscheme.opts.highlight_overrides = {
    all = CFG.colourscheme.highlights,
}

colourscheme.opts.transparent_background = true
colourscheme.opts.default_integrations = false

colourscheme.opts.flavour = "mocha"
colourscheme.opts.term_colors = true
