local filetype = "lua"
table.insert(OL.callbacks.mason.ft, "BufReadPre *." .. filetype)

--- LSP
local lsp = "lua_ls"
table.insert(OL.callbacks.lsp.ft, "BufReadPost *." .. filetype)
OL.callbacks.lsp.servers[lsp] = {settings = {Lua = {}}}

--- CMP
local cmp = "lazydev"
table.insert(OL.callbacks.cmp.ft, "InsertEnter *." .. filetype)
table.insert(OL.callbacks.cmp.sources, cmp)
OL.callbacks.cmp.providers[cmp] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink"
}
local index, spec, opts = OL.spec:add("folke/lazydev.nvim")
opts.integrations = {blink = true}

--- Format
local formatter = "luaformatter"
table.insert(OL.callbacks.format.ft, "BufWritePre *." .. filetype)
OL.callbacks.format.formatters_by_ft[filetype] = {formatter}
OL.callbacks.format.formatters[formatter] = {
    command = "lua-format",
    stdin = true
}

--- Link
local linter = "luacheck"
table.insert(OL.callbacks.lint.ft, "BufReadPost *." .. filetype)
OL.callbacks.lint.linters_by_ft[filetype] = {linter}
OL.callbacks.lint.linters[linter] = {}
