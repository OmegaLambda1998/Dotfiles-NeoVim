--- Dependencies ---
OL.spec:add("nvim-neorg/lua-utils.nvim")
OL.spec:add(
    "MunifTanjim/nui.nvim", {
        config = function(_, o)
        end,
    }
)
OL.spec:add("nvim-neotest/nvim-nio")
OL.spec:add("pysan3/pathlib.nvim")
local spec, opts = OL.spec:add("nvim-neorg/neorg")
