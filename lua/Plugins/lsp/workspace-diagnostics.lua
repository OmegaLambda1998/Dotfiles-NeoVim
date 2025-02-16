local M = {}

local wd = CFG.spec:add("artemave/workspace-diagnostics.nvim")
wd.event = {
    "LspAttach",
}

wd.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>rW",
                function()
                    for _, client in ipairs(vim.lsp.get_clients()) do
                        require("workspace-diagnostics").populate_workspace_diagnostics(
                            client, 0
                        )
                    end
                end,
                mode = {
                    "n",
                },
                desc = "Populate workspace diagnostics",
            }
        )
    end
)

return M
