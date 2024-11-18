local filetype = "python"
local ext = "py"
table.insert(OL.callbacks.mason.ft, "BufReadPost *." .. ext)

local pyproject = OL.paths.coding:abs(filetype, "pyproject.toml")

--- LSP
local lsp = "basedpyright"
OL.callbacks.pyinstall = OL.OLConfig.new()
table.insert(OL.callbacks.lsp.ft, "BufReadPre *." .. ext)

OL.callbacks.lsp.servers[lsp] = {
    cmd = {
        'basedpyright-langserver',
        '--project',
        pyproject,
        '--stdio',
    },
    settings = {
        basedpyright = {
            disableLanguageServices = false,
            disableOrganizeImports = true,
            disableTaggedHints = false,
            openFilesOnly = false,

            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "recommended",
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = true,
                    functionReturnTypes = true,
                    genericTypes = true,

                },

            },
        },
    },
}

--- CMP
table.insert(OL.callbacks.cmp.ft, "InsertEnter *." .. ext)

--- Format

local formatters = {
    ruff_format = {
        mason = false,
        args = {
            "format",
            "--config",
            pyproject,
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
    ruff_fix = {
        mason = false,
        args = {
            "check",
            "--fix",
            "--config",
            pyproject,
            "--unsafe-fixes",
            "--force-exclude",
            "--exit-zero",
            "--no-cache",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
}

table.insert(OL.callbacks.format.ft, "BufWritePre *." .. ext)
OL.callbacks.format.formatters_by_ft[filetype] = {}
for formatter, opts in pairs(formatters) do
    table.insert(OL.callbacks.format.formatters_by_ft[filetype], formatter)
    OL.callbacks.format.formatters[formatter] = opts or {}
end

--- Lint
local linters = {
    ruff = {
        prepend_args = {
            "--config",
            pyproject,
        },
    }, --- Modern rust-based alternative to flake8, black, isort, pydocstyle, pyupgrade, autoflake, and more
}
-- local linter_config = "selene.toml"
table.insert(OL.callbacks.lint.ft, "BufReadPost *." .. ext)
OL.callbacks.lint.linters_by_ft[filetype] = {}
for linter, opts in pairs(linters) do
    table.insert(OL.callbacks.lint.linters_by_ft[filetype], linter)
    OL.callbacks.lint.linters[linter] = opts or {}
end
