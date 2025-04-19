local Config = require("ConfigHelper.config")
---@module "which-key"

---Keymap utilities
---@class Keymaps: Config
---@field mappings wk.Spec[]
---
---@field create fun(self: Keymaps, map: wk.Spec)
---@field map fun(self: Keymaps, map: wk.Spec)
---@field setup fun(self: Keymaps)
local Keymaps = {}
Keymaps.interface = {}
Keymaps.schema = {}
Keymaps.metatable = {
    __index = Keymaps.schema,
}

---Keymaps Constructor
---@param self Keymaps
---@return Keymaps
function Keymaps.prototype(self)
    self.mappings = {}
    return self
end

---Create a new Keymaps instance
---@return Keymaps
function Keymaps.interface.new()
    local self = setmetatable(Config.interface.new(), Keymaps.metatable)
    Keymaps.prototype(self)
    return self
end

--- Keymaps Class Methods ---

---Create and set a new keymap
---@param map wk.Spec
function Keymaps.schema:create(map)
    local lhs = map.lhs or map[1] --[[@as string]]
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

---Create a new keymap, setting it if setup has already been called
---@param self Keymaps
---@param map wk.Spec
function Keymaps.schema.map(self, map)
    table.insert(self.mappings, map)
    if CFG.is_setup then
        self:create(map)
    end
end

---Set all preset keymaps
---@param self Keymaps
function Keymaps.schema.setup(self)
    for _, map in ipairs(self.mappings) do
        self:create(map)
    end
end

return Keymaps.interface
