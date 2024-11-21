local filetype = "tex"
table.insert(OL.callbacks.mason.ft, "BufReadPre *." .. filetype)

vim.filetype.add(
    {
        extension = {
            tex = "tex",
        },
    }
)

--- LSP
local lsp = "texlab"
table.insert(OL.callbacks.lsp.ft, "BufReadPost *." .. filetype)

local settings = {}

settings.build = {
    executable = "tectonic",
    args = {
        "-X",
        "compile",
        "-Z",
        "shell-escape-cwd=.",
        "--keep-logs",
        "--keep-intermediates",
        "--synctex",
        "%f",
    },
    forwardSearchAfter = false,
    onSave = false,
    useFileList = true,
}

settings.forwardSearch = {
    executable = "sioyek",
    args = {
        "--reuse-window",
        "--execute-command",
        "toggle_synctex",
        "--forward-search-file",
        "%f",
        "--forward-search-line",
        "%l",
        "%p",
    },
}

settings.chktex = {
    onOpenAndSave = false,
    onEdit = false,
}

settings.diagnostics = {
    ignoredPatterns = {
        "Unused",
        "Underfull",
        "Overfull",
    },
}

settings.symbols = {
    ignoredPatterns = {},
}

settings.bibtexFormatter = "none"
settings.latexFormatter = "none"

settings.completion = {
    matcher = "fuzzy-ignore-case",
}

settings.inlayHints = {
    labelDefinitions = true,
    labelReferences = true,
    maxLength = 20,
}

settings.experimental = {
    followPackageLinks = true,

    -- mathEnvironments = {},
    -- enumEnvironments = {},
    verbatimEnvironments = {
        "yamlcode",
        "textcode",
        "pythoncode",
    },
    verbatimCommands = {
        "texinline",
        "refinline",
    },
    -- citationCommands = {},
    -- labelDefinitionCommands = {},
    labelReferenceCommands = {
        "refinline",
    },

}

OL.callbacks.lsp.servers[lsp] = {
    settings = {
        texlab = settings,
    },
}

--- Format
local formatter = "latexindent"
local formatter_config = "latexindent.yaml"
table.insert(OL.callbacks.format.ft, "BufWritePre *." .. filetype)
OL.callbacks.format.formatters_by_ft[filetype] = {
    formatter,
}
OL.callbacks.format.formatters[formatter] = {
    args = {
        "-m",
        "-rv",
        "-l",
        OL.paths.coding:abs(filetype, formatter_config),
        "-",
    },
}

--- Link
local linter = "chktex"
local linter_config = "chktexrc"
table.insert(OL.callbacks.lint.ft, "BufReadPost *." .. filetype)
OL.callbacks.lint.linters_by_ft[filetype] = {
    linter,
}
OL.callbacks.lint.linters[linter] = {
    mason = false,
    prepend_args = {
        "-g",
        "-l",
        OL.paths.coding:abs(filetype, linter_config),
    },
}
