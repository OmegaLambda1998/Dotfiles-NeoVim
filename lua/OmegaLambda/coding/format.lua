local spec, opts = OL.spec:add("stevearc/conform.nvim")

spec.cmd = {
    "ConformInfo",
}

---@class OLFormat: OLConfig
OL.callbacks.format = OL.OLConfig.new()
OL.callbacks.format.ft = OL.OLConfig.new(
    {
        add = function(self, ft)
            table.insert(self, "BufWritePre *." .. ft)
        end,
    }
)

spec.event = OL.callbacks.format.ft

OL.callbacks.format.formatters_by_ft = OL.OLConfig.new()
opts.formatters_by_ft = OL.callbacks.format.formatters_by_ft

OL.callbacks.format.formatters = OL.OLConfig.new()
opts.formatters = OL.callbacks.format.formatters

function OL.callbacks.format:add(filetype, formatter, formatter_opts)
    if OL.callbacks.format.formatters_by_ft[filetype] == nil then
        OL.callbacks.format.formatters_by_ft[filetype] = {}
    end
    table.insert(OL.callbacks.format.formatters_by_ft[filetype], formatter)
    OL.callbacks.format.formatters[formatter] = formatter_opts
end

opts.default_format_opts = {
    timeout_ms = 3000,
    lsp_format = "fallback",
    async = false,
    quiet = false,
}

opts.format_on_save = {
    lsp_format = "fallback",
}

function spec.config(_, o)
    for fmt, fmt_opts in pairs(o.formatters) do
        if type(fmt_opts[1]) == "function" then
            o.formatters[fmt] = fmt_opts[1]()
        end
    end
    OL.load_setup("conform", {}, o)
end

opts.log_level = vim.log.levels.INFO
opts.notify_on_error = true
opts.notify_no_formatters = false

OL.opt("formatoptions", "jcroqln") -- tcqj
OL.opt("grepformat", "%f:%l:%c:%m")
OL.opt("grepprg", "rg --vimgrep")
