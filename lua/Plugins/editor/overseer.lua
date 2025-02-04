local overseer = CFG.spec:add("stevearc/overseer.nvim")

CFG.overseer = {
    templates = {},
    ft = {},
}

overseer.ft = CFG.overseer.ft

--- Todo, change to only filetypes which have tasks
overseer.cmd = {
    "OverseerRun",
    "OverseerToggle",
}

overseer.post:insert(
    function()
        local os = require("overseer")
        for ft, template in pairs(CFG.overseer.templates) do
            CFG.aucmd:on(
                "FileType", function(_)
                    os.register_template(template)
                end, {
                    pattern = ft,
                }
            )
        end

    end
)

overseer.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>r",
                mode = {
                    "n",
                },
                desc = "Overseer",
                group = "Overseer",
                {
                    "<leader>rr",
                    ":OverseerRun<CR>",
                    desc = "Run",
                },
                {
                    "<leader>rt",
                    ":OverseerToggle<CR>",
                    desc = "Toggle",
                },
            }
        )
    end
)
