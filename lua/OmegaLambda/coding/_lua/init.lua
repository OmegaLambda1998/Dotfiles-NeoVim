local filetype = "lua"
local _ft = "_lua"

local function enabled()
    return vim.bo.filetype == filetype
end


--- LSP
local lsp = "lua_ls"
local lsp_config = "luarc.json"
OL.callbacks.lsp.ft:add(filetype)
OL.callbacks.lsp:add(
    lsp, {
        cmd = {
            "lua-language-server",
            "--configpath",
            OL.paths.coding:abs(_ft, lsp_config),
        },
    }
)

--- CMP
local spec, opts = OL.spec:add("folke/lazydev.nvim")
opts.integrations = {
    lspconfig = true,
    blink = true,
}

local cmp = "lazydev"
OL.callbacks.cmp.ft:add(filetype)
OL.callbacks.cmp:add(
    cmp, {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        fallback = "lsp",
        enabled = function(ctx)
            return (ctx == nil) or enabled()
        end
,
    }
)

--- Format
local formatter = "lua-format"
local formatter_config = "luaformatter.yml"
OL.callbacks.format.ft:add(filetype)

OL.callbacks.format:add(
    filetype, formatter, {
        mason = "luaformatter",
        prepend_args = {
            "--config",
            OL.paths.coding:abs(_ft, formatter_config),
        },
    }
)

--- Lint
local linter = "selene"
local linter_config = "selene.toml"
OL.callbacks.lint.ft:add(filetype)
OL.callbacks.lint:add(
    filetype, linter, {
        prepend_args = {
            "--config",
            OL.paths.coding:abs(_ft, linter_config),
        },
    }
)
