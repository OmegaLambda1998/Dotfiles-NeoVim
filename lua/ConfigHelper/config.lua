---Abstract Config Class
---@class Config: table
local Config = {}
Config.interface = {}
Config.schema = {}
Config.metatable = {
    __index = Config.schema,
}

---Abstract Config Constructor
---@param self table
---@return Config
function Config.prototype(self)
    return self
end

---Create a new Config instance
---@return Config
function Config.interface.new(self)
    if self == nil then
        self = {}
    end
    return setmetatable(Config.prototype(self), Config.metatable)
end

return Config
