local ft = "lua"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "lua_ls"

CFG.lsp.servers[lsp] = {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and
                (vim.uv.fs_stat(path .. "/.luarc.json") or
                    vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend(
            "force", client.config.settings.Lua, {
                runtime = {
                    path = {
                        "?.lua",
                        "?/init.lua",
                    },
                    pathStrict = true,
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    ignoreDir = {
                        "/lua",
                    },
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            }
        )
    end,
    settings = {
        Lua = {},
    },
}

---
--- === CMP ===
---

local url = "folke/lazydev.nvim"
local lazydev = CFG.spec:add(url)
lazydev.ft = { ft }
lazydev.opts.integrations = {
    lspconfig = true,
}
CFG.cmp:ft(ft)
CFG.cmp.sources[ft] = {
    "lazydev",
}
CFG.cmp.providers["lazydev"] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    score_offset = 100,
}
CFG.cmp.fallback_for["lazydev"] = {
    "lsp",
}
table.insert(
    CFG.cmp.dependencies, {
        url,
    }
)

---
--- === Format ===
---
local formatter = "lua-format"
CFG.format:add(
    ft, formatter, {
        mason = "luaformatter",
    }
)

---
--- === Lint ===
---
local linter = "selene"
CFG.lint:add(ft, linter)

---
--- === Integrations ===
---
CFG.rainbow_delimiter.query["lua"] = "rainbow-blocks"
CFG.rainbow_delimiter.priority["lua"] = 210
