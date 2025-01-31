local M = {}

local join
function join(base, paths)
    local path = vim.fs.joinpath(base, unpack(paths))
    local config = vim.fs.joinpath(vim.fn.stdpath("config"), "lua")
    local mod = path:gsub(config, ""):gsub("/", "."):gsub("^.", "")
    return {
        path = path,
        mod = mod,
        join = function(paths)
            return join(path, paths)
        end,
    }
end

M.join = function(paths)
    return join(vim.fs.joinpath(vim.fn.stdpath("config"), "lua"), paths)
end

return M
