local wk = CFG.spec:add("folke/which-key.nvim")

wk.event = {
    "VeryLazy",
}

wk.opts.preset = "helix"
wk.opts.delay = 0
wk.opts.defer = function()
    return false
end
wk.opts.win = {
    title_pos = "right",
}
wk.opts.debug = CFG.verbose

wk.post:insert(
    function()
        function CFG.key:create(map)
            require("which-key").add(map)
        end
        CFG.key:setup()
    end
)
