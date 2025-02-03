local M = {}

local url = "rafamadriz/friendly-snippets"
local snippets = CFG.spec:add(url)

function M.setup(blink)
    table.insert(
        blink.dependencies, {
            url,
        }
    )
    return blink
end
