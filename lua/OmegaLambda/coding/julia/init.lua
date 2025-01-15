local filetype = "julia"
local ext = "jl"

local function enabled()
    return vim.bo.filetype == filetype
end

--- LSP
local lsp = "julials"
OL.callbacks.lsp.ft:add(ext)
OL.callbacks.lsp:add(lsp, {})

--- CMP
OL.callbacks.cmp.ft:add(ext)

--- --- Format
--- local formatter = ""
--- OL.callbacks.format.ft:add(ext)
--- OL.callbacks.format:add(filetype, formatter, {})
---
--- --- Lint
--- local linter = ""
--- OL.callbacks.lint.ft:add(ext)
--- OL.callbacks.lint:add(filetype, linter, {})
