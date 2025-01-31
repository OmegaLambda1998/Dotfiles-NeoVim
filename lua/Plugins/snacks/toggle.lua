local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.toggle = opts
    if snacks.opts.enabled then
        snacks.post:insert(
            function()
                local Snacks = require("snacks")
                CFG.key:map(
                    {
                        "<leader>t",
                        mode = {
                            "n",
                        },
                        group = "Toggle",
                        desc = "Toggle",
                        {
                            "<leader>ta",
                            function()
                                Snacks.toggle.animate()
                            end,
                            desc = "Animate",
                        },
                        {
                            "<leader>td",
                            function()
                                Snacks.toggle.diagnostics()
                            end,
                            desc = "Diagnostics",
                        },
                        {
                            "<leader>ti",
                            function()
                                Snacks.toggle.inlay_hints()
                            end,
                            desc = "Inlay Hints",
                        },
                        {
                            "<leader>tt",
                            function()
                                Snacks.toggle.treesitter()
                            end,
                            desc = "Treesitter",
                        },
                        {
                            "<leader>tw",
                            function()
                                Snacks.toggle.words()
                            end,
                            desc = "Words",
                        },

                    }
                )
            end
        )
    end
    return snacks
end

return M
