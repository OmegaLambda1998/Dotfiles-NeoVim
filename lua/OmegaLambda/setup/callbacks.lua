---
--- === Callbacks ===
---

OLCall = OLConfig.new()
function OLCall.new(tbl)
	if tbl == nil then 
		tbl = {}
	end
	tbl = OLConfig.new(tbl)
	return OLConfig.new(tbl, OLCall)
end

function OLCall:__call(...)
	args = OL.pack(...)
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
