local index, spec, opts = OL.spec:add("neovim/nvim-lspconfig")

OL.callbacks.lsp = OLConfig.new()
OL.callbacks.lsp.ft = OLConfig.new()

spec.ft = OL.callbacks.lsp.ft
