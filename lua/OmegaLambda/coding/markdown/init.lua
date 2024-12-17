local filetype = "markdown"
local ext = "md"

OL.spec:add(
    "MeanderingProgrammer/render-markdown.nvim", {
        ft = {
            filetype,
        },
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
                backgrounds = {},
            },
        },
    }
)

local function enabled()
    return vim.bo.filetype == filetype
end

--- LSP
local lsp = "marksman"
OL.callbacks.lsp.ft:add(ext)
OL.callbacks.lsp:add(lsp, {})

--- Format
local formatter = "mdformat"
OL.callbacks.format.ft:add(ext)

OL.callbacks.format:add(filetype, formatter, {})

--- Lint
local linter = "markdownlint-cli2"
local linter_config = ".markdownlint-cli2.jsonc"
OL.callbacks.lint.ft:add(ext)
OL.callbacks.lint:add(
    filetype, linter, {
        prepend_args = {
            "--config",
            OL.paths.coding:abs(filetype, linter_config),
        },
    }
)
