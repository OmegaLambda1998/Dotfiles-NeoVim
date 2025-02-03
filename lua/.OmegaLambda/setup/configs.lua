---
--- === Configs ===
---
---@class OLConfig
local OLConfig = {}

---@generic class: OLConfig
---@param tbl table
---@param meta class
---@return `class` 
---@overload fun(): OLConfig
function OLConfig.new(tbl, meta)
    if tbl == nil then
        tbl = {}
    end
    if meta == nil then
        meta = OLConfig
    end
    meta.__index = meta
    local self = setmetatable(tbl, meta)
    return self
end

---@class OL: OLConfig
local OL = OLConfig.new()
OL.OLConfig = OLConfig

return OL
