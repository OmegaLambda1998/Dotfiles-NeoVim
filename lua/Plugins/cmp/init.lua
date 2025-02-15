local blink = CFG.spec:add("saghen/blink.cmp")
local path = CFG.paths.join(
    {
        "Plugins",
        "cmp",
    }
)

CFG.cmp = {
    dependencies = {},
    brackets = {},
    sources = {},
    providers = {},
    fallback_for = {},
    event = {
        "CmdlineEnter",
    },
}
function CFG.cmp:ft(ft)
    table.insert(self.event, "InsertEnter *." .. ft)
end

blink.build = "cargo build --release"
blink.event = CFG.cmp.event
blink.dependencies = CFG.cmp.dependencies
table.insert(
    blink.dependencies, {
        "xzbdmw/colorful-menu.nvim",
    }
)

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
                "label",
                gap = 1,
            },
        },
        components = {
            label = {
                text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(
                        ctx
                    )
                end,
            },
        },
    },
}
blink.opts.completion.documentation = {
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

blink.pre:insert(
    function(opts)
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
            opts.sources.providers[provider] = vim.tbl_deep_extend(
                "force", opts.sources.providers[provider] or {},
                    CFG.cmp.providers[provider] or {}
            )
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
