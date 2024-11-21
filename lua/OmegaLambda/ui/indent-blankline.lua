local spec, opts = OL.spec:add("lukas-reineke/indent-blankline.nvim")

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
    local hooks = OL.load("ibl.hooks")
    hooks.register(
      hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(
            0, "RainbowRed", {
                fg = "#E06C75",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowYellow", {
                fg = "#E5C07B",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowBlue", {
                fg = "#61AFEF",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowOrange", {
                fg = "#D19A66",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowGreen", {
                fg = "#98C379",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowViolet", {
                fg = "#C678DD",
            }
          )
          vim.api.nvim_set_hl(
            0, "RainbowCyan", {
                fg = "#56B6C2",
            }
          )
      end
    )
    vim.g.rainbow_delimiters = vim.tbl_deep_extend(
                                 "force", vim.g.rainbow_delimiters or {}, {
          highlight = highlight,
      }
                               )
    OL.load_setup("ibl", {}, o)
    hooks.register(
      hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark
    )

end
