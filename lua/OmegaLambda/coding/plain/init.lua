local filetype = "*"
local _ft = "plain"

OL.callbacks.lsp.ft:add(filetype)
--- Lint
local linter = "typos"
local linter_config = "typos.toml"
OL.callbacks.lint.ft:add(filetype)
OL.callbacks.lint:add(
    filetype, linter, {
        prepend_args = {
            "--config=" .. OL.paths.coding:abs(_ft, linter_config),
        },
    }
)

OL.callbacks.cmp.ft:add(filetype)

OL.spec:add(
    "mikavilpas/blink-ripgrep.nvim", {
        config = function()
        end,
    }
)
OL.callbacks.cmp:add(
    "ripgrep", {
        name = "Ripgrep",
        module = "blink-ripgrep",
        enabled = function(_)
            return true
        end,
    }
)

OL.spec:add(
    "amarakon/nvim-cmp-lua-latex-symbols", {
        config = function()
        end,
    }
)
OL.callbacks.cmp:compat(
    "amarakon/nvim-cmp-lua-latex-symbols", "lua-latex-symbols", {
        name = "lua-latex-symbols",
        enabled = function(_)
            return true
        end,
        score_offset = -10,
    }
)
