---
--- === Plugin Specs ===
---
---@class OLSpec: OLConfig
local OLSpec = OL.OLConfig.new()
OL.OLSpec = OLSpec
function OLSpec.new(tbl)
    if tbl == nil then
        tbl = {}
    end
    tbl = OL.OLConfig.new(tbl)
    return OL.OLConfig.new(tbl, OLSpec)
end

function OLSpec:get(index)
    if index == nil then
        index = #self
    end
    return self[index], self[index].opts
end

function OLSpec:add(url, opts)
    ---@class OLPlugin: OLConfig
    local spec = OL.OLConfig.new(
                     {
            url,
            cond = function()
                return not OL.is_pager()
            end,
        }
                 )
    if opts then
        for k, v in pairs(opts) do
            spec[k] = v
        end
    end
    spec.opts = OL.OLConfig.new(spec.opts or {})
    table.insert(self, spec)
    return self:get()
end
