local M = {}
local url = "hiphish/rainbow-delimiters.nvim"
local rd = CFG.spec:add(url)
rd.main = "rainbow-delimiters.setup"

CFG.rainbow_delimiter = {}

--- Strategy ---
CFG.rainbow_delimiter.strategy = {
    [""] = "global",
}
rd.opts.strategy = CFG.rainbow_delimiter.strategy
rd.pre:insert(
    function(opts)
        local rainbow = require("rainbow-delimiters")
        for k, v in pairs(opts.strategy) do
            if type(v) == "string" then
                opts.strategy[k] = rainbow.strategy[v]
            end
        end
        return opts
    end
)

--- Query ---
CFG.rainbow_delimiter.query = {
    [""] = "rainbow-delimiters",
}
rd.opts.query = CFG.rainbow_delimiter.query

--- Priority ---
CFG.rainbow_delimiter.priority = {
    [""] = 110,
}
rd.opts.priority = CFG.rainbow_delimiter.priority

function M.setup(treesitter)
    table.insert(
        treesitter.dependencies, {
            url,
        }
    )
end

return M
