local ft = "jsn"
local filetype = "json"
local alt_filetype = "jsonc"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)
CFG.lsp.ft:add(filetype)
CFG.lsp.ft:add(alt_filetype)

local lsp = "jsonls"
CFG.lsp.servers[lsp] = {}

---
--- === CMP ===
---

CFG.cmp:ft(ft)
CFG.cmp:ft(filetype)
CFG.cmp:ft(alt_filetype)
