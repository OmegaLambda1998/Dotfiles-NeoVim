return function(opts)
    ---
    --- === Setup ===
    ---

    ---
    --- --- Configs ---
    ---

    ---@class OL
    OL = require("OmegaLambda.setup.configs")
    OL.verbose = opts.verbose or false
    OL.should_profile = opts.should_profile or false

    --- Pager Compatability
    function OL.is_pager()
        for _, arg in ipairs(vim.v.argv) do
            if arg:find("neovim-page", 0, true) then
                return true
            end
        end
        return false
    end

    ---
    --- --- Debugging ---
    ---

    --- Load Debugging
    require("OmegaLambda.setup.debugging")

    ---
    --- --- Tables ---
    ---

    --- Load Tables
    require("OmegaLambda.setup.tables")

    ---
    --- --- Paths ---
    ---

    --- Load Paths
    require("OmegaLambda.setup.paths")

    --- Create Paths
    ---@class OLPath
    ---@field setup OLPath
    OL.paths = OL.OLPath.new(
        {
            root = "OmegaLambda",
        }
    )
    OL.paths:append("setup")

    ---
    --- --- Modules ---
    ---

    --- Load Modules
    require(OL.paths.setup:module("modules"))

    ---
    --- --- Plugin Specs ---
    ---
    OL.load(
        "specs", {
            from = OL.paths.setup,
            strict = true,
        }
    )

    ---
    --- --- Callback Functions ---
    ---
    OL.load(
        "callbacks", {
            from = OL.paths.setup,
            strict = true,
        }
    )

    --- Create Callbacks
    ---@class OLCallbacks: OLConfig
    OL.callbacks = OL.OLConfig.new()
    OL.callbacks.pre = OL.OLCall.new()
    OL.callbacks.post = OL.OLCall.new()

    ---
    --- --- Neovim Integration ---
    ---
    OL.load(
        "neovim", {
            from = OL.paths.setup,
            strict = true,
        }
    )

    return OL
end
