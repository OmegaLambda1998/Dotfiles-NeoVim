local Config = require("ConfigHelper.config")

---OmegaLambda's Neovim Config
---@class OLConfig: Config
---@field verbose boolean Increase logging verbosity
---@field profile boolean Enable profiling
---@field disable table<string, boolean> Globally flags to track whether a given object is currently disabled
---@field spec Specifications Specifications for all plugins
---@field paths Paths Paths relative to the base neovim config directory
---@field key Keymaps Keymap utilities
---@field set Settings Settings utilities
---
---@field is_pager fun():boolean Check whether neovim is being used as a pager
local OLConfig = {}
OLConfig.interface = {}
OLConfig.schema = {}
OLConfig.metatable = {
    __index = OLConfig.schema,
}

---OLConfig Constructor
---@param self OLConfig
---@param verbose boolean Increase logging verbosity
---@param profile boolean Enable profiling
---@return OLConfig
function OLConfig.prototype(self, verbose, profile)
    self.verbose = verbose
    self.profile = profile
    self.disable = {}

    self.spec = require("ConfigHelper.spec").new()
    self.paths = require("ConfigHelper.paths").new()
    self.key = require("ConfigHelper.keymaps").new()
    self.set = require("ConfigHelper.settings").new()
    self.aucmd = require("ConfigHelper.autocommands")
    self.usrcmd = require("ConfigHelper.usercommands")
    self.hl = require("ConfigHelper.highlights")

    return self
end

---Create a new OLConfig instance
---@param verbose boolean Increase logging verbosity
---@param profile boolean Enable profiling
---@return OLConfig
function OLConfig.interface.new(verbose, profile)
    local self = setmetatable(Config.interface.new(), OLConfig.metatable)
    OLConfig.prototype(self, verbose, profile)
    return self
end

--- OLConfig Class Methods ---

---Check whether neovim is being used as a pager
---@return boolean
function OLConfig.schema.is_pager()
    for _, arg in ipairs(vim.v.argv) do
        if arg:find("neovim-page", 0, true) then
            return true
        end
    end
    return false
end

return OLConfig.interface
