local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.scope = opts
    return snacks
end

return M
