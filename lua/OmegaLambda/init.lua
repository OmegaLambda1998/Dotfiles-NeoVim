---
--- === Omega Lambda ===
---
local argv = vim.v.argv
local verbose = vim.tbl_contains(argv, "+verbose")

---
--- === Compatability & Deprecations ===
---
--- uv ---
vim.uv = vim.uv or vim.loop
vim.loop = vim.uv

--- table ---
table.pack = table.pack or function(...)
    return { ... }
end
table.unpack = table.unpack or unpack

---
--- --- Setup ---
---

--- Load Setup
OL = require("OmegaLambda.setup")(
         {
        verbose = verbose,
    }
     )
OL.log:debug("Verbose: %s", OL.verbose)

--- Load Lazy
OL.load(
    "lazy", {
        from = OL.paths,
        strict = true,
    }
)

--- Bootstrap Lazy
OL.lazy.bootstrap()

--- Setup Colourscheme
OL.load(
    "colourscheme", {
        from = OL.paths,
        strict = true,
    }
)

--- Setup Treesitter
OL.load(
    "treesitter", {
        from = OL.paths,
        strict = true,
    }
)

--- Setup Snacks
OL.load(
    "snacks", {
        from = OL.paths.lazy,
        strict = true,
    }
)

---
--- --- Generate Configs ---
---

OL.loadall(
    "*", {
        exclude = {
            "init",
            "setup",
            "lazy",
            "treesitter",
        },
    }
)

---
--- --- Lazy Setup ---
---

--- Pre-setup callbacks
OL.callbacks.pre()

--- Setup
OL.lazy.setup()

--- Post-setup callbacks
OL.callbacks.post()

OL.log:debug("NeoVim Initialised")
OL.log:flush()
