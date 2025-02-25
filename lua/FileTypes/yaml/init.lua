local ft = "yml"
local filetype = "yaml"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)
CFG.lsp.ft:add(filetype)

---
--- === CMP ===
---

CFG.cmp:ft(ft)
CFG.cmp:ft(filetype)
