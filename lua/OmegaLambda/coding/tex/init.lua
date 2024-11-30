local filetype = "tex"

local function enabled()
    return vim.bo.filetype == filetype
end


vim.filetype.add(
    {
        extension = {
            tex = "tex",
        },
    }
)

---
--- --- Conceals ---
--- 
local spec, opts = OL.spec:add("mathjiajia/latex.nvim")
spec.event = {
    "BufReadPost *." .. filetype,
}
spec.init = function()
    OL.map(
        {
            "<localleader>l",
            group = "Latex",
            desc = "Latex",
        }
    )
    vim.g.latex_conf = {
        conceals = {
            enabled = {
                "amssymb",
                "core",
                "delim",
                "font",
                "greek",
                "math",
                "mleftright",
                "script",
            },
            add = {},
        },
        imaps = {
            enabled = false,
            add = {},
            default_leader = ";",
        },
        surrounds = {
            enabled = false,
            command = "c",
            math = "$",
            quotation = "\"",
        },
        texlab = {
            enabled = true,
            build = "<localleader>ll",
            forward = "<localleader>gf",
            cancel_build = "<localleader>lc",
        },
    }
end


---
--- --- LSP ---
---
local lsp = "texlab"
OL.callbacks.lsp.ft:add(filetype)

local settings = {}

--- Disable, handled by linter
settings.chktex = {
    onOpenAndSave = false,
    onEdit = false,
}

--- Disable, handled by formatter
settings.bibtexFormatter = "none"
settings.latexFormatter = "none"

--- Compile PDF
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
    onSave = true,
    useFileList = false,
}

--- Forward Search
settings.forwardSearch = {
    executable = "sioyek",
    args = {
        "--reuse-window",
        "--execute-command",
        "turn_on_synctex",
        "--inverse-search",
        OL.fstring(
            "\"nvim --headless --server %s --remote-send %s\"",
                vim.v.servername, "\"<C-\\><C-N>:e %1<CR><C-\\><C-N>:%2<CR>\""
        ),
        "--forward-search-file",
        "%f",
        "--forward-search-line",
        "%l",
        "--forward-search-column",
        "%p",
    },
}

--- Diagnostics
settings.diagnostics = {
    ignoredPatterns = {
        "Unused",
        "Underfull",
        "Overfull",
    },
}

--- TOC / Document Symbols
settings.symbols = {
    ignoredPatterns = {},
}

--- Completion
settings.completion = {
    matcher = "fuzzy-ignore-case",
}

--- Inlay hints
settings.inlayHints = {
    labelDefinitions = true,
    labelReferences = false,
    maxLength = 20,
}

settings.experimental = {
    followPackageLinks = true,

    --- Extend Environments
    mathEnvironments = {},
    enumEnvironments = {},
    verbatimEnvironments = {
        "yamlcode",
        "textcode",
        "pythoncode",
    },

    --- Extend Commands
    citationCommands = {},
    labelDefinitionCommands = {},
    labelReferenceCommands = {
        "refinline",
    },

    --- Extend Prefixes
    labelDefinitionPrefixes = {},
    labelReferencePrefixes = {},
}

OL.callbacks.lsp:add(
    lsp, {
        settings = {
            texlab = settings,
        },
    }
)

---
--- --- Formatter ---
---
local formatter = "latexindent"
local formatter_config = "latexindent.yaml"
OL.callbacks.format.ft:add(filetype)

OL.callbacks.format:add(
    filetype, formatter, {
        prepend_args = {
            "-m",
            "-rv",
            "-l",
            OL.paths.coding:abs(filetype, formatter_config),
        },
    }
)

---
--- --- Linter ---
---
local linter = "chktex"
local linter_config = "chktexrc"
OL.callbacks.lint.ft:add(filetype)

OL.callbacks.lint:add(
    filetype, linter, {
        mason = false,
        prepend_args = {
            "-g",
            "-l",
            OL.paths.coding:abs(filetype, linter_config),
        },
    }
)
