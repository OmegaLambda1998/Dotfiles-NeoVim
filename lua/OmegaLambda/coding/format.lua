local index, spec, opts = OL.spec:add("stevearc/conform.nvim")

spec.cmd = {"ConformInfo"}

OL.callbacks.format = OLConfig.new()

OL.callbacks.format.ft = OLConfig.new()
spec.event = OL.callbacks.format.ft

OL.callbacks.format.formatters_by_ft = OLConfig.new()
opts.formatters_by_ft = OL.callbacks.format.formatters_by_ft

OL.callbacks.format.formatters = OLConfig.new()
opts.formatters = OL.callbacks.format.formatters

opts.default_format_opts = {
    timeout_ms = 3000,
    lsp_format = "fallback",
    async = false,
    quiet = false
}

opts.format_on_save = {lsp_format = "fallback"}

opts.log_level = vim.log.levels.INFO
opts.notify_on_error = true
opts.notify_no_formatters = false

function spec.config(_, opts) OL.load_setup("conform", {}, opts) end
