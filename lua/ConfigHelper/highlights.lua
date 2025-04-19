local Config = require("ConfigHelper.config")

---Highlight utilities
---@class Highlights: Config
---
---@field setup fun(self: Highlights)
local Highlights = {}
Highlights.interface = {}
Highlights.schema = {}
Highlights.metatable = {
    __index = Highlights.schema,
}

---Highlights Constructor
---@param self Highlights
---@return Highlights
function Highlights.prototype(self)
    return self
end

---Create a new Highlights instance
---@return Highlights
function Highlights.interface.new()
    local self = setmetatable(Config.interface.new(), Highlights.metatable)
    Highlights.prototype(self)
    return self
end

--- Highlights Class Methods ---

function Highlights.schema:setup()
    vim.cmd.colorscheme(CFG.colourscheme.name)
    require("nvim-web-devicons").refresh()
end

return Highlights.interface
