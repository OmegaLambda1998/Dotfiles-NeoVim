local blink = CFG.spec:add("saghen/blink.cmp")
local path = CFG.paths.join(
    {
        "Plugins",
        "cmp",
    }
)

CFG.cmp = {
    dependencies = {
        {
            "xzbdmw/colorful-menu.nvim",
        },
        {
            "Saghen/blink.compat",
        },
    },
    brackets = {},
    default_sources = {},
    sources = {},
    providers = {},
    fallback_for = {
        buffer = {
            "lsp",
            "path",
        },
    },
    event = {
        "CmdlineEnter",
        "InsertEnter",
    },
}
function CFG.cmp:ft(ft)
    table.insert(self.event, "InsertEnter *." .. ft)
end

blink.build = "cargo build --release"
blink.event = CFG.cmp.event
blink.dependencies = CFG.cmp.dependencies

--- Snippets ---
local enable_snippets = true

--- Completion ---
blink.opts.completion = {}
blink.opts.completion.keyword = {
    range = "prefix",
}
blink.opts.completion.list = {
    selection = {
        preselect = false, --- Require explicitly selecting first element
        auto_insert = true,
    },
}
blink.opts.completion.accept = {
    auto_brackets = {
        enabled = true,
        default_brackets = {
            "(",
            ")",
        },
        override_brackets_for_filetypes = CFG.cmp.brackets,
    },
}

blink.opts.completion.menu = {
    border = "single",
    draw = {
        columns = {
            {
                "kind_icon",
            },
            {
                "provider",
            },
            {
                "label",
                gap = 1,
            },
            { "lsp" },
        },
        components = {
            label = {
                text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                    local hl =
                        require("colorful-menu").blink_components_highlight(
                            ctx
                        )
                    return hl
                end,
            },
            provider = {
                text = function(ctx)
                    return "[" .. ctx.item.source_name:sub(1, 3) .. "]"
                end,
                highlight = function(ctx)
                    return ctx.kind_hl or ("BlinkCmpKind" .. ctx.kind)
                end,
            },
            lsp = {
                text = function(ctx)
                    local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                    if not (client and not client:is_stopped()) then
                        return
                    end
                    local source = client.name
                    if #source > 9 then
                        source = source:sub(1, 3) .. "..." ..
                                     source:sub(#source - 3, #source)
                    end
                    return "<" .. source .. ">"
                end,
                highlight = "BlinkCmpLabelDetail",
            },
        },
    },
}
blink.opts.completion.documentation = {
    auto_show = true,
    auto_show_delay_ms = 250,
    window = {
        border = "single",
    },
}

blink.opts.completion.trigger = {
    prefetch_on_insert = true,
}

--- Signature ---
blink.opts.signature = {
    enabled = true,
}
blink.opts.signature.trigger = {
    show_on_insert = true,
}
blink.opts.signature.window = {
    border = "single",
}

--- Fuzzy ---
blink.opts.fuzzy = {
    sorts = {
        "score",
        "sort_text",
    },
}

--- Sources ---
blink.opts.sources = {
    per_filetype = {},
    providers = {},
    default = {
        "lsp",
        "path",
        "buffer",
    },
}

--- Providers ---
local provider_config = {
    enabled = true,
    async = true,
    fallbacks = {},
}

blink.opts.sources.providers.snippets = {
    enabled = enable_snippets,
    opts = {
        search_paths = {
            path.join(
                {
                    "snippets",
                }
            ).path,
        },
    },
}
if blink.opts.sources.providers.snippets.enabled then
    table.insert(blink.opts.sources.default, "snippets")
    require(
        path.join(
            {
                "snippets",
            }
        ).mod
    ).setup(blink)
end
local snippet_capabilities = {
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = blink.opts.sources.providers.snippets.enabled,
            },
        },
    },
}

--- Compat Sources ---

table.insert(blink.dependencies, "kdheepak/cmp-latex-symbols")
table.insert(blink.opts.sources.default, "latex_symbols")
blink.opts.sources.providers.latex_symbols = {
    enabled = true,
    name = "latex_symbols",
    module = "blink.compat.source",
}

blink.pre:insert(
    function(opts)
        opts.sources.default = vim.list_extend(
            opts.sources.default, CFG.cmp.default_sources
        )

        --- First get default providers
        local providers = vim.deepcopy(opts.sources.default)

        --- Then, process each per_filetype provider
        for ft, ft_providers in pairs(CFG.cmp.sources) do
            --- If provider doesn't already have an enable function
            --- Enable on filetype
            for _, provider in ipairs(ft_providers) do
                CFG.cmp.providers[provider] = vim.tbl_deep_extend(
                    "force", {
                        enabled = function()
                            return vim.bo.filetype == ft
                        end,
                    }, CFG.cmp.providers[provider] or {}
                )
            end

            --- Ensure each filetype still has all the normal default providers
            for _, provider in ipairs(opts.sources.default) do
                if not vim.tbl_contains(ft_providers) then
                    table.insert(ft_providers, provider)
                end
            end

            --- Add per_filetype providers
            opts.sources.per_filetype[ft] = ft_providers

            --- Add per_filetype provider configs
            for _, provider in ipairs(ft_providers) do
                if not vim.tbl_contains(providers, provider) then
                    table.insert(providers, provider)
                end
            end
        end

        --- Make sure each provider has the following default config
        --- Overwriting where applicable
        for _, provider in ipairs(providers) do
            local config = vim.deepcopy(provider_config)
            opts.sources.providers[provider] = vim.tbl_deep_extend(
                "force", config, opts.sources.providers[provider] or {},
                    CFG.cmp.providers[provider] or {}
            )
        end

        --- Add per_filtype providers as fallbacks
        for fallback, targets in pairs(CFG.cmp.fallback_for) do
            for _, target in ipairs(targets) do
                if not vim.tbl_contains(
                    opts.sources.providers[target].fallbacks, fallback
                ) then
                    table.insert(
                        opts.sources.providers[target].fallbacks, fallback
                    )
                end
            end
        end

        return opts
    end
)

--- Keymap ---
blink.opts.keymap = {
    preset = "none",

    ["<Tab>"] = {
        "select_next",
        "fallback",
    },
    ["<S-Tab>"] = {
        "select_prev",
        "fallback",
    },

    ["<CR>"] = {
        "accept",
        "fallback",
    },

    ["<C-K>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
        "fallback",
    },
    ["<Up>"] = {
        "scroll_documentation_up",
        "fallback",
    },
    ["<Down>"] = {
        "scroll_documentation_down",
        "fallback",
    },
}

--- Integrations ---
CFG.colourscheme:set("blink_cmp")
blink.post:insert(
    function()
        CFG.lsp.capabilities = vim.tbl_deep_extend(
            "force", CFG.lsp.capabilities, {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            }, {
                capabilities = snippet_capabilities,
            }
        )
    end
)

--- Workaround to get tab working in snippets
if vim.fn.has("nvim-0.11") == 1 then
    -- Ensure that forced and not configurable `<Tab>` and `<S-Tab>`
    -- buffer-local mappings don't override already present ones
    local expand_orig = vim.snippet.expand
    vim.snippet.expand = function(...)
        local tab_map = vim.fn.maparg("<Tab>", "i", false, true)
        local stab_map = vim.fn.maparg("<S-Tab>", "i", false, true)
        expand_orig(...)
        vim.schedule(
            function()
                tab_map.buffer, stab_map.buffer = 1, 1
                -- Override temporarily forced buffer-local mappings
                vim.fn.mapset("i", false, tab_map)
                vim.fn.mapset("i", false, stab_map)
            end
        )
    end
end
