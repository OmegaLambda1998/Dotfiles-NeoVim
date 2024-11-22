local spec, opts = OL.spec:add("lukas-reineke/indent-blankline.nvim")

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "lukas-reineke/indent-blankline.nvim",
    }
)

OL.callbacks.colourscheme.indent_blankline = {
    enabled = true,
    colored_indent_levels = true,
}

spec.main = "ibl"
spec.event = "VeryLazy"

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

opts.indent = {
    highlight = highlight,
    char = ".",
}

opts.whitespace = {
    highlight = highlight,
}

opts.scope = {
    enabled = true,
    highlight = highlight,
}

function spec.config(_, o)
    OL.load(
        "ibl.hooks", {}, function(hooks)
            OL.load_setup("ibl", {}, o)
            hooks.register(
                hooks.type.SCOPE_HIGHLIGHT,
                hooks.builtin.scope_highlight_from_extmark
            )
        end
    )
    OL.g(
        "rainbow_delimiters", vim.tbl_deep_extend(
            "force", vim.g.rainbow_delimiters or {}, {
                highlight = highlight,
            }
        )
    )
end
