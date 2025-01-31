local M = {}

local opts = {
    enabled = true,
    notify_jump = true,
    debounce = 50,
}

function M.setup(snacks)
    snacks.opts.words = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    mode = {
                        "n",
                    },
                    {
                        "[[",
                        function()
                            if Snacks.words.is_enabled() then
                                Snacks.words.jump(-1, true)
                            end
                        end,
                    },
                    {
                        "]]",
                        function()
                            if Snacks.words.is_enabled() then
                                Snacks.words.jump(1, true)
                            end
                        end,
                    },

                }
            )
        end
    )
    return snacks
end

return M
