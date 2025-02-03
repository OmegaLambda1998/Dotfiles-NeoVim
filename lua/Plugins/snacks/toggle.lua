local M = {}

local opts = {
    enabled = true,
    map = function(mode, lhs, rhs, o)
        o.mode = mode
        local cfg = {
            lhs,
            rhs,
        }
        for k, v in pairs(o) do
            cfg[k] = v
        end
        CFG.key:map(cfg)
    end,
    which_key = true,
    notify = true,
}

local key = "<leader>t"
function M.setup(snacks)
    snacks.opts.toggle = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    key,
                    desc = "Toggle",
                    group = "Toggle",
                }
            )
            Snacks.toggle.option(
                "relativenumber", {
                    name = "Relative Number",
                }
            ):map(key .. "n")
            Snacks.toggle.animate():map(key .. "a")
            Snacks.toggle.diagnostics():map(key .. "d")
            Snacks.toggle.inlay_hints():map(key .. "i")
            Snacks.toggle.treesitter():map(key .. "r")
            Snacks.toggle.words():map(key .. "w")
        end
    )
    return snacks
end

return M
