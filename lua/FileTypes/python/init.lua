local ft = "py"
local filetype = "python"

CFG.cmp:ft(ft)

---
--- === LSP ===
---
CFG.lsp.ft:add(ft)

--- Ruff ---
local servers = {}
servers.ruff = {
    enabled = true,
    init_options = {
        settings = {
            logLevel = "info",
            showSyntaxErrors = false,
            codeAction = {
                disableRuleComment = {
                    enable = true,
                },
                fixViolation = {
                    enable = true,
                },
            },
            lint = {
                enable = false, --- Using nvim-lint for this
            },
            format = {
                preview = false, --- Using conform for this
            },
        },
    },
}
CFG.aucmd:on(
    "LspAttach", function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end, {
        group = "RuffHover",
        desc = "LSP: Disable hover capability from Ruff",
    }
)

--- BasedPyRight ---
local inlay_hint = CFG.spec:get("nvim-lspconfig").opts.inlay_hint.enabled

servers.basedpyright = {
    enabled = true,
    settings = {
        basedpyright = {
            disableOrganizeImports = true, --- Using Ruff for this
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                    variableTypes = inlay_hint,
                    callArgumentNames = inlay_hint,
                    functionReturnTypes = inlay_hint,
                    genericTypes = inlay_hint,
                },
                logLevel = CFG.verbose and "Trace" or "Information",
                useLibraryCodeForTypes = true,
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
        mason = false, --- Installed by LSP
        command = vim.fs.joinpath(CFG.mason.bin, "ruff"),
        args = {
            "check",
            "--fix",
            "--exit-zero",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
    ruff_format = {
        mason = false, --- Installed by LSP
        command = vim.fs.joinpath(CFG.mason.bin, "ruff"),
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
    CFG.format:add(filetype, formatter, opts)
end

---
--- === Lint ===
---
local severities = {}
local linters = {
    ruff = {
        parser = function(output)
            local diagnostics = {}
            local ok, results = pcall(vim.json.decode, output)
            if not ok then
                return diagnostics
            end
            for _, result in ipairs(results or {}) do
                local diagnostic = {
                    message = result.message,
                    col = result.location.column - 1,
                    end_col = result.end_location.column - 1,
                    lnum = result.location.row - 1,
                    end_lnum = result.end_location.row - 1,
                    code = result.code,
                    severity = severities[result.code] or
                        vim.diagnostic.severity.INFO,
                    source = "ruff",
                }
                table.insert(diagnostics, diagnostic)
            end
            return diagnostics
        end,
    },
}

for linter, opts in pairs(linters) do
    CFG.lint:add(filetype, linter, opts)
end
