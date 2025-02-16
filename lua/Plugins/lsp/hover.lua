local M = {}
local hover = CFG.spec:add("lewis6991/hover.nvim")

hover.event = {
    "LspAttach",
}

hover.opts.title = true
hover.opts.preview_window = false

hover.opts.providers = {
    "diagnostic",
    "lsp",
}

hover.opts.init = function()
    for _, provider in ipairs(hover.opts.providers) do
        require("hover.providers." .. provider)
    end
end

hover.post:insert(
    function()
        --- Remove pre-existing <S-k> bindings
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<S-k>")
        end
        CFG.key:map(
            {
                {
                    "<S-k>",
                    function(...)
                        require("hover").hover(...)
                    end,
                    desc = "Hover",
                },
                {
                    "<C-k>",
                    function()
                        local hover_win = vim.b.hover_preview
                        if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                            vim.api.nvim_set_current_win(hover_win)
                        end
                    end,
                    desc = "Enter Hover",
                },
            }
        )
    end
)

return M
