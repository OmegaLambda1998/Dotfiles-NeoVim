local M = {
    highlights = {},
}

function M.update(name, opts)
    local is_ok, hl_def = pcall(
        vim.api.nvim_get_hl, 0, {
            name = name,
        }
    )
    if is_ok then
        for k, v in pairs(opts) do
            hl_def[k] = v
        end
        return hl_def
    else
        vim.print("Error updating ", name, ": ", hl_def)
    end
    return opts
end

function M.create(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
end

function M:set(name, opts)
    opts = M.update(name, opts)
    table.insert(
        self.highlights, {
            name,
            opts,
        }
    )
    if CFG.is_setup then
        self.create(name, opts)
    end
end

function M:setup()
    vim.cmd.colorscheme(CFG.colourscheme.name)
    for _, hl in ipairs(self.highlights) do
        self.create(unpack(hl))
    end
    require("nvim-web-devicons").refresh()
end

return M
