---
--- === Paths ===
---
local joinpath = vim.fs.joinpath
local stdpath = vim.fn.stdpath
local norm = vim.fs.normalize
local glob = vim.fn.glob

local config_path = joinpath(OL.unpack(OL.flatten({stdpath("config")})), "lua")

---@class OLPath: OLConfig
---@field root string
local OLPath = {}
OLPath = OL.OLConfig.new({}, OLPath)
OL.OLPath = OLPath

function OLPath.new(tbl)
    if tbl == nil then
        tbl = {}
    end
    if tbl.paths == nil then
        tbl.paths = {}
    end
    if tbl.root == nil then
        tbl.root = ""
    end
    return OL.OLConfig.new(tbl, OLPath)
end

OLPath.__tostring = function(self)
    return self.root
end

---@param from string
---@param to string
function OLPath:__newindex(from, to)
    local root = joinpath(self.root, to)
    rawset(self, from, OLPath.new({root = root}))
end

function OLPath:append(path)
    self[path] = path
    return self
end

function OLPath:module(...)
    local paths = OL.flatten(...)
    local modpath = joinpath(tostring(self.root), OL.unpack(paths)):gsub("/",
                                                                         ".")
    return modpath
end

function OLPath:abs(...)
    local paths = OL.flatten(...)
    local abspath = norm(joinpath(config_path, tostring(self.root),
                                  OL.unpack(paths)))
    return abspath
end

function OLPath:glob(pattern, greedy)
    local split = vim.gsplit
    if greedy then
        split = vim.split
    end
    local abs_pattern = self:abs(pattern)
    local matches = glob(abs_pattern)
    return split(matches, "\n", {trimempty = true, plain = true})
end
