local M = {}

local opts = {
    enabled = true,
    animate = {
        step = 10,
        total = 50,
    },
}

function M.setup(snacks)
    snacks.opts.scroll = opts
    return snacks
end

return M
