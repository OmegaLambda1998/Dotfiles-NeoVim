local M = {}

local opts = {
    enabled = true,
    left = { "sign" },
    right = { "fold" },
    folds = {
        open = true,
    },
    refresh = 500,
}

function M.setup(snacks)
    snacks.opts.statuscolumn = opts
    return snacks
end

return M
