---
--- === Paths ===
---

local joinpath = vim.fs.joinpath
local stdpath = vim.fn.stdpath
local norm = vim.fs.normalize
local glob = vim.fn.glob

local config_path = joinpath(stdpath("config"), "lua")

OLPath = OLConfig.new()
function OLPath.new(tbl)
	if tbl == nil then
		tbl = {}
	end
	if tbl.root == nil then
		tbl.root = ""
	end
	return OLConfig.new(tbl, OLPath)
end
OLPath.__tostring = function(self) return self.root end

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
