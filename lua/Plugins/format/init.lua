local conform = CFG.spec:add("stevearc/conform.nvim")

conform.event = {
    "BufWritePre",
}
conform.cmd = {
    "ConformInfo",
}

CFG.disable.format = false
CFG.format = {}
CFG.format.formatters = {}

CFG.format.formatters_by_ft = {
    ["*"] = {}, --- All filetypes
    ["_"] = {}, --- Filetypes without a formatter
}

function CFG.format:add(ft, formatter, opts)
    opts = opts or {}
    if self.formatters_by_ft[ft] == nil then
        self.formatters_by_ft[ft] = {}
    end
    table.insert(self.formatters_by_ft[ft], formatter)
    self.formatters[formatter] = vim.tbl_deep_extend(
        "force", self.formatters[formatter] or {}, opts
    )
    if opts.mason ~= false then
        if opts.mason then
            formatter = opts.mason
        end
        table.insert(CFG.mason.ensure_installed, formatter)
    end
end

conform.opts.formatters = CFG.format.formatters
conform.opts.formatters_by_ft = CFG.format.formatters_by_ft

local function format_cb(err, did_edit)
    if err then
        vim.notify(err, vim.log.levels.WARN)
    elseif did_edit then
        vim.notify("Finished Formatting", vim.log.levels.INFO)
    else
        vim.notify("Finished Formatting, no changes", vim.log.levels.INFO)
    end
    --- Save without formatting
    CFG.disable.format = true
    vim.cmd(":w")
    CFG.disable.format = false
end

local function format(ctx)
    ctx = ctx or {}
    if not CFG.disable.format then
        vim.notify("Formatting", vim.log.levels.INFO)
        --- Format
        require("conform").format(
            {
                bufnr = ctx.bufnr or 0,
                async = true,
                quiet = true,
                lsp_format = "fallback",
            }, format_cb
        )
    end
end

--- Format on save
conform.post:insert(
    function()
        CFG.aucmd:on(
            "BufWritePost", format, {
                pattern = "*",
            }
        )
    end
)

--- Formatexpr
conform.post:insert(
    function()
        CFG.set:opt("formatexpr", "v:lua.require'conform'.formatexpr()")
    end
)

--- Save without format
conform.post:insert(
    function()
        CFG.key:map(
            {
                "<leader>w",
                function()
                    CFG.disable.format = true
                    vim.cmd(":w")
                    CFG.disable.format = false
                end,
                desc = "Save w/o format",
            }
        )
    end
)
