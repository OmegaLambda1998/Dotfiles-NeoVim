---
--- === Metatables ===
---

local function new(mt, tbl)
	if tbl == nil then
		tbl = {}
	end
	setmetatable(tbl, mt)
	return tbl
end

---
--- --- Config ---
---

OLConfig = {}
OLConfig.__index = OLConfig
function OLConfig.new(tbl) return new(OLConfig, tbl) end
OL = OLConfig.new()

---
--- --- Utility Functions ---
---

function OL.flatten(...)
	local args = table.pack(...)
	local flat = {}
	for _, arg in ipairs(args) do
		if type(arg) == "table" then
			vim.list_extend(flat, OL.fatten(table.unpack(arg)))
		else
			table.insert(flat, arg)
		end
	end
	return flat
end


---
--- --- Plugin Spec ---
---

OLSpec = {}
OLSpec.__index = OLSpec
function OLSpec.new(tbl) return new(OLSpec, tbl) end
function OLSpec.__newindex(self, key, value)
	local spec = {key, table.unpack(value)}
	rawset(self, #self+1, spec)
end

---
--- --- Paths ---
---

local joinpath = vim.fs.joinpath
local stdpath = vim.fn.stdpath
local norm = vim.fs.normalize
local glob = vim.fn.glob

local config_path = joinpath(stdpath("config"), "lua")

OLPath = {}
OLPath.__index = OLPath
OLPath.__tostring = function(self) return self.root end
function OLPath.new(tbl) return new(OLPath, tbl) end
function OLPath.__newindex(self, path, ...)
	local paths = OL.flatten(...)
	local root = joinpath(self.root, table.unpack(paths))
	rawset(self, path, OLPath.new({root = root}))
end
function OLPath.module(self, ...)
	local paths = OL.flatten(...)
	local modpath = joinpath(tostring(self.root), table.unpack(paths)):gsub("/",".")
	return modpath
end
function OLPath.abs(self, ...)
	local paths = OL.flatten(...)
	local abspath = norm(joinpath(
		config_path, tostring(self.root), table.unpack(paths)
	))
	return abspath 
end
function OLPath.glob(self, pattern, greedy)
	local split = vim.gsplit
	if greedy then
		split = vim.split
	end
	local abs_pattern = self:abs(pattern)
	local matches = glob(abs_pattern)
	return split(matches, "\n", {trimempty=true, plain=true})
end

return OL
