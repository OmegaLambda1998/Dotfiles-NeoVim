local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.input = opts
    return snacks
end

return M
