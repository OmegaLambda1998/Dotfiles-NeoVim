local ft = "py"
local filetype = "python"

---
--- === LSP ===
---
CFG.lsp.ft:add(ft)

local servers = {}
servers.ruff = {
    init_options = {
        settings = {
            showSyntaxErrors = false,
            lint = {
                enable = false,
            },
            format = {
                preview = false,
            },
        },
    },
}
servers.basedpyright = {
    settings = {
        basedbypright = {
            disableOrganizeImports = true, --- Using Ruff for this
            analysis = {
                autoImportCompletions = false, --- Slows down completion a lot
                autoSearchPaths = true, --- Search common paths like src/
                diagnosticMode = "openFilesOnly", --- Don't search everything everywhere. It will be slow
                useLibraryCodeForTypes = true, --- Analyse library code for type information if type stubs are missing
                typeCheckingMode = "recommended",
                inlayHints = {
                    variableTypes = true,
                    callArgumentMames = true,
                    functionReturnTypes = true,
                    genericTypes = true,
                },
            },
        },
        python = {
            pythonPath = ".venv/bin/python",
        },
    },
}

for server, opts in pairs(servers) do
    CFG.lsp.servers[server] = opts
end

---
--- === Format ===
---

local formatters = {
    ruff_fix = {
        mason = false,
        args = {
            "check",
            "--fix",
            "--unsafe-fixes",
            "--exit-zero",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
    ruff_format = {
        mason = false,
        args = {
            "format",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
}

for formatter, opts in pairs(formatters) do
    CFG.format:add(ft, formatter, opts)
end

---
--- === Lint ===
---
local linters = {
    ruff = {},
}

for linter, opts in pairs(linters) do
    CFG.lint:add(filetype, linter, opts)
end
