return function(opts)
    ---
    --- === Setup ===
    ---

    ---
    --- --- Configs ---
    ---

    OL = require("OmegaLambda.setup.configs")
    OL.verbose = opts.verbose or false

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
    OL.paths = OLPath.new({root = "OmegaLambda"})
    OL.paths.setup = "setup"

    ---
    --- --- Modules ---
    ---

    --- Load Modules
    require(OL.paths.setup:module("modules"))

    ---
    --- --- Plugin Specs ---
    ---
    OL.load("specs", {from = OL.paths.setup, strict = true})

    ---
    --- --- Callback Functions ---
    ---
    OL.load("callbacks", {from = OL.paths.setup, strict = true})

    --- Create Callbacks
    OL.callbacks = OLConfig.new()
    OL.callbacks.pre = OLCall.new()
    OL.callbacks.post = OLCall.new()

    ---
    --- --- Neovim Integration ---
    ---
    OL.load("neovim", {from = OL.paths.setup, strict = true})

    return OL
end
