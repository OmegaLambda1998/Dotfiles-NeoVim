local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.animate = opts
    return snacks
end

return M
