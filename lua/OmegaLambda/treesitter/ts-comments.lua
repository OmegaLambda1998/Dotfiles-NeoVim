local spec, opts = OL.spec:add("folke/ts-comments.nvim")

opts.lang = {}
opts.lang.lua = {
    "--- %s",
}

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "folke/ts-comments.nvim",
    }
)
