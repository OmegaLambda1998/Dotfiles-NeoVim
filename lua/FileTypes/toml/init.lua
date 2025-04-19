local ft = "tml"
local filetype = "toml"

local path = CFG.paths:join(
    {
        "FileTypes",
        "toml",
    }
)

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)
CFG.lsp.ft:add(filetype)

local lsp = "taplo"

CFG.lsp.servers[lsp] = {
    cmd = {
        "taplo",
        "lsp",
        "--config",
        path:join(
            {
                "taplo.toml",
            }
        ).path,
        "stdio",
    },
}

---
--- === CMP ===
---

CFG.cmp:ft(ft)
CFG.cmp:ft(filetype)
