local ft = "tml"
local filetype = "toml"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)
CFG.lsp.ft:add(filetype)

local lsp = "taplo"

CFG.lsp.servers[lsp] = {}

---
--- === CMP ===
---

CFG.cmp:ft(ft)
CFG.cmp:ft(filetype)
