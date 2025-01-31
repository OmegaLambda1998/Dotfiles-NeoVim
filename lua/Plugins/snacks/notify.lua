local M = {}

local opts = {
    enabled = true,
}

local function inspect(...)
    local obj = {
        ...,
    }
    local len = #obj
    local caller = debug.getinfo(1, "S")
    for level = 2, 100 do
        local info = debug.getinfo(level, "S")
        if info ~= nil then
            if info.what == "Lua" and info.source ~= "lua" and
                not info.source:find("@" .. vim.fn.stdpath("config"), 0, true) then
                caller = info
                break
            end
        else
            break
        end
    end
    local title = vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" ..
                      caller.linedefined
    local str = {}
    for _, o in ipairs(obj) do
        if type(o) ~= "string" then
            o = vim.inspect(o)
        end
        table.insert(str, o)
    end

    return str, title
end

function M.setup(snacks)
    snacks.opts.notify = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            vim.print = function(...)
                local msg, title = inspect(...)
                Snacks.notify(
                    msg, {
                        title = title,
                    }
                )
            end
            print = vim.print
        end
    )
    return snacks
end

return M
