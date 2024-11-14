---
--- === Omega Lambda ===
---

---
--- --- Compatability ---
---

--- uv
vim.uv = vim.uv or vim.loop
vim.loop = vim.uv

--- table
table.pack = table.pack or function(...) return {...} end
table.unpack = table.unpack or unpack

---
--- --- Setup ---
---

--- Load Setup
OL = require("OmegaLambda.setup")({
	verbose = false,
})
OL.log:debug("Verbose: %s", OL.verbose)

--- Load Lazy
OL.load("lazy", {from = OL.paths, strict=true})

--- Bootstrap Lazy
OL.lazy.bootstrap()

--- Setup Colourscheme
OL.load("colourscheme", {from = OL.paths, strict=true})

--- Setup Treesitter
OL.load("treesitter", {from = OL.paths, strict=true})

--- Setup Snacks
OL.load("snacks", {from = OL.paths.lazy, strict=true})

---
--- --- Generate Configs ---
---

OL.loadall("*", {exclude = {"init", "setup", "lazy", "treesitter"}})

---
--- --- Lazy Setup ---
---

--- Pre-setup callbacks
OL.callbacks.pre()
table.insert(OL.callbacks.treesitter.exclude, "latex")

--- Setup
OL.lazy.setup()

--- Post-setup callbacks
OL.callbacks.post()

OL.log:debug("NeoVim Initialised")
OL.events.trigger(OL.events.init_end) --- TODO: Make metatable version
