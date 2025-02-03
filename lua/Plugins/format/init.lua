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
    self.formatters_by_ft[ft] = vim.tbl_deep_extend(
        "force", self.formatters_by_ft[ft] or {}, {
            formatter,
        }
    )
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

conform.opts.default_format_opts = {
    lsp_format = "fallback",
}

conform.post:insert(
    function()
        --- Since we just saved to load conform, run the formatter straight away
        require("conform").format(
            {
                bufnr = 0,
            }
        )
        CFG.aucmd:on(
            "BufWritePre", function(ctx)
                if not CFG.disable.format then
                    require("conform").format(
                        {
                            bufnr = ctx.buf,
                        }
                    )
                end
            end, {
                pattern = "*",
            }
        )
        CFG.set:opt("formatexpr", "v:lua.require'conform'.formatexpr()")
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
