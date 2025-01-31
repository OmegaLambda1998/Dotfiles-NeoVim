local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.quickfile = opts
    return snacks
end

return M
