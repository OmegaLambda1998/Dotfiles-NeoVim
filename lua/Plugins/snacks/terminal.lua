local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.terminal = opts
    return snacks
end

return M
