local M = {}

local url = "jeangiraldoo/codedocs.nvim"
local codedocs = CFG.spec:add(url)

codedocs.dependencies = "nvim-treesitter/nvim-treesitter"
codedocs.cmd = {
    "Codedocs",
}
codedocs.event = "LspAttach"

CFG.codedocs = {
    default_styles = {},
}

codedocs.opts.default_styles = CFG.codedocs.default_styles

codedocs.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>rc",
                function()
                    return require("codedocs").insert_docs()
                end,
                mode = {
                    "n",
                },
                desc = "Insert docstring",
            }
        )
    end
)

return M
