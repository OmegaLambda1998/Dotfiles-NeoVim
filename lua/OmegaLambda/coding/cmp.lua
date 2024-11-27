local fspec, fopts = OL.spec:add("rafamadriz/friendly-snippets")
function fspec.config()
end


local spec, opts = OL.spec:add("Saghen/blink.cmp")

spec.dependencies = {
    "rafamadriz/friendly-snippets",
}

OL.paths.coding:append("snippets")

OL.callbacks.colourscheme.blink_cmp = true

spec.version = false
spec.build = "cargo build --release"

OL.callbacks.cmp = OL.OLConfig.new()
OL.callbacks.cmp.ft = OL.OLConfig.new()
function OL.callbacks.cmp.ft:add(ft)
    table.insert(self, "InsertEnter *." .. ft)
end


spec.event = OL.callbacks.cmp.ft

opts.accept = {
    create_undo_point = true,
    -- Function used to expand snippets, some possible values:
    -- require('luasnip').lsp_expand     -- For `luasnip` users.
    -- require('snippy').expand_snippet  -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"]          -- For `ultisnips` users.
    expand_snippet = vim.snippet.expand,

    auto_brackets = {
        enabled = false,
        default_brackets = {
            "(",
            ")",
        },
        override_brackets_for_filetypes = {},
        -- Overrides the default blocked filetypes
        force_allow_filetypes = {},
        blocked_filetypes = {},
        -- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
            enabled = true,
            blocked_filetypes = {
                "typescriptreact",
                "javascriptreact",
                "vue",
            },
        },
        -- Asynchronously use semantic token to determine if brackets should be added
        semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = {},
            -- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 400,
        },
    },
}

opts.trigger = {
    completion = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword_range = "full",
        -- regex used to get the text when fuzzy matching
        -- changing this may break some sources, so please report if you run into issues
        -- TODO: shouldnt this also affect the accept command? should this also be per language?
        keyword_regex = "[%w_\\-]",
        -- after matching with keyword_regex, any characters matching this regex at the prefix will be excluded
        exclude_from_prefix_regex = "[\\-]",
        -- LSPs can indicate when to show the completion window via trigger characters
        -- however, some LSPs (i.e. tsserver) return characters that would essentially
        -- always show the window. We block these by default
        blocked_trigger_characters = {
            " ",
            "\n",
            "\t",
        },
        -- when true, will show the completion window when the cursor comes after a trigger character after accepting an item
        show_on_accept_on_trigger_character = true,
        -- when true, will show the completion window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
        -- list of additional trigger characters that won't trigger the completion window when the cursor comes after a trigger character when entering insert mode/accepting an item
        show_on_x_blocked_trigger_characters = {
            "'",
            "\"",
            "(",
        },
        -- when false, will not show the completion window automatically when in a snippet
        show_in_snippet = true,
    },

    signature_help = {
        enabled = true,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        -- when true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
    },
}

opts.fuzzy = {
    -- when enabled, allows for a number of typos relative to the length of the query
    -- disabling this matches the behavior of fzf
    use_typo_resistance = true,
    -- frencency tracks the most recently/frequently used items and boosts the score of the item
    use_frecency = true,
    -- proximity bonus boosts the score of items matching nearby words
    use_proximity = true,
    max_items = 200,
    -- controls which sorts to use and in which order, these three are currently the only allowed options
    sorts = {
        "label",
        "kind",
        "score",
    },

    prebuilt_binaries = {
        -- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`
        -- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
        download = true,
        -- When downloading a prebuilt binary, force the downloader to resolve this version. If this is unset
        -- then the downloader will attempt to infer the version from the checked out git tag (if any).
        --
        -- Beware that if the FFI ABI changes while tracking main then this may result in blink breaking.
        force_version = nil,
        -- When downloading a prebuilt binary, force the downloader to use this system triple. If this is unset
        -- then the downloader will attempt to infer the system triple from `jit.os` and `jit.arch`.
        -- Check the latest release for all available system triples
        --
        -- Beware that if the FFI ABI changes while tracking main then this may result in blink breaking.
        force_system_triple = nil,
    },
}

OL.callbacks.cmp.sources = OL.OLConfig.new()
function OL.callbacks.cmp:add_source(source)
    table.insert(OL.callbacks.cmp.sources, source)
end


function OL.callbacks.cmp:add_compat(source)
end


OL.callbacks.cmp.providers = OL.OLConfig.new()

function OL.callbacks.cmp:update_provider(provider, o)
    if OL.callbacks.cmp.providers[provider] == nil then
        OL.callbacks.cmp:add_provider(provider)
    end
    OL.callbacks.cmp.providers[provider] =
        vim.tbl_deep_extend(
            "force", OL.callbacks.cmp.providers[provider], o
        )
end


function OL.callbacks.cmp:add_provider(provider, o)
    local default_opts = {
        name = provider,
        enabled = true,
        transform_items = nil,
        should_show_items = true,
        max_items = nil,
        min_keyword_length = 0,
        fallback_for = {},
        score_offset = 0,
        override = nil,
    }
    o = vim.tbl_deep_extend("force", default_opts, o or {})
    if o.fallback ~= nil then
        if type(o.fallback) ~= table then
            o.fallback = {
                o.fallback,
            }
        end
        for _, fallback in ipairs(o.fallback) do
            OL.callbacks.cmp:update_provider(
                fallback, {
                    fallback_for = {
                        provider,
                    },
                }
            )
        end
    end
    if o.disable ~= nil then
        if type(o.disable) ~= table then
            o.disable = {
                [o.disable] = false,
            }
        end
        for source, disable in pairs(o.disable) do
            OL.callbacks.cmp:update_provider(
                source, {
                    enabled = disable,
                }
            )
        end
    end
    OL.callbacks.cmp.providers[provider] = o
end


function OL.callbacks.cmp:add(source, o)
    OL.callbacks.cmp:add_source(source)
    OL.callbacks.cmp:add_provider(source, o)
end


OL.callbacks.cmp:add(
    "lsp", {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
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
            get_cwd = function(ctx)
                return vim.fn.expand(("#%d:p:h"):format(ctx.bufnr))
            end
,
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
        },
    }
)

OL.callbacks.cmp:add(
    "buffer", {
        name = "Buffer",
        module = "blink.cmp.sources.buffer",
        score_offset = -10,
    }
)

opts.sources = {
    completion = {
        enabled_providers = OL.callbacks.cmp.sources,
    },

    -- Please see https://github.com/Saghen/blink.compat for using `nvim-cmp` sources
    providers = OL.callbacks.cmp.providers,
}

opts.windows = {
    autocomplete = {
        min_width = 15,
        max_height = 10,
        border = "none",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        -- keep the cursor X lines away from the top/bottom of the window
        scrolloff = 2,
        -- note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        -- which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = {
            "s",
            "n",
        },
        -- Controls whether the completion window will automatically show when typing
        auto_show = true,
        -- Controls how the completion items are selected
        -- 'preselect' will automatically select the first item in the completion list
        -- 'manual' will not select any item by default
        -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
        selection = "manual",
        -- Controls how the completion items are rendered on the popup window
        draw = {
            align_to_component = "label", -- or 'none' to disable
            -- Left and right padding, optionally { left, right } for different padding on each side
            padding = 1,
            -- Gap between columns
            gap = 1,

            -- Components to render, grouped by column
            columns = {
                {
                    "kind_icon",
                },
                {
                    "label",
                    "label_description",
                    gap = 1,
                },
            },
            -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },

            -- Definitions for possible components to render. Each component defines:
            --   ellipsis: whether to add an ellipsis when truncating the text
            --   width: control the min, max and fill behavior of the component
            --   text function: will be called for each item
            --   highlight function: will be called only when the line appears on screen
            components = {
                kind_icon = {
                    ellipsis = false,
                    text = function(ctx)
                        return ctx.kind_icon .. ctx.icon_gap
                    end
,
                    highlight = function(ctx)
                        return OL.load(
                            "blink.cmp.utils", {}, function(utils)
                                return utils.get_tailwind_hl(ctx) or
                                           ("BlinkCmpKind" .. ctx.kind)
                            end


                        )
                    end
,
                },

                kind = {
                    ellipsis = false,
                    width = {
                        fill = true,
                    },
                    text = function(ctx)
                        return ctx.kind
                    end
,
                    highlight = function(ctx)
                        return OL.load(
                            "blink.cmp.utils", {}, function(utils)
                                return utils.get_tailwind_hl(ctx) or
                                           ("BlinkCmpKind" .. ctx.kind)
                            end


                        )
                    end
,
                },

                label = {
                    width = {
                        fill = true,
                        max = 60,
                    },
                    text = function(ctx)
                        return ctx.label .. ctx.label_detail
                    end
,
                    highlight = function(ctx)
                        -- label and label details
                        local highlights = {
                            {
                                0,
                                #ctx.label,
                                group = ctx.deprecated and
                                    "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
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

                        -- characters matched on the label by the fuzzy matcher
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
                    end
,
                },

                label_description = {
                    width = {
                        max = 30,
                    },
                    text = function(ctx)
                        return ctx.label_description
                    end
,
                    highlight = "BlinkCmpLabelDescription",
                },
            },
        },
        -- Controls the cycling behavior when reaching the beginning or end of the completion list.
        cycle = {
            -- When `true`, calling `select_next` at the *bottom* of the completion list will select the *first* completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the *top* of the completion list will select the *last* completion item.
            from_top = true,
        },
    },
    documentation = {
        min_width = 10,
        max_width = 60,
        max_height = 20,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        -- note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        -- which directions to show the documentation window,
        -- for each of the possible autocomplete window directions,
        -- falling back to the next direction when there's not enough space
        direction_priority = {
            autocomplete_north = {
                "e",
                "w",
                "n",
                "s",
            },
            autocomplete_south = {
                "e",
                "w",
                "s",
                "n",
            },
        },
        -- Controls whether the documentation window will automatically show when selecting a completion item
        auto_show = true,
        auto_show_delay_ms = 500,
        update_delay_ms = 50,
        -- whether to use treesitter highlighting, disable if you run into performance issues
        -- WARN: temporary, eventually blink will support regex highlighting
        treesitter_highlighting = false,
    },
    signature_help = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        -- note that the gutter will be disabled when border ~= 'none'
        scrollbar = false,

        -- which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = {
            "n",
            "s",
        },
        -- whether to use treesitter highlighting, disable if you run into performance issues
        -- WARN: temporary, eventually blink will support regex highlighting
        treesitter_highlighting = true,
    },
    ghost_text = {
        enabled = true,
    },
}

opts.highlight = {
    ns = vim.api.nvim_create_namespace("blink_cmp"),
    -- sets the fallback highlight groups to nvim-cmp's highlight groups
    -- useful for when your theme doesn't support blink.cmp
    -- will be removed in a future release, assuming themes add support
    use_nvim_cmp_as_default = false,
}

-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
-- adjusts spacing to ensure icons are aligned
opts.nerd_font_variant = "mono"

-- don't show completions or signature help for these filetypes. Keymaps are also disabled.
opts.blocked_filetypes = {}

opts.kind_icons = {
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
}

opts.keymap = {
    ["<CR>"] = {
        "accept",
        "fallback",
    },
    ["<Space>"] = {
        "accept",
        "fallback",
    },

    ["<S-Tab>"] = {
        function(cmp)
            if cmp.is_in_snippet() then
                return cmp.select_prev()
            end
        end
,
        "select_prev",
        "fallback",
    },
    ["<Tab>"] = {
        "select_next",
        function(cmp)
            if cmp.is_in_snippet() then
                return cmp.select_next()
            end
        end
,
        "fallback",
    },

    ["<Up>"] = {
        function(cmp)
            if cmp.is_in_snippet() then
                return cmp.select_prev()
            end
        end
,
        "select_prev",
        "fallback",
    },
    ["<C-Up>"] = {
        "scroll_documentation_up",
        "fallback",
    },

    ["<Down>"] = {
        function(cmp)
            if cmp.is_in_snippet() then
                return cmp.select_next()
            end
        end
,
        "select_next",
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

