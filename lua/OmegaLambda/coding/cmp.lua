---
--- === Load Plugins ===
---
OL.spec:add(
    "rafamadriz/friendly-snippets", {
        config = function()
        end,
    }
)

local compat, _ = OL.spec:add(
    "Saghen/blink.compat", {
        opts = {
            impersonate_nvim_cmp = true,
        },
    }
)
compat.dependencies = {}

local spec, opts = OL.spec:add("Saghen/blink.cmp")

spec.dependencies = {
    "williamboman/mason.nvim",
    "rafamadriz/friendly-snippets",
}

OL.paths.coding:append("snippets")

OL.callbacks.colourscheme.blink_cmp = true

spec.version = false
spec.build = "cargo build --release"

---@class OLCMP: OLConfig
OL.callbacks.cmp = OL.OLConfig.new()
OL.callbacks.cmp.ft = OL.OLConfig.new(
    {
        add = function(self, ft)
            table.insert(self, "InsertEnter *." .. ft)
        end,
    }
)

spec.event = OL.callbacks.cmp.ft

---
--- === Sources ===
---

OL.callbacks.cmp.sources = OL.OLConfig.new()
OL.callbacks.cmp.providers = OL.OLConfig.new()

local enabled_providers = function(ctx)
    local providers = {}
    for provider, provider_opts in pairs(OL.callbacks.cmp.providers) do
        if provider_opts.enabled(ctx) then
            table.insert(providers, provider)
        end
    end
    return providers
end

opts.sources = {
    default = enabled_providers,
    providers = OL.callbacks.cmp.providers,
    cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
            return {
                "buffer",
            }
        end
        -- Commands
        if type == ":" then
            return {
                "cmdline",
            }
        end
        return {}
    end,
}

function OL.callbacks.cmp:add(provider, provider_opts)
    local default_opts = {
        name = provider,
        module = nil,
        enabled = function(_)
            return true
        end,
        async = true,
        transform_items = nil,
        should_show_items = true,
        max_items = nil,
        min_keyword_length = 1,
        fallbacks = {},
        score_offset = 0,
        override = nil,
        opts = {},
    }
    provider_opts = vim.tbl_deep_extend("force", default_opts, provider_opts)
    OL.callbacks.cmp.providers[provider] = provider_opts
    table.insert(OL.callbacks.cmp.sources, provider)
end

function OL.callbacks.cmp:compat(source, provider, provider_opts)
    table.insert(compat.dependencies, source)
    provider_opts.module = provider_opts.module or "blink.compat.source"
    OL.callbacks.cmp:add(provider, provider_opts)
end

OL.callbacks.cmp:add(
    "lsp", {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
        fallbacks = {
            "buffer",
        },
    }
)

OL.callbacks.cmp:add(
    "path", {
        name = "Path",
        module = "blink.cmp.sources.path",
        opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
            get_cwd = function(_)
                local roots = OL.get_roots()
                local cwd = roots.cwd
                if type(cwd) == "table" then
                    cwd = cwd[1]
                end
                return cwd
            end,
        },
    }
)

OL.callbacks.cmp:add(
    "snippets", {
        name = "Snippets",
        module = "blink.cmp.sources.snippets",
        opts = {
            friendly_snippets = true,
            search_paths = {
                tostring(OL.paths.coding.snippets),
            },
            global_snippets = {
                "all",
            },
            extended_filetypes = {},
            ignored_filetypes = {},
            get_filetype = function(_)
                return vim.bo.filetype
            end,
        },
    }
)

OL.callbacks.cmp:add(
    "buffer", {
        name = "Buffer",
        module = "blink.cmp.sources.buffer",
        fallbacks = {
            "ripgrep",
        },
    }
)

---
--- === Options ===
---

opts.keymap = {
    ["<CR>"] = {
        "accept",
        "fallback",
    },

    ["<S-Tab>"] = {
        "select_prev",
        "fallback",
    },
    ["<Tab>"] = {
        "select_next",
        "fallback",
    },

    ["<C-Up>"] = {
        "scroll_documentation_up",
        "fallback",
    },
    ["<C-Down>"] = {
        "scroll_documentation_down",
        "fallback",
    },

    ["<C-space>"] = {
        "show",
        "show_documentation",
        "hide_documentation",
    },
}

opts.snippets = {
    --- Function to use when expanding LSP provided snippets
    expand = function(snippet)
        vim.snippet.expand(snippet)
    end,
    --- Function to use when checking if a snippet is active
    active = function(filter)
        vim.snippet.active(filter)
    end,
    --- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    jump = function(direction)
        vim.snippet.jump(direction)
    end,
}

opts.completion = {}
opts.completion.keyword = {
    --- 'prefix' will fuzzy match on the text before the cursor
    --- 'full' will fuzzy match on the text before *and* after the cursor
    --- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
    range = "full",
    --- Regex used to get the text when fuzzy matching
    regex = "[-_]\\|\\k",
    --- After matching with regex, any characters matching this regex at the prefix will be excluded
    exclude_from_prefix_regex = "[\\-]",
}

opts.completion.trigger = {
    --- when false, will not show the completion window automatically when in a snippet
    show_in_snippet = true,
    --- When true, will show the completion window after typing a character that matches the `keyword.regex`
    show_on_keyword = true,
    --- When true, will show the completion window after typing a trigger character
    show_on_trigger_character = true,
    --- LSPs can indicate when to show the completion window via trigger characters
    --- however, some LSPs (i.e. tsserver) return characters that would essentially
    --- always show the window. We block these by default
    show_on_blocked_trigger_characters = {
        " ",
        "\n",
        "\t",
    },
    --- when true, will show the completion window when the cursor comes after a trigger character after accepting an item
    show_on_accept_on_trigger_character = true,
    --- when true, will show the completion window when the cursor comes after a trigger character when entering insert mode
    show_on_insert_on_trigger_character = true,
    --- list of additional trigger characters that won't trigger the completion window when the cursor comes after a trigger character when entering insert mode/accepting an item
    show_on_x_blocked_trigger_characters = {
        "'",
        "\"",
        "(",
    },
}

opts.completion.list = {
    --- Maximum number of items to display
    max_items = 200,
    --- Controls if completion items will be selected automatically,
    --- and whether selection automatically inserts
    selection = "manual",
    --- Controls how the completion items are selected
    --- 'preselect' will automatically select the first item in the completion list
    --- 'manual' will not select any item by default
    --- 'auto_insert' will not select any item by default, and insert the completion items automatically
    --- when selecting them
    --- 
    --- You may want to bind a key to the `cancel` command, which will undo the selection
    --- when using 'auto_insert'
    cycle = {
        --- When `true`, calling `select_next` at the *bottom* of the completion list
        --- will select the *first* completion item.
        from_bottom = true,
        --- When `true`, calling `select_prev` at the *top* of the completion list
        --- will select the *last* completion item.
        from_top = true,
    },
}

opts.completion.accept = {
    --- Create an undo point when accepting a completion item
    create_undo_point = true,
    auto_brackets = {
        --- Whether to auto-insert brackets for functions
        enabled = false,
        --- Default brackets to use for unknown languages
        default_brackets = {
            "(",
            ")",
        },
        --- Overrides the default blocked filetypes
        override_brackets_for_filetypes = {},
        --- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
            enabled = true,
            blocked_filetypes = {
                "typescriptreact",
                "javascriptreact",
                "vue",
            },
        },
        --- Asynchronously use semantic token to determine if brackets should be added
        semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = {},
            --- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 400,
        },
    },
}

opts.completion.menu = {
    enabled = true,
    min_width = 15,
    max_height = 10,
    border = "none",
    winblend = 15,
    winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
    --- Keep the cursor X lines away from the top/bottom of the window
    scrolloff = 2,
    --- Note that the gutter will be disabled when border ~= 'none'
    scrollbar = true,
    --- Which directions to show the window,
    --- falling back to the next direction when there's not enough space
    direction_priority = {
        "s",
        "n",
    },
    --- Controls how the completion items are rendered on the popup window
    draw = {
        --- Aligns the keyword you've typed to a component in the menu
        align_to_component = "source", --- or 'none' to disable
        --- Left and right padding, optionally { left, right } for different padding on each side
        padding = 1,
        --- Gap between columns
        gap = 1,
        --- Use treesitter to highlight the label text from these sources
        treesitter = opts.sources.providers,

        --- Components to render, grouped by column
        columns = {
            {
                "source",
                "kind",
                "kind_icon",
                gap = 1,
            },
            {
                "label",
                "label_description",
                gap = 1,
            },
        },
        --- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
        --- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },

        --- Definitions for possible components to render. Each component defines:
        ---   ellipsis: whether to add an ellipsis when truncating the text
        ---   width: control the min, max and fill behavior of the component
        ---   text function: will be called for each item
        ---   highlight function: will be called only when the line appears on screen
        components = {

            source = {
                ellipsis = false,
                text = function(ctx)
                    return ctx.item and ctx.item.source_name or "Unknown"
                end,
                highlight = function(ctx)
                    return (require(
                               "blink.cmp.completion.windows.render.tailwind"
                           ).get_hl(ctx)) or ("BlinkCmpKind" .. ctx.kind)
                end,
            },

            kind_icon = {
                ellipsis = false,
                text = function(ctx)
                    return ctx.kind_icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                    return (require(
                               "blink.cmp.completion.windows.render.tailwind"
                           ).get_hl(ctx)) or ("BlinkCmpKind" .. ctx.kind)
                end,
            },

            kind = {
                ellipsis = false,
                width = {
                    fill = true,
                },
                text = function(ctx)
                    return OL.fstring(
                        "[%s]", ctx.kind ~= "Unknown" and ctx.kind or "Text"
                    )
                end,
                highlight = function(ctx)
                    return (require(
                               "blink.cmp.completion.windows.render.tailwind"
                           ).get_hl(ctx)) or ("BlinkCmpKind" .. ctx.kind)
                end,
            },

            label = {
                width = {
                    fill = true,
                    max = 60,
                },
                text = function(ctx)
                    return ctx.label .. ctx.label_detail
                end,
                highlight = function(ctx)
                    --- label and label details
                    local highlights = {
                        {
                            0,
                            #ctx.label,
                            group = ctx.deprecated and "BlinkCmpLabelDeprecated" or
                                "BlinkCmpLabel",
                        },
                    }
                    if ctx.label_detail then
                        table.insert(
                            highlights, {
                                #ctx.label,
                                #ctx.label + #ctx.label_detail,
                                group = "BlinkCmpLabelDetail",
                            }
                        )
                    end

                    --- characters matched on the label by the fuzzy matcher
                    for _, idx in ipairs(ctx.label_matched_indices) do
                        table.insert(
                            highlights, {
                                idx,
                                idx + 1,
                                group = "BlinkCmpLabelMatch",
                            }
                        )
                    end

                    return highlights
                end,
            },

            label_description = {
                width = {
                    max = 30,
                },
                text = function(ctx)
                    return ctx.label_description
                end,
                highlight = "BlinkCmpLabelDescription",
            },
        },
    },
}

opts.completion.documentation = {
    --- Controls whether the documentation window will automatically show when selecting a completion item
    auto_show = true,
    --- Delay before showing the documentation window
    auto_show_delay_ms = 500,
    --- Delay before updating the documentation window when selecting a new item,
    --- while an existing item is still visible
    update_delay_ms = 50,
    --- Whether to use treesitter highlighting, disable if you run into performance issues
    treesitter_highlighting = true,
    window = {
        min_width = 10,
        max_width = 60,
        max_height = 20,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        --- Note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        --- Which directions to show the documentation window,
        --- for each of the possible menu window directions,
        --- falling back to the next direction when there's not enough space
        direction_priority = {
            menu_north = {
                "e",
                "w",
                "n",
                "s",
            },
            menu_south = {
                "e",
                "w",
                "s",
                "n",
            },
        },
    },
}
--- Displays a preview of the selected item on the current line
opts.completion.ghost_text = {
    enabled = false,
}

--- Experimental signature help support
opts.signature = {
    enabled = true,
    trigger = {
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        --- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
    },
    window = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        scrollbar = false, --- Note that the gutter will be disabled when border ~= 'none'
        --- Which directions to show the window,
        --- falling back to the next direction when there's not enough space,
        --- or another window is in the way
        direction_priority = {
            "n",
            "s",
        },
        --- Disable if you run into performance issues
        treesitter_highlighting = true,
    },
}

opts.fuzzy = {
    --- when enabled, allows for a number of typos relative to the length of the query
    --- disabling this matches the behavior of fzf
    use_typo_resistance = true,
    --- frencency tracks the most recently/frequently used items and boosts the score of the item
    use_frecency = true,
    --- proximity bonus boosts the score of items matching nearby words
    use_proximity = true,
    --- controls which sorts to use and in which order, these three are currently the only allowed options
    sorts = {
        "score",
        "label",
        "kind",
    },

    prebuilt_binaries = {
        --- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`
        --- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
        download = true,
        --- When downloading a prebuilt binary, force the downloader to resolve this version. If this is unset
        --- then the downloader will attempt to infer the version from the checked out git tag (if any).
        --
        --- Beware that if the FFI ABI changes while tracking main then this may result in blink breaking.
        force_version = nil,
        --- When downloading a prebuilt binary, force the downloader to use this system triple. If this is unset
        --- then the downloader will attempt to infer the system triple from `jit.os` and `jit.arch`.
        --- Check the latest release for all available system triples
        --
        --- Beware that if the FFI ABI changes while tracking main then this may result in blink breaking.
        force_system_triple = nil,
    },
}

opts.appearance = {
    highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
    --- Sets the fallback highlight groups to nvim-cmp's highlight groups
    --- Useful for when your theme doesn't support blink.cmp
    --- Will be removed in a future release
    use_nvim_cmp_as_default = false,
    --- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    --- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
    kind_icons = {
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
    },
}
