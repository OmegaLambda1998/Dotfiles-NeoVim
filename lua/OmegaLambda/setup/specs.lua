---
--- === Plugin Specs ===
---

OLSpec = OLConfig.new()
function OLSpec.new(tbl)
	if tbl == nil then 
		tbl = {}
	end
	tbl = OLConfig.new(tbl)
	return OLConfig.new(tbl, OLSpec)
end

function OLSpec:__newindex(key, value)
	local spec = OLConfig.new({key})
	for k, v in pairs(value) do
		spec[k] = v
	end
	spec.opts = OLConfig.new(spec.opts or {})
	rawset(self, #self+1, spec)
end

function OLSpec:get(index)
	if index == nil then
		index = #self
	end
	return index, self[index], self[index].opts
end

function OLSpec:add(url, spec)
	self:__newindex(url, spec or {})
	return self:get(#self)
end
