local M = {}

local opts = {
    enabled = true,
}

opts.style = "fancy"

function M.setup(snacks)
    snacks.opts.notifier = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>n",
                    mode = {
                        "n",
                    },
                    group = "Notififications",
                    desc = "Notifications",
                    {
                        "<leader>nn",
                        function()
                            Snacks.notifier.show_history(
                                {
                                    reverse = false,
                                }
                            )
                        end,
                        desc = "Show",
                    },
                    {
                        "<leader>nc",
                        function()
                            Snacks.notifier.hide()
                        end,
                        desc = "Clear",
                    },

                }
            )
        end
    )
    return snacks
end

return M
