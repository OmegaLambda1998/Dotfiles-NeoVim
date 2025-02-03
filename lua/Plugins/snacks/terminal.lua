local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.terminal = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>tt",
                    function()
                        Snacks.terminal()
                    end,
                    desc = "Toggle Terminal",
                }
            )
        end
    )
    return snacks
end

return M
