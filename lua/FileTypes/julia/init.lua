local ft = "jl"
local filetype = "julia"
local path = CFG.paths.join(
    {
        "FileTypes",
        "julia",
    }
)

---
--- === CMP ===
---

CFG.cmp:ft(ft)

---
--- === LSP ===
---
CFG.lsp.ft:add(ft)

local servers = {}
for server, opts in pairs(servers) do
    CFG.lsp.servers[server] = opts
end

---
--- === Format ===
---

local formatters = {}
for formatter, opts in pairs(formatters) do
    CFG.format:add(filetype, formatter, opts)
end

---
--- === Lint ===
---
local linters = {}

for linter, opts in pairs(linters) do
    CFG.lint:add(filetype, linter, opts)
end
