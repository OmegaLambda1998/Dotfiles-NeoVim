local ft = "lua"
local path = CFG.paths.join(
    {
        "FileTypes",
        ft,
    }
)

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "lua_ls"
local lsp_config = "luarc.json"

CFG.lsp.servers[lsp] = {
    cmd = {
        "lua-language-server",
        "--configpath",
        path.join(
            {
                lsp_config,
            }
        ).path,
    },
}

---
--- === CMP ===
---

local lazydev = CFG.spec:add("folke/lazydev.nvim")
local blink_config = CFG.spec:get("blink.cmp")
lazydev.ft = { "lua" }
lazydev.opts.integrations = {
    lspconfig = true,
    blink = blink_config and blink_config.cond or false,
}

---
--- === Integrations ===
---
CFG.rainbow_delimiter.query["lua"] = "rainbow-blocks"
CFG.rainbow_delimiter.priority["lua"] = 210
