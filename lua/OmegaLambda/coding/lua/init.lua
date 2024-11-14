table.insert(OL.callbacks.mason.ft, "lua")
table.insert(OL.callbacks.mason.install, "luaformatter")
table.insert(OL.callbacks.conform.ft, "lua")
OL.callbacks.conform.formatters_by_ft.lua = {"luaformatter"}
OL.callbacks.conform.formatters.luaformatter = {
    command = "lua-format",
    stdin = true
}
