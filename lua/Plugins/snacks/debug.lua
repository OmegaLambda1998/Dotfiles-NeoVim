local M = {}
local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.debug = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.dd = function(...)
                Snacks.debug.inspect(...)
            end
            CFG.bt = function()
                Snacks.debug.backtrace()
            end
        end
    )
    return snacks
end

return M
