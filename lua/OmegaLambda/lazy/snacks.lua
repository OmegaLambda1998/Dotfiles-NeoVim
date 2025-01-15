---
--- === Snacks ===
---
local spec, opts = OL.spec:add("folke/snacks.nvim")
spec.priority = 1000
spec.cond = true
spec.lazy = false
local enabled = not OL.is_pager()
OL.callbacks.colourscheme.snacks = true

local config = {}

---
--- --- Animate ---
---

opts.animate = {
    enabled = enabled,
}

---
--- --- Big Files ---
---

OL.is_bigfile = false
OL.callbacks.bigfile = OL.OLCall.new(
    {
        function(ctx)
            OL.is_bigfile = true
            OL.log:trace(ctx)
            OL.log:flush()
        end,
    }
)

opts.bigfile = OL.OLConfig.new(
    {
        enabled = enabled,
        notify = true, --- Show notification when bigfile detected
        size = 1.5 * 1024 * 1024, --- 1.5MB
        setup = OL.callbacks.bigfile,
    }
)

---
--- --- Dashboard ---
---
opts.dashboard = {
    enabled = enabled,
    width = math.floor(2 * vim.api.nvim_win_get_width(0) / 3),
}

local sections = {}
function sections:add(tbl)
    if type(tbl) == "string" then
        tbl = {
            section = tbl,
        }
    end
    tbl = vim.tbl_extend(
        "force", {
            width = function()
                return math.floor(2 * vim.api.nvim_win_get_width(0) / 3)
            end,
        }, tbl
    )
    table.insert(self, tbl)
end

sections:add(
    {
        function()
            local job = OL.load("plenary.job")
            local path = OL.load("plenary.path")

            --- Get Font
            local fonts = path:new(OL.paths.lazy:abs("figlet")):readlines()
            math.randomseed(os.time())
            local font = fonts[math.random(#fonts)]
            OL.font = font

            local cwd = OL.get_roots().cwd

            local header, _ = job:new(
                {
                    command = "figlet",
                    args = {
                        "-f",
                        font,
                        "-l",
                        "-L",
                        "/" .. vim.fs.basename(cwd),
                    },
                    enable_recording = true,
                }
            ):sync()
            table.insert(header, font)
            while #header < 6 do
                table.insert(header, "")
            end
            return {

                header = table.concat(header, "\n"),
                padding = 1,
            }
        end,
    }
)

sections:add(
    {
        section = "startup",
    }
)

sections:add(
    {
        section = "keys",
        title = "Keys",
        padding = 1,
    }
)

sections:add(
    {
        function()
            local in_git = OL.load(
                "snacks", {}, function(snack)
                    return snack.git.get_root() ~= nil
                end
            )
            local in_session = OL.load(
                "persistence", {}, function(session)
                    return vim.tbl_contains(session.list(), session.current())
                end
            )
            local cmds = {
                {
                    section = "recent_files",
                    title = "Recent Project Files",
                    padding = 1,
                    enabled = (in_git or in_session),
                    cwd = true,
                },
                {
                    section = "projects",
                    title = "Recent Projects",
                    enabled = true,
                    padding = 1,
                    action = function(dir)
                        vim.fn.chdir(dir)
                    end,
                },
                {
                    section = "recent_files",
                    title = "Recent Files",
                    enabled = not (in_git or in_session),
                    padding = 1,
                },
                {
                    title = "Issues",
                    cmd = "GH_PAGER= gh issue list -L 3",
                    height = 5,
                    enabled = in_git,
                },
                {
                    title = "Pull Requests",
                    cmd = "GH_PAGER= gh pr list -L 3",
                    height = 5,
                    enabled = in_git,
                },
                {
                    title = "Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    enabled = in_git,
                },
            }
            return vim.tbl_map(
                function(cmd)
                    return vim.tbl_extend(
                        "force", {
                            section = "terminal",
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd
                    )
                end, cmds
            )
        end,
    }
)

opts.dashboard.sections = sections

table.insert(
    config, function(_)
        OL.aucmd(
            "cwd", {
                {
                    "DirChanged",
                },
                function()
                    OL.load(
                        "snacks", {}, function(snacks)
                            snacks.dashboard.update()
                        end
                    )
                end,
            }
        )
    end
)

---
--- --- Debug ---
---

---
--- --- Dim ---
---

opts.dim = {
    enabled = enabled,
    scope = {
        min_size = 1,
        max_size = 20,
        siblings = true,
    },
    animate = {
        enabled = opts.animate.enabled,
        easing = "outQuad",
        duration = {
            step = 5, -- ms per step
            total = 100, -- maximum duration
        },
    },
    -- what buffers to dim
    filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and
                   vim.bo[buf].buftype == ""
    end,
}

---
--- --- Git ---
---

---
--- --- Git Browse ---
---

---
--- --- Indent
---
opts.indent = {
    enabled = enabled,
}
opts.indent.indent = {
    enabled = opts.indent.enabled,
    priority = 200,
    char = ".",
    blank = nil,
    only_scope = false, -- only show indent guides of the scope
    only_current = false, -- only show indent guides in the current window
    hl = {
        "SnacksIndent1",
        "SnacksIndent2",
        "SnacksIndent3",
        "SnacksIndent4",
        "SnacksIndent5",
        "SnacksIndent6",
        "SnacksIndent7",
        "SnacksIndent8",
    },
}
opts.indent.animate = {
    enabled = opts.animate.enabled and opts.indent.enabled,
    style = "out",
    easing = "linear",
    duration = {
        step = 10, -- ms per step
        total = 500, -- maximum duration
    },
}
opts.indent.scope = {
    enabled = opts.indent.enabled,
    priority = opts.indent.indent.priority,
    char = "",
    underline = true, -- underline the start of the scope
    only_scope = opts.indent.indent.only_scope,
    only_current = opts.indent.indent.only_current,
    hl = opts.indent.indent.hl,
}
opts.indent.chunk = {
    -- when enabled, scopes will be rendered as chunks, except for the
    -- top-level scope which will be rendered as a scope.
    enabled = opts.indent.enabled,
    -- only show chunk scopes in the current window
    only_scope = opts.indent.indent.only_scope,
    only_current = opts.indent.indent.only_current,
    priority = opts.indent.indent.priority,
    hl = opts.indent.indent.hl,

    char = {
        --- corner_top = "┌",
        --- corner_bottom = "└",
        corner_top = "╭",
        corner_bottom = "╰",
        horizontal = "─",
        vertical = "│",
        arrow = "─",
    },
}
opts.indent.blank = {
    char = " ",
    hl = "SnacksIndentBlank",
}
opts.indent.filter = function(buf)
    return
        vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and
            vim.bo[buf].buftype == ""
end

---
--- --- Input ---
---

opts.input = {
    enabled = true,
}
--- table.insert(
---     config, function(o)
---         OL.load(
---             "snacks", {}, function(snacks)
---                 vim.ui.input = snacks.input
---             end
---         )
---     end
--- )

---
--- --- Lazy Git ---
---

---
--- --- Notifier ---
---

OL.callbacks.colourscheme.notifier = true

opts.notifier = {
    style = "fancy",
}

table.insert(
    config, function(o)
        if not OL.is_pager() then
            OL.aucmd(
                "LspProgress", {
                    {
                        "LspProgress",
                        function(ev)
                            local progress = vim.defaulttable()
                            local client = vim.lsp
                                               .get_client_by_id(
                                ev.data.client_id
                            )
                            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
                            if not client or type(value) ~= "table" then
                                return
                            end
                            local p = progress[client.id]

                            for i = 1, #p + 1 do
                                if i == #p + 1 or p[i].token ==
                                    ev.data.params.token then
                                    p[i] = {
                                        token = ev.data.params.token,
                                        msg = ("[%3d%%] %s%s"):format(
                                            value.kind == "end" and 100 or
                                                value.percentage or 100,
                                                value.title or "",
                                                value.message and
                                                    (" **%s**"):format(
                                                        value.message
                                                    ) or ""
                                        ),
                                        done = value.kind == "end",
                                    }
                                    break
                                end
                            end

                            local msg = {} ---@type string[]
                            progress[client.id] = vim.tbl_filter(
                                function(v)
                                    return table.insert(msg, v.msg) or
                                               not v.done
                                end, p
                            )

                            local spinner = {
                                "⠋",
                                "⠙",
                                "⠹",
                                "⠸",
                                "⠼",
                                "⠴",
                                "⠦",
                                "⠧",
                                "⠇",
                                "⠏",
                            }
                            vim.notify(
                                table.concat(msg, "\n"), OL.log.INFO, {
                                    id = "lsp_progress",
                                    title = client.name,
                                    opts = function(notif)
                                        notif.icon = #progress[client.id] == 0 and
                                                         " " or
                                                         spinner[math.floor(
                                                vim.uv.hrtime() / (1e6 * 80)
                                            ) % #spinner + 1]
                                    end,
                                }
                            )
                        end,
                    },
                }
            )
        end
    end
)

---
--- --- Notify ---
---

OL.callbacks.colourscheme.notify = true

table.insert(
    config, function(o)
        OL.load(
            "snacks", {}, function(snacks)
                OL.notify = function(msg, msg_opts)
                    if msg_opts == nil then
                        msg_opts = {}
                    end
                    if msg_opts.title == nil then
                        msg_opts.title = "OmegaLambda"
                    end
                    if msg_opts.level == nil then
                        msg_opts.level = OL.log.INFO
                    end
                    snacks.notify(msg, o)
                end

                --- Overwrite commands
                vim.print = function(...)
                    snacks.debug.inspect(...)
                end
                print = function(...)
                    vim.print(...)
                end
            end
        )
    end
)

---
--- --- Profiler ---
---

function OL.toggle_profile()
    OL.load(
        "snacks.profiler", {}, function(prof)
            if prof.running() then
                prof.stop()
            else
                prof.start()
            end
        end
    )
end

opts.profiler = {
    enabled = enabled,
}

spec.keys = {
    {
        "<leader>po",
        function()
            OL.load(
                "snacks.profiler", {}, function(prof)
                    prof.scratch()
                end
            )
        end,
        desc = "Profiler Scratch Buffer",
    },
}

OL.map(
    {
        "<leader>p",
        group = "Profiler",
        desc = "Profiler",
        spec.keys,
    }
)

table.insert(
    config, function(o)
        if OL.should_profile then
            OL.load(
                "snacks.profiler", {}, function(profile)
                    if OL.should_profile:lower():match("^start") then
                        profile.startup()
                    else
                        profile.start()
                    end
                end
            )
        end

    end
)

---
--- --- Quick File ---
---

opts.quickfile = {
    enabled = true,
}

---
--- --- Rename ---
---

opts.rename = {
    enabled = false,
}

---
--- --- Scope ---
---

opts.scope = {
    enabled = enabled,
    -- absolute minimum size of the scope.
    -- can be less if the scope is a top-level single line scope
    min_size = 2,
    -- try to expand the scope to this size
    max_size = nil,
    cursor = true, -- when true, the column of the cursor is used to determine the scope
    edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
    siblings = false, -- expand single line scopes with single line siblings
    -- what buffers to attach to
    filter = function(buf)
        return vim.bo[buf].buftype == ""
    end,
    -- debounce scope detection in ms
    debounce = 30,
    treesitter = {
        -- detect scope based on treesitter.
        -- falls back to indent based detection if not available
        enabled = true,
        ---@type string[]|{enabled?:boolean}
        blocks = {
            enabled = true, -- enable to use the following blocks
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
        },
        -- these treesitter fields will be considered as blocks
        field_blocks = {
            "local_declaration",
        },
    },
    -- These keymaps will only be set if the `scope` plugin is enabled.
    -- Alternatively, you can set them manually in your config,
    -- using the `Snacks.scope.textobject` and `Snacks.scope.jump` functions.
    keys = {
        ---@type table<string, snacks.scope.TextObject|{desc?:string}>
        textobject = {
            ii = {
                min_size = 2, -- minimum size of the scope
                edge = false, -- inner scope
                cursor = false,
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "inner scope",
            },
            ai = {
                cursor = false,
                min_size = 2, -- minimum size of the scope
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "full scope",
            },
        },
        ---@type table<string, snacks.scope.Jump|{desc?:string}>
        jump = {
            ["[["] = {
                min_size = 1, -- allow single line scopes
                bottom = false,
                cursor = false,
                edge = true,
                treesitter = {
                    blocks = {
                        enabled = true,
                    },
                },
                desc = "jump to top edge of scope",
            },
            ["]]"] = {
                min_size = 1, -- allow single line scopes
                bottom = true,
                cursor = false,
                edge = true,
                treesitter = {
                    blocks = {
                        enabled = true,
                    },
                },
                desc = "jump to bottom edge of scope",
            },
        },
    },
}

---
--- --- Scroll ---
---

opts.scroll = {
    enabled = true,
    animate = {
        duration = {
            step = 5,
            total = 100,
        },
        easing = "linear",
    },
    spamming = 10, -- threshold for spamming detection
    -- what buffers to animate
    filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~=
                   false and vim.bo[buf].buftype ~= "terminal"
    end,
}

---
--- --- Status Column ---
---

OL.opt("number")
OL.opt("relativenumber")
OL.opt("signcolumn", "yes:3")
OL.opt("statuscolumn", [[%!v:lua.require'snacks.statuscolumn'.get()]])
opts.statuscolumn = {
    enabled = not OL.is_pager(),
    left = { "sign" },
    right = {
        "fold",
        "git",
    },
    folds = {
        open = true,
        git_hl = true,
    },
    git = {
        patterns = {
            "GitSign",
        },
    },
    refresh = 50,
}

---
--- --- Terminal ---
---
OL.map(
    {
        "<leader>t",
        group = "Toggle",
        desc = "Toggle",
        mode = { "n" },
        {
            {
                "<leader>tt",
                function()
                    OL.load(
                        "snacks", {}, function(snacks)
                            snacks.terminal()
                        end

                    )
                end,
                desc = "Toggle Terminal",
            },
        },
    }
)

---
--- --- Toggle ---
---
opts.toggle = {
    map = function(mode, lhs, rhs, opts)
        OL.map(
            {
                lhs,
                rhs,
                mode = mode,
                OL.unpack(opts),
            }
        )
    end,
    which_key = true,
    notify = true,
    --- icons for enabled/disabled states
    icon = {
        enabled = " ",
        disabled = " ",
    },
    --- colors for enabled/disabled states
    color = {
        enabled = "green",
        disabled = "yellow",
    },
}
table.insert(
    config, function(_)
        local toggles = {
            animate = "<leader>ta",
            dim = "<leader>td",
            indent = "<leader>ti",
            profiler = "<leader>pp",
            profiler_highlights = "<leader>ph",
            scroll = "<leader>ts",
            words = "<leader>tw",
        }
        OL.load(
            "snacks.toggle", {}, function(toggle)
                for cmd, map in pairs(toggles) do
                    toggle[cmd]():map(map)
                end
            end
        )
    end
)

---
--- --- Words ---
---

opts.words = {
    enabled = false,
}

---
--- --- Zen ---
---

opts.zen = {
    enabled = false,
}

function spec.config(_, o)
    OL.load_setup("snacks", {}, o)
    for _, fn in ipairs(config) do
        fn(o)
    end
end

