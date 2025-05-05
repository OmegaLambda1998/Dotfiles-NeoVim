local ft = "md"
local filetypes = {
    "markdown",
    "markdown_inline",
}

vim.list_extend(CFG.treesitter.ensure_installed, filetypes)

local dynomark = CFG.spec:add("k-lar/dynomark.nvim")
dynomark.ft = filetypes
dynomark.opts = {
    auto_download = true,
    results_view_location = "tab",
}

---
--- === CMP ===
---

local render = CFG.spec:add("MeanderingProgrammer/render-markdown.nvim")
render.ft = filetypes

render.opts.completions = {
    win_options = {
        conceallevel = {
            default = 0,
            rendered = 3,
        },
    },
    blink = {
        enabled = true,
    },
}

---
--- === LSP ===
---
CFG.lsp.ft:add(ft)

--- Marksman ---
CFG.lsp.servers.marksman = {
    enabled = true,
}

---
--- === Format ===
---
CFG.format:add(filetypes[1], "markdownlint-cli2", {})

---
--- === Lint ===
---
CFG.lint:add(filetypes[1], "markdownlint-cli2", {})
