local M = {
    usercommands = {},
}

function M:fn(name, callback, opts)
    name = "OL" .. name:gsub("OL", ""):gsub("^%l", string.upper)
    if type(callback) == "string" then
        callback = function()
            vim.cmd(callback)
        end
    end
    local args = vim.tbl_deep_extend("force", {}, opts or {})
    table.insert(
        self.usercommands, {
            name,
            callback,
            args,
        }
    )
end

function M:create(name, callback, args)
    vim.api.nvim_create_user_command(name, callback, args)
end

function M:setup()
    for _, usercommand in ipairs(self.usercommands) do
        self:create(unpack(usercommand))
    end
end

return M
