local M = {}

local opts = {
    enabled = true,
}

function M.setup(snacks)
    snacks.opts.picker = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>p",
                    mode = {
                        "n",
                    },
                    group = "Pick",
                    desc = "Pick",
                    {
                        "<leader>pd",
                        function()
                            Snacks.picker.diagnostics()
                        end,
                        desc = "Diagnostics",
                    },
                    {
                        "<leader>pf",
                        function()
                            Snacks.picker.smart()
                        end,
                        desc = "Files",
                    },
                    {
                        "<leader>pg",
                        function()
                            Snacks.picker.grep()
                        end,
                        desc = "Grep",
                    },
                    {
                        "<leader>ph",
                        function()
                            Snacks.picker.help()
                        end,
                        desc = "Help",
                    },
                    {
                        "<leader>pj",
                        function()
                            Snacks.picker.jumps()
                        end,
                        desc = "Jumps",
                    },
                    {
                        "<leader>pl",
                        desc = "LSP",
                        {
                            "<leader>plc",
                            function()
                                Snacks.picker.lsp_declarations()
                            end,
                            desc = "Declarations",
                        },
                        {
                            "<leader>pld",
                            function()
                                Snacks.picker.lsp_definitions()
                            end,
                            desc = "Definitions",
                        },
                        {
                            "<leader>pli",
                            function()
                                Snacks.picker.lsp_implementations()
                            end,
                            desc = "Implementations",
                        },
                        {
                            "<leader>plr",
                            function()
                                Snacks.picker.lsp_references()
                            end,
                            desc = "References",
                        },
                        {
                            "<leader>pls",
                            function()
                                Snacks.picker.lsp_symbols()
                            end,
                            desc = "Symbols",
                        },
                        {
                            "<leader>plt",
                            function()
                                Snacks.picker.lsp_type_definitions()
                            end,
                            desc = "Type Definitions",
                        },
                        {
                            "<leader>plw",
                            function()
                                Snacks.picker.lsp_workspace_symbols()
                            end,
                            desc = "Workspace Symbols",
                        },
                    },
                    {
                        "<leader>pp",
                        function()
                            Snacks.picker.pickers()
                        end,
                        desc = "Pickers",
                    },
                    {
                        "<leader>pr",
                        function()
                            Snacks.picker.recent()
                        end,
                        desc = "Recent Files",
                    },
                    {
                        "<leader>pv",
                        function()
                            Snacks.picker.resume()
                        end,
                        desc = "Previous",
                    },
                    {
                        "<leader>pz",
                        function()
                            Snacks.picker.zoxide()
                        end,
                        desc = "Zoxide",
                    },
                }
            )
        end
    )
    return snacks
end

return M
