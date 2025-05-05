local filetype = "*"

---
--- === LSP ===
---

local lang = "en-AU"
local path = vim.fn.stdpath("config") .. "/spell"
local spellfile = path .. "/en.utf-8.add"
CFG.set:opt("spellfile", spellfile)
local words = {}

for word in io.open(spellfile, "r"):lines() do
    table.insert(words, word)
end

local ltex_extra = CFG.spec:add("OmegaLambda1998/ltex_extra.nvim")
ltex_extra.branch = "dev"
ltex_extra.ft = {
    "bib",
    "context",
    "gitcommit",
    "html",
    "markdown",
    "md",
    "org",
    "pandoc",
    "plaintex",
    "quarto",
    "mail",
    "mdx",
    "rmd",
    "rnoweb",
    "rst",
    "latex",
    "tex",
    "text",
    "typst",
    "xhtml",
}

ltex_extra.opts.load_langs = {
    lang,
}
ltex_extra.opts.path = path
ltex_extra.opts.log_level = CFG.verbose and "trace" or "info"

table.insert(CFG.mason.ensure_installed, "ltex-ls-plus")

local lsp = "ltex_plus"
local lsp_config = {
    settings = {
        ltex = {
            enabled = ltex_extra.ft,
            language = lang,
            completionEnabled = false,
            checkFrequency = "save",
            statusBarItem = true,
            dictionary = {
                [lang] = words,
            },
            disabledRules = {
                [lang] = {
                    "TOO_LONG_SENTENCE",
                },
            },
            additionalRules = {
                enablePickyRules = true,
                motherTongue = lang,
            },
            ["ltex-ls"] = {
                logLevel = CFG.verbose and "finest" or "info",
            },
            ["java"] = {
                initialHeapSize = 128,
                maximumHeapSize = 1024,
                sentenceCacheSize = 5000,
            },
        },
    },
}

CFG.lsp.ft:add(filetype)
CFG.lsp.servers[lsp] = lsp_config
