local filetype = "python"
local ext = "py"

local pyproject = OL.paths.coding:abs(filetype, "pyproject.toml")

local function enabled()
    return vim.bo.filetype == filetype
end

--- LSP
OL.callbacks.lsp.ft:add(ext)

local servers = {}
servers.ruff = {
    init_options = {
        settings = {
            configuration = pyproject,
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

for lsp, opts in pairs(servers) do
    OL.callbacks.lsp:add(lsp, opts)
end

--- CMP
OL.callbacks.cmp.ft:add(ext)

--- Format

local formatters = {
    ruff_fix = {
        mason = false,
        args = {
            "check",
            "--fix",
            "--unsafe-fixes",
            --- "--config",
            --- pyproject,
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
            --- "--config",
            --- pyproject,
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
}

OL.callbacks.format.ft:add(ext)
for formatter, opts in pairs(formatters) do
    OL.callbacks.format:add(filetype, formatter, opts or {})
end

--- Lint
local linters = {
    ruff = {
        prepend_args = {
            --- "--config",
            --- pyproject,
        },
    },
}

OL.callbacks.lint.ft:add(ext)
for linter, opts in pairs(linters) do
    OL.callbacks.lint:add(filetype, linter, opts or {})
end
