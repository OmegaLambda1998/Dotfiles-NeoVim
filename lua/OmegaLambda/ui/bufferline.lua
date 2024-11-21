local spec, opts = OL.spec:add("akinsho/bufferline.nvim")

spec.event = {
    "VeryLazy",
}

function spec.config(_, o)
    opts.highlights = OL.load("catppuccin.groups.integrations.bufferline").get()
    OL.load_setup("bufferline", {}, o)
end
