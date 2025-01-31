local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.profiler = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>P",
                    mode = {
                        "n",
                    },
                    desc = "Profile",
                    group = "Profile",
                    {
                        "<leader>Pp",
                        function()
                            Snacks.profiler.toggle()
                        end,
                        desc = "Toggle Profiler",
                    },
                    {
                        "<leader>Ph",
                        function()
                            Snacks.profiler.highlight()
                        end,
                        desc = "Toggle Highlights",
                    },
                    {
                        "<leader>Po",
                        function()
                            Snacks.profiler.scratch()
                        end,
                        desc = "Scratch",
                    },
                }
            )
        end
    )
    return snacks
end

return M
