local spec, opts = OL.spec:add("akinsho/bufferline.nvim")

spec.event = {
    "VeryLazy",
}

function spec.config(_, o)
    if OL.is_man() then
        return
    end
    OL.load_setup("bufferline", {}, o)
end
