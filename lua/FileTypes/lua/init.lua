local ft = "lua"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "lua_ls"
CFG.lsp.servers[lsp] = {}

---
--- === CMP ===
---

local lazydev = CFG.spec:add("folke/lazydev.nvim")
local blink_config = CFG.spec:get("blink.cmp")
lazydev.ft = { ft }
lazydev.opts.integrations = {
    lspconfig = true,
    blink = blink_config and blink_config.cond or false,
}
CFG.cmp.sources[ft] = {
    "lazydev",
}
CFG.cmp.providers["lazydev"] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
}

---
--- === Format ===
---
local formatter = "lua-format"
CFG.format:add(
    ft, formatter, {
        mason = "luaformatter",
    }
)

---
--- === Lint ===
---
local linter = "selene"
CFG.lint:add(ft, linter)

---
--- === Integrations ===
---
CFG.rainbow_delimiter.query["lua"] = "rainbow-blocks"
CFG.rainbow_delimiter.priority["lua"] = 210
