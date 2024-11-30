---
--- === Snacks ===
---
local spec, opts = OL.spec:add("folke/snacks.nvim")
spec.priority = 1000
spec.cond = true
spec.lazy = false

OL.callbacks.colourscheme.snacks = true

local config = {}

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
        enabled = not OL.is_pager(),
        notify = true, --- Show notification when bigfile detected
        size = 1.5 * 1024 * 1024, --- 1.5MB
        setup = OL.callbacks.bigfile,
    }
)

---
--- --- Dashboard ---
---
opts.dashboard = {
    enabled = not OL.is_pager(),
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
--- --- Git ---
---

---
--- --- Git Browse ---
---

---
--- --- Lazy Git ---
---

---
--- --- Notify ---
---

OL.callbacks.colourscheme.notify = true

table.insert(
    config, function(o)
        OL.load(
            "snacks", {}, function(snacks)
                snacks.setup(o)

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
                    OL.notify(
                        ..., {
                            level = OL.log.DEBUG,
                        }
                    )
                end
                local original_error = error
                error = function(...)
                    if ... ~= "Entry 0 missing parent url" then
                        pcall(snacks.notify.error(...))
                        if OL.verbose then
                            snacks.debug.backtrace()
                        end
                    else
                        original_error(...)
                    end
                end
            end
        )
    end
)

---
--- --- Notifier ---
---

OL.callbacks.colourscheme.notifier = true

opts.notifier = {
    style = "compact",
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
--- --- Quick File ---
---

opts.quickfile = {
    exclude = OL.callbacks.treesitter.exclude,
}

---
--- --- Rename ---
---

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
table.insert(
    config, function(o)
        if o.statuscolumn.enabled then
            OL.load("gitsigns")
        end
    end
)

---
--- --- Terminal ---
---
OL.map(
    {
        "<leader>t",
        group = "Terminal",
        desc = "Terminal",
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
    map = vim.keymap.set,
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

---
--- --- Windows ---
---

---
--- --- Words ---
---

opts.words = {
    enabled = false, -- enable/disable the plugin
    debounce = 200, -- time in ms to wait before updating
    notify_jump = true, -- show a notification when jumping
    notify_end = true, -- show a notification when reaching the end
    foldopen = true, -- open folds after jumping
    jumplist = true, -- set jump point before jumping
    modes = {
        "n",
        "i",
        "c",
    }, -- modes to show references
}

---
--- --- Styles ---
---

function spec.config(_, o)
    for _, fn in ipairs(config) do
        fn(o)
    end
end

