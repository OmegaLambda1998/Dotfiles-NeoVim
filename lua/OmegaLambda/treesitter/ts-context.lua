local spec, opts = OL.spec:add("nvim-treesitter/nvim-treesitter-context")

spec.event = "VeryLazy"

OL.callbacks.colourscheme.treesitter_context = true
