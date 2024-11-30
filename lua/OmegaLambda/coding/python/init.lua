local filetype = "python"
local ext = "py"

local pyproject = OL.paths.coding:abs(filetype, "pyproject.toml")

local function enabled()
    return vim.bo.filetype == filetype
end

--- LSP
local lsp = "basedpyright"
OL.callbacks.pyinstall = OL.OLConfig.new()

OL.callbacks.lsp.ft:add(ext)
OL.callbacks.lsp:add(
    lsp, {
        cmd = {
            "basedpyright-langserver",
            "--verbose",
            "--threads 16",
            "--stdio",
        },
        settings = {
            basedpyright = {
                disableLanguageServices = false,
                disableOrganizeImports = true, --- Using Ruff
                disableTaggedHints = false,
                analysis = {
                    autoImportCompletions = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
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
)

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
            "--config",
            pyproject,
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
            "--config",
            pyproject,
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
            "--config",
            pyproject,
        },
    },
}

OL.callbacks.lint.ft:add(ext)
for linter, opts in pairs(linters) do
    OL.callbacks.lint:add(filetype, linter, opts or {})
end
