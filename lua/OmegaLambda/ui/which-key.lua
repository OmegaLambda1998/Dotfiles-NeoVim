local index, spec, opts = OL.spec:add("folke/which-key.nvim")

spec.event = "VeryLazy"

OL.g("mapleader", ",")
OL.g("maplocalleader", ".")

OL.map({
    "<localleader>?",
    function()
        OL.load("which-key", {}, function(wk) wk.show({global = false}) end)
    end,
    desc = "Buffer Local keymaps",
    mode = {"n", "v"}
})

OL.map({
    "<leader>?",
    function()
        OL.load("which-key", {}, function(wk) wk.show({global = true}) end)
    end,
    desc = "Global keymaps",
    mode = {"n", "v"}
})
