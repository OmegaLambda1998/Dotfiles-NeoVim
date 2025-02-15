local M = {}

local url = "rafamadriz/friendly-snippets"
local snippets = CFG.spec:add(url)
snippets.setup = false
snippets.cond = CFG.spec:get("blink.cmp").opts.sources.providers.snippets
                    .enabled

function M.setup(blink)
    table.insert(
        blink.dependencies, {
            url,
        }
    )
    return blink
end

return M
