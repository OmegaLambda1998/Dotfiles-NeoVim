local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.bufdelete = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<A-d>",
                    mode = {
                        "n",
                    },
                    group = "Delete Buffer",
                    desc = "Delete Buffers",
                    {
                        "<A-d>d",
                        function()
                            Snacks.bufdelete(
                                {
                                    wipe = true,
                                }
                            )
                        end,
                        desc = "Current Buffer",
                    },
                    {
                        "<A-d>o",
                        function()
                            Snacks.bufdelete.other(
                                {
                                    wipe = true,
                                }
                            )
                        end,
                        desc = "All Other Buffers",
                    },
                    {
                        "<A-d>a",
                        function()
                            Snacks.bufdelete.all(
                                {
                                    wipe = true,
                                }
                            )
                        end,
                        desc = "All Buffers",
                    },

                }
            )
        end
    )
    return snacks
end

return M
