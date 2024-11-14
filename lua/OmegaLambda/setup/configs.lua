---
--- === Configs ===
---

OLConfig = {}

function OLConfig.new(tbl, mt) 
	if tbl == nil then
		tbl = {}
	end
	if mt == nil then
		mt = OLConfig
	end
	mt.__index = mt
	setmetatable(tbl, mt)
	return tbl
end

OL = OLConfig.new()


return OL
