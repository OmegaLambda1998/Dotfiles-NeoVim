local Config = require("ConfigHelper.config")

---Path utilities
---@class Paths: Config
---@field path string
---@field mod string
---@field config string
---
---@field join fun(self: Paths, paths: string[]): Paths
local Paths = {}
Paths.interface = {}
Paths.schema = {}
Paths.metatable = {
    __index = Paths.schema,
}

---Paths Constructor
---@param self Paths
---@param paths string[]
---@return Paths
function Paths.prototype(self, paths)
    self.config = vim.fs.joinpath(vim.fn.stdpath("config"), "lua")
    local path = vim.fs.joinpath(self.path or self.config, unpack(paths))
    local mod = path:gsub(self.config, ""):gsub("/", "."):gsub("^.", "")
    self.path = path
    self.mod = mod
    return self
end

---Create a new Paths instance
---@return Paths
---@param paths string[]?
---@param base string?
function Paths.interface.new(paths, base)
    if paths == nil then
        paths = {}
    end
    local self = setmetatable(
        Config.interface.new(
            {
                path = base,
            }
        ), Paths.metatable
    )
    Paths.prototype(self, paths)
    return self
end

--- Paths Class Methods ---

---Join the given paths to the existing paths
---@param self Paths
---@param paths string[]
---@return Paths
function Paths.schema.join(self, paths)
    return Paths.interface.new(paths, self.path)
end

return Paths.interface
