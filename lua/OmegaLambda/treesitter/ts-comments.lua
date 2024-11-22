OL.spec:add(
    "JoosepAlviste/nvim-ts-context-commentstring", {
        enable_autocmd = false,
    }
)

local spec, opts = OL.spec:add("numToStr/Comment.nvim")
spec.dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
}

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "numToStr/Comment.nvim",
    }
)

opts.pre_hook = function()
    OL.load(
        'ts_context_commentstring.integrations.comment_nvim', {}, function(ts)
            ts.create_pre_hook()
        end
    )
end

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "numToStr/Comment.nvim",
    }
)

function spec.config(_, o)
    OL.load_setup("Comment", {}, o)
    vim.keymap.del("n", "gc")
    vim.keymap.del("n", "gb")
    OL.map(
        {
            {
                "gb",
                group = "Comment toggle blockwise",
                desc = "Comment toggle blockwise",
            },
            {
                "gc",
                group = "Comment toggle linewise",
                desc = "Comment toggle linewise",
            },
        }
    )
end
