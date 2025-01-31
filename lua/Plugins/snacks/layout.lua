local M = {}
local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.layout = opts
    return snacks
end

return M
