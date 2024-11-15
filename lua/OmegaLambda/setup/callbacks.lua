---
--- === Callbacks ===
---
---@class OLCall: OLConfig
---@field event OLEvent
local OLCall = OL.OLConfig.new()
OL.OLCall = OLCall
function OLCall.new(tbl)
    if tbl == nil then
        tbl = {}
    end
    tbl = OL.OLConfig.new(tbl)
    return OL.OLConfig.new(tbl, OLCall)
end

function OLCall:__call(...)
    local args = OL.pack(...)
    for _, fn in ipairs(self) do
        fn(OL.unpack(args))
    end
    if self.event then
        OL.events.trigger(self.event)
    end
end

function OLCall:add(fn)
    self[#self + 1] = fn
end
