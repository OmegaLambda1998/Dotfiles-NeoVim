local filetype = "lua"
local formatter = "luaformatter"
local cmp = "lazydev"

--- Mason
table.insert(OL.callbacks.mason.ft, filetype)
table.insert(OL.callbacks.mason.install, formatter)
-- table.insert(OL.callbacks.mason.install, cmp)

--- Conform
table.insert(OL.callbacks.conform.ft, "BufWritePre *." .. filetype)
OL.callbacks.conform.formatters_by_ft[filetype] = {formatter}
OL.callbacks.conform.formatters[formatter] = {
    command = "lua-format",
    stdin = true
}

--- Blink
table.insert(OL.callbacks.cmp.ft, "InsertEnter *." .. filetype)
table.insert(OL.callbacks.cmp.sources, cmp)
OL.callbacks.cmp.providers[cmp] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink"
}

local index, spec, opts = OL.spec:add("folke/lazydev.nvim")
opts.integrations = {blink = true}
-- spec.ft = filetype
