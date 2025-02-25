local M = {}

function M.setup()
    vim.cmd.colorscheme(CFG.colourscheme.name)
    require("nvim-web-devicons").refresh()
end

return M
