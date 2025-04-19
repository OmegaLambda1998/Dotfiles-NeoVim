local Config = require("ConfigHelper.config")

---@alias setting { [1]: function, [2]: string, [3]: any, [4]: string }

---Keymap utilities
---@class Settings: Config
---@field settings setting[]
---
---@field create fun(self: Settings, mode: function, key: string, val: any?, mod: string?)
---@field set fun(self: Settings, mode: function, key: string, val: any?, mod: string?)
---@field g fun(self: Settings, key: string, val: any?, mod: string?)
---@field o fun(self: Settings, key: string, val: any?, mod: string?)
---@field opt fun(self: Settings, key: string, val: any?, mod: string?)
---@field setup fun(self: Keymaps)
local Settings = {}
Settings.interface = {}
Settings.schema = {}
Settings.metatable = {
    __index = Settings.schema,
}

---Settings Constructor
---@param self Settings
---@return Settings
function Settings.prototype(self)
    self.settings = {}
    return self
end

---Create a new Settings instance
---@return Settings
function Settings.interface.new()
    local self = setmetatable(Config.interface.new(), Settings.metatable)
    Settings.prototype(self)
    return self
end

--- Settings Class Methods ---

---@param mode function
---@param key string
---@param val any?
---@param mod string?
function Settings.schema:create(mode, key, val, mod)
    if mod ~= nil then
        mode[key][mod](mode[key], val)
    else
        mode[key] = val
    end
end

---@param mode function
---@param key string
---@param val any?
---@param mod string?
function Settings.schema:set(mode, key, val, mod)
    if val == nil then
        val = true
    end
    table.insert(
        self.settings, {
            mode,
            key,
            val,
            mod,
        }
    )
    if CFG.is_setup then
        self:create(mode, key, val, mod)
    end
end

function Settings.schema:setup()
    for _, setting in ipairs(self.settings) do
        self:create(unpack(setting))
    end
end

local opts = {
    "g",
    "o",
    "opt",
}

for _, opt in ipairs(opts) do
    Settings.schema[opt] = function(self, key, val, mod)
        self:set(vim[opt], key, val, mod)
    end
end

return Settings.interface
