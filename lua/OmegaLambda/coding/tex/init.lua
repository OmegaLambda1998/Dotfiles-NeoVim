local filetype = "tex"
table.insert(OL.callbacks.mason.ft, "BufReadPre *." .. filetype)

--- LSP
local lsp = "texlab"
table.insert(OL.callbacks.lsp.ft, "BufReadPost *." .. filetype)
OL.callbacks.lsp.servers[lsp] = {settings = {texlab = {}}}

-- --- CMP
-- local cmp = "lazydev"
-- table.insert(OL.callbacks.cmp.ft, "InsertEnter *." .. filetype)
-- table.insert(OL.callbacks.cmp.sources, cmp)
-- OL.callbacks.cmp.providers[cmp] = {
--     name = "LazyDev",
--     module = "lazydev.integrations.blink",
--     fallback = "lsp"
-- }
-- local spec, opts = OL.spec:add("folke/lazydev.nvim")
-- opts.integrations = {lspconfig = true, blink = true}
-- opts.library = {"$CONFIG/nvim/lua"}
--
-- --- Format
-- local formatter = "luaformatter"
-- local formatter_config = "luaformatter.yml"
-- table.insert(OL.callbacks.format.ft, "BufWritePre *." .. filetype)
-- OL.callbacks.format.formatters_by_ft[filetype] = {formatter}
-- OL.callbacks.format.formatters[formatter] = {
--     args = {"--config", OL.paths.coding:abs(filetype, formatter_config)},
--     command = "lua-format",
--     stdin = true
-- }
--
-- --- Link
-- local linter = "selene"
-- local linter_config = "selene.toml"
-- table.insert(OL.callbacks.lint.ft, "BufReadPost *." .. filetype)
-- OL.callbacks.lint.linters_by_ft[filetype] = {linter}
-- OL.callbacks.lint.linters[linter] = {
--     prepend_args = {"--config", OL.paths.coding:abs(filetype, linter_config)}
-- }
