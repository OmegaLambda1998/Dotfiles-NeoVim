local M = {
    autocommands = {},
}

function M.group(name, opts)
    opts = vim.tbl_deep_extend(
        "force", {
            clear = true,
        }, opts or {}
    )
    local group = "OL" .. name:gsub("OL", ""):gsub("^%l", string.upper)
    return vim.api.nvim_create_augroup(group, opts)
end

function M:create(event, args)
    vim.api.nvim_create_autocmd(event, args)
end

function M:on(event, callback, opts)
    if type(callback) == "string" then
        callback = function()
            vim.cmd(callback)
        end
    end
    local args = vim.tbl_deep_extend(
        "force", {
            callback = callback,
        }, opts or {}
    )
    if args.group and type(args.group) == "string" then
        args.group = M.group(args.group)
    end
    table.insert(
        self.autocommands, {
            event,
            args,
        }
    )
    if CFG.is_setup then
        self:create(event, args)
    end
end

function M:setup()
    for _, autocommand in ipairs(self.autocommands) do
        self:create(unpack(autocommand))
    end
end

return M
