local spec, opts = OL.spec:add("HiPhish/rainbow-delimiters.nvim")

OL.callbacks.colourscheme.rainbow_delimiters = true

spec.event = "VeryLazy"
spec.main = "rainbow-delimiters.setup"
