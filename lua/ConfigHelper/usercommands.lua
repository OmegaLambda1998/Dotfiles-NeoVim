local Config = require("ConfigHelper.config")

---@alias usercommand { [1]: string, [2]: function, [3]: table }

---Usercommand utilities
---@class UserCommands: Config
---@field usercommands usercommand[]
---
---@field create fun(self: UserCommands, name: string, callback: function, args: table)
---@field fn fun(self: UserCommands, name: string, callback: string | function, opts: table?)
---@field setup fun(self: UserCommands)
local UserCommands = {}
UserCommands.interface = {}
UserCommands.schema = {}
UserCommands.metatable = {
    __index = UserCommands.schema,
}

---UserCommands Constructor
---@param self UserCommands
---@return UserCommands
function UserCommands.prototype(self)
    self.usercommands = {}
    return self
end

---Create a new UserCommands instance
---@return UserCommands
function UserCommands.interface.new()
    local self = setmetatable(Config.interface.new(), UserCommands.metatable)
    UserCommands.prototype(self)
    return self
end

--- UserCommands Class Methods ---

---Create a new usercommand
---@param name string
---@param callback function
---@param args table
function UserCommands.schema:create(name, callback, args)
    vim.api.nvim_create_user_command(name, callback, args)
end

---Preset a new usercommand
---@param name string
---@param callback string | function
---@param opts table?
function UserCommands.schema:fn(name, callback, opts)
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
    if CFG.is_setup then
        self:create(name, callback, args)
    end
end

function UserCommands.schema:setup()
    for _, usercommand in ipairs(self.usercommands) do
        self:create(unpack(usercommand))
    end
end

return UserCommands.interface
