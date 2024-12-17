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

opts.conceals = {
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
}
opts.imaps = {
    enabled = false,
    add = {},
    default_leader = ";",
}
opts.surrounds = {
    enabled = false,
    command = "c",
    math = "$",
    quotation = "\"",
}
opts.texlab = {
    enabled = true,
    build = "<localleader>ll",
    forward = "<localleader>gl",
    cancel_build = "<localleader>lx",
    close_env = "<localleader>le",
    change_env = "<localleader>lc",
    toggle_star = "<localleader>ls",
}

spec.config = function(_, o)
    OL.map(
        {
            "<localleader>l",
            group = "Latex",
            desc = "Latex",
        }
    )
    vim.g.latex_conf = o
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
    onSave = false,
    useFileList = false,
}

local inverse_search = OL.fstring(
    "\"nvim --headless --server %s --remote \"%s\" && nvim --headless --server %s --remote-send \"gg%sjk0%slh\"\"",
        vim.v.servername, "%%1", vim.v.servername, "%%2", "%%3"
)

--- Forward Search
settings.forwardSearch = {
    executable = "sioyek",
    args = {
        "--reuse-window",
        "--execute-command",
        "turn_on_synctex",
        "--inverse-search",
        OL.fstring("bash -c %s", inverse_search),
        "--forward-search-file",
        "%f",
        "--forward-search-line",
        "%l",
        "%p",
    },
}

--- Diagnostics
settings.diagnostics = {
    ignoredPatterns = {
        "Unused entry", --- Ignore unused bibtex entries
        "Underfull", --- Ignore underfull hbox
        --- "Overfull",
    },
}

--- TOC / Document Symbols
--- settings.symbols = {
---     ignoredPatterns = {},
--- }

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
