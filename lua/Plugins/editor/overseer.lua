local overseer = CFG.spec:add("stevearc/overseer.nvim")

--- Todo, change to only filetypes which have tasks
overseer.cmd = {
    "OverseerRun",
    "OverseerToggle",
}

overseer.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>t",
                mode = {
                    "n",
                },
                desc = "Task",
                group = "Task",
                {
                    "<leader>tr",
                    ":OverseerRun<CR>",
                    desc = "Run",
                },
                {
                    "<leader>tt",
                    ":OverseerToggle<CR>",
                    desc = "Toggle",
                },
            }
        )
    end
)
