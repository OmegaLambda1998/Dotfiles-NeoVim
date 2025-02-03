local spec, opts = OL.spec:add("aaronik/treewalker.nvim")
opts.highlight = true

spec.cmd = {
    "Treewalker",
}
spec.keys = {
    {
        "<Space>k",
        ":Treewalker Up<CR>",
        desc = "Treewalker Up",
    },
    {
        "<Space>j",
        ":Treewalker Down<CR>",
        desc = "Treewalker Down",
    },
    {
        "<Space>l",
        ":Treewalker Right<CR>",
        desc = "Treewalker Right",
    },
    {
        "<Space>h",
        ":Treewalker Left<CR>",
        desc = "Treewalker Left",
    },
}

OL.map(
    {
        "<Space>",
        group = "Treewalker",
        spec.keys,
    }
)
