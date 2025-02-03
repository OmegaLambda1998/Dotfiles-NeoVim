local M = {}
local url = "nvim-treesitter/nvim-treesitter-context"
local context = CFG.spec:add(url)
context.main = "treesitter-context"

context.opts.trim_scope = "outer"

CFG.colourscheme:set("treesitter_context")

function M.setup(treesitter)
    table.insert(
        treesitter.dependencies, {
            url,
        }
    )
end

return M
