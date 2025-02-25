local ft = "rs"
local filetype = "rust"

---
--- === CMP ===
---
CFG.cmp:ft(ft)

---
--- === LSP ===
---
CFG.lsp.ft:add(ft)

--- Will automatically setup rust_analyzer
--- So don't call manually
--- Will also do formatting and linting
local rust = CFG.spec:add("mrcjkb/rustaceanvim")
rust.ft = { filetype }
rust.setup = false
--- Make sure rust_analyzer is installed
table.insert(CFG.mason.ensure_installed, "rust-analyzer")

--- TODO: Add localeader rust commands
--- See [here](https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#books-usage--features)
