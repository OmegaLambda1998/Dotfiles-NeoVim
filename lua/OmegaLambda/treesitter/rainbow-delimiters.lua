local spec, opts = OL.spec:add("HiPhish/rainbow-delimiters.nvim")

table.insert(
    OL.callbacks.treesitter.dependencies, {
        "HiPhish/rainbow-delimiters.nvim",
    }
)

OL.callbacks.colourscheme.rainbow_delimiters = true

spec.main = "rainbow-delimiters.setup"

opts.strategy = {
    [""] = "global",
}

opts.query = {
    [""] = "rainbow-delimiters",
    latex = "rainbow-delimiters", -- rainbow-blocks
    lua = "rainbow-blocks", -- rainbow-blocks
    query = function(bufnr)
        -- Use blocks for read-only buffers like in `:InspectTree`
        local is_nofile = vim.bo[bufnr].buftype == "nofile"
        return is_nofile and "rainbow-blocks" or "rainbow-delimiters"
    end,
}

opts.priority = {
    [""] = 110,
    lua = 210,
}

opts.blacklist = OL.callbacks.treesitter.exclude

function spec.config(_, o)
    OL.load(
        "rainbow-delimiters", {}, function(rb)
            for ft, strategy in pairs(o.strategy) do
                if type(strategy) == "string" then
                    o.strategy[ft] = rb.strategy[strategy]
                end
            end
            OL.g(
                "rainbow_delimiters", vim.tbl_deep_extend(
                    "force", vim.g.rainbow_delimiters or {}, o
                ), {
                    force = true,
                }
            )
        end
    )
end
