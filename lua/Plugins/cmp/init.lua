local blink = CFG.spec:add("saghen/blink.cmp")
local path = CFG.paths.join(
    {
        "Plugins",
        "cmp",
    }
)

CFG.cmp = {
    brackets = {},
    sources = {},
    providers = {},
}

blink.build = "cargo build --release"
blink.event = {
    "CmdlineEnter",
}
blink.dependencies = {
    {
        "xzbdmw/colorful-menu.nvim",
    },
}

--- Snippets ---
require(
    path.join(
        { "snippets" }
    ).mod
)

--- Completion ---
blink.opts.completion = {}
blink.opts.completion.keyword = {
    range = "full",
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
    default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
    },
    per_filetype = {},
}

blink.opts.sources.providers = {}
blink.opts.sources.providers.lsp = {
    async = true,
}
blink.opts.sources.providers.snippets = {
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

blink.pre:insert(
    function(opts)
        local providers = opts.sources.default
        for ft, ft_providers in pairs(CFG.cmp.sources) do
            for _, provider in ipairs(opts.sources.default) do
                if not vim.tbl_contains(ft_providers) then
                    table.insert(ft_providers, provider)
                end
            end
            opts.sources.per_filetype[ft] = ft_providers

            for _, provider in ipairs(ft_providers) do
                if not vim.tbl_contains(providers, provider) then
                    table.insert(providers, provider)
                end
            end
        end

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
        CFG.lsp.capabilities = require("blink.cmp").get_lsp_capabilities()
    end
)
