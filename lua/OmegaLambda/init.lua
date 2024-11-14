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
table.pack = table.pack or function(...) 
	local args = {...} 
	if #args == 1 and type(args[1]) == "table" then
		return args[1]
	end
	return args
end
table.unpack = table.unpack or unpack

---
--- --- Setup ---
---

--- Load Setup
OL = require("OmegaLambda.setup")
OL.verbose = false

--- Load Lazy
OL.load("lazy", {from = "root", strict=true})

--- Bootstrap Lazy
OL.lazy.bootstrap()

---
--- --- Generate Configs ---
---

OL.loadall("*", {exclude = {"init.lua", "setup", "lazy"}})

---
--- --- Lazy Setup ---
---

--- Pre-setup callbacks

--- Setup
OL.lazy.setup()

--- Post-setup callbacks
