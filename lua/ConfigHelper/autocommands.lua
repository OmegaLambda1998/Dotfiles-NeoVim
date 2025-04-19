local Config = require("ConfigHelper.config")

---@alias autocommand { [1]: string | string[], [2]: table }

---Autocommand utilities
---@class AutoCommands: Config
---@field autocommands autocommand[]
---
---@field group fun(self: AutoCommands, name: string, opts: table?): integer
---@field create fun(self: AutoCommands, event: string | string[], args: table)
---@field on fun(self: AutoCommands, event: string | string[], callback: string | function, opts: table?)
---@field setup fun(self: AutoCommands)
local AutoCommands = {}
AutoCommands.interface = {}
AutoCommands.schema = {}
AutoCommands.metatable = {
    __index = AutoCommands.schema,
}

---AutoCommands Constructor
---@param self AutoCommands
---@return AutoCommands
function AutoCommands.prototype(self)
    self.autocommands = {}
    return self
end

---Create a new AutoCommands instance
---@return AutoCommands
function AutoCommands.interface.new()
    local self = setmetatable(Config.interface.new(), AutoCommands.metatable)
    AutoCommands.prototype(self)
    return self
end

--- AutoCommands Class Methods ---

---Create a new augroup
---@param name string
---@param opts table?
---@return integer
function AutoCommands.schema:group(name, opts)
    opts = vim.tbl_deep_extend(
        "force", {
            clear = true,
        }, opts or {}
    )
    local group = "OL" .. name:gsub("OL", ""):gsub("^%l", string.upper)
    return vim.api.nvim_create_augroup(group, opts)
end

---Create a new autocommand
---@param event string | string[]
---@param args table
function AutoCommands.schema:create(event, args)
    vim.api.nvim_create_autocmd(event, args)
end

---Setup new autocommand
---@param event string | string[]
---@param callback string | function
---@param opts table?
function AutoCommands.schema:on(event, callback, opts)
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
        local group = args.group --[[@as string]]
        args.group = self:group(group)
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

function AutoCommands.schema:setup()
    for _, autocommand in ipairs(self.autocommands) do
        self:create(unpack(autocommand))
    end
end

return AutoCommands.interface
