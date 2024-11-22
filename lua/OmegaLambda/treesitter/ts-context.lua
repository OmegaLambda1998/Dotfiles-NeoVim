local spec, opts = OL.spec:add("nvim-treesitter/nvim-treesitter-context")

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "nvim-treesitter/nvim-treesitter-context",
    }
)
OL.callbacks.colourscheme.treesitter_context = true
