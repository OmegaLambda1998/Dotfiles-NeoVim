local Config = require("ConfigHelper.config")
---@module "lazy"

--- === Specification ===

---Plugin Specification
---@class Specification: Config, LazyPluginSpec
---@field pre (fun(PluginOpts): PluginOpts)[]
---@field post(fun())[]
---@field setup boolean | nil
local Specification = {}
Specification.interface = {}
Specification.schema = {}
Specification.metatable = {
    __index = Specification.schema,
}

---Specification Constructor
---@param self Specification
---@param url string
---@param opts PluginOpts
---@param spec LazyPluginSpec
---@return Specification
function Specification.prototype(self, url, opts, spec)
    self[1] = url
    self.opts = opts or {}
    self.cond = function()
        return not CFG.is_pager()
    end

    for k, v in pairs(spec or {}) do
        self[k] = v
    end

    self.pre = {
        insert = function(s, fn)
            table.insert(s, fn)
        end,
    }
    self.post = {
        insert = function(s, fn)
            table.insert(s, fn)
        end,
    }

    ---@param p Specification
    ---@param o PluginOpts
    self.config = function(p, o)
        for _, fn in ipairs(p.pre) do
            o = fn(o)
        end
        p.opts = o
        if p.setup ~= false then
            if not p.main then
                p.main = p.name:gsub("%.nvim", "")
            end
            require(p.main).setup(o)
        end
        for _, fn in ipairs(p.post) do
            fn()
        end
    end
    return self
end

---Create a new Specification instance
---@param url string
---@param opts PluginOpts
---@param spec LazyPluginSpec
---@return Specification
function Specification.interface.new(url, opts, spec)
    local self = setmetatable(Config.interface.new(), Specification.metatable)
    Specification.prototype(self, url, opts, spec)
    return self
end

--- Specification Class Methods ---

--- === Specifications ===

---Specifications for all plugins
---@class Specifications: Config
---@field specifications Specification[]
---
---@field get fun(self: Specifications, name: string): Specification | nil 
---@field add fun(self: Specifications, url: string, opts: PluginOpts, spec: LazyPluginSpec): Specification | nil
local Specifications = {}
Specifications.interface = {}
Specifications.schema = {}
Specifications.metatable = {
    __index = Specifications.schema,
}

---Specifications Constructor
---@param self Specifications
---@return Specifications
function Specifications.prototype(self)
    self.specifications = {}
    return self
end

---Create a new Specifications instance
---@return Specifications
function Specifications.interface.new()
    local self = setmetatable(Config.interface.new(), Specifications.metatable)
    Specifications.prototype(self)
    return self
end

--- Specifications Class Methods ---

---Get the specification for the plugin with the given name
---@param self Specifications
---@param name string
---@return Specification | nil
function Specifications.schema.get(self, name)
    for _, spec in ipairs(self.specifications) do
        local url = spec[1] --[[@as string]]
        if url:find(name, 0, true) then
            return spec
        end
    end
    return nil
end

---Add a new specification
---@param self Specifications
---@param url string
---@param opts PluginOpts
---@param spec LazyPluginSpec
---@return Specification
function Specifications.schema.add(self, url, opts, spec)
    spec = Specification.interface.new(url, opts, spec)
    table.insert(self.specifications, spec)
    return spec
end

return Specifications.interface
