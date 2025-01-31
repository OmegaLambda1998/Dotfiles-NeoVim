local M = {
    mappings = {},
}

function M:map(map)
    table.insert(self.mappings, map)
end

function M:create(map)
    local lhs = map.lhs or map[1]
    local rhs = map.rhs or map[2]
    if type(rhs) == "string" then
        rhs = function()
            vim.cmd(rhs)
        end
    end
    local mode = map.mode or {
        "n",
    }
    local opts = {}
    for k, v in pairs(map) do
        if not vim.tbl_contains(
            {
                1,
                2,
                "lhs",
                "rhs",
                "mode",
            }, k
        ) then
            opts[k] = v
        end
    end
    if type(rhs) == "function" then
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

function M:setup()
    for _, map in ipairs(self.mappings) do
        self:create(map)
    end
end

return M
