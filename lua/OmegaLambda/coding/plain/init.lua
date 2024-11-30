local filetype = "*"

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
        score_offset = -10,
        enabled = function(_)
            return true
        end,
    }
)
