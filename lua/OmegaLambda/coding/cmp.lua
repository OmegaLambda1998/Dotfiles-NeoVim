local index, spec, opts = OL.spec:add("Saghen/blink.cmp")

spec.version = false
spec.build = "cargo build --release"

OL.callbacks.cmp = OLConfig.new()
OL.callbacks.cmp.ft = OLConfig.new()
OL.callbacks.cmp.sources = OLConfig.new({"lsp", "path", "snippets", "buffer"})
OL.callbacks.cmp.providers = OLConfig.new()

spec.event = OL.callbacks.cmp.ft

opts.sources = {
    compat = {},
    completion = {enabled_provides = OL.callbacks.cmp.sources},
    providers = OL.callbacks.cmp.providers
}
