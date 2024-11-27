---
--- === NeoVim ===
---
---
--- --- Auto Commands ---
---
function OL.augroup(name, opts)
    if opts == nil or opts.clear == nil then
        opts = {
            clear = true,
        }
    end
    name = "OL" .. name:gsub("^%l", string.upper)
    return vim.api.nvim_create_augroup(name, opts)
end

function OL.autocmd(events, callback, opts)
    if type(events) == "string" then
        events = {
            events,
        }
    end
    events = OL.flatten(events)

    if opts == nil then
        opts = {}
    end
    if opts.group == nil then
        opts.group = "autocmd"
    end
    if type(opts.group) == "string" then
        opts.group = OL.augroup(opts.group)
    end

    opts.callback = callback

    vim.api.nvim_create_autocmd(events, opts)
end

OL.callbacks.autocommands = OL.OLCall.new()
OL.callbacks.post:add(
    function()
        OL.callbacks.autocommands()
    end
)
function OL.aucmd(name, ...)
    local cmds = OL.pack(...)
    for _, cmd in ipairs(cmds) do
        if not OL.is_array(cmd) then
            cmds = {
                cmds,
            }
            break
        end
    end
    local events, callback, opts
    for _, cmd in ipairs(cmds) do
        events = cmd["events"] or cmd[1]
        callback = cmd["callback"] or cmd[2]
        opts = {}
        for k, v in pairs(cmd) do
            if not vim.tbl_contains(
                {
                    "events",
                    "callback",
                    1,
                    2,
                }, k
            ) then
                opts[k] = v
            end
        end
        if opts.group == nil then
            opts.group = OL.augroup(name)
        end
        if not OL.callbacks.post.triggered then
            OL.callbacks.autocommands:add(
                function()
                    OL.autocmd(events, callback, opts)
                end
            )
        else
            OL.autocmd(events, callback, opts)
        end
    end
end

---@class OLEvent: OLConfig
OL.events = OL.OLConfig.new()
function OL.events.trigger(event)
    OL.log:debug("Triggering %s", event)
    vim.api.nvim_exec_autocmds(
        "User", {
            pattern = event,
        }
    )
end

OL.events.callback_pre = "OLCallbackPre"
OL.callbacks.pre.event = OL.events.callback_pre
OL.events.callback_post = "OLCallbackPost"
OL.callbacks.post.event = OL.events.callback_post

---
--- --- User Commands ---
---

function OL.usrcmd(name, fn, ...)
    local args = OL.pack(...)
    name = name:gsub("^%l", string.upper)
    if type(fn) == "string" then
        fn = function()
            vim.cmd(fn)
        end
    end
    vim.api.nvim_create_user_command(name, fn, args)
end

---
--- --- Keymaps ---
---

function OL.map(...)
    local args = OL.pack(...)
    if not OL.callbacks.post.triggered then
        OL.callbacks.post:add(
            function()
                OL.load(
                    "which-key", {}, function(wk)
                        wk.add(OL.unpack(args))
                    end
                )
            end
        )
    else
        OL.load(
            "which-key", {}, function(wk)
                wk.add(OL.unpack(args))
            end
        )
    end
end

OL.map(
    {
        "<leader>o",
        group = "OLUtils",
        desc = "OLUtils",
        {
            {
                "<leader>ou",
                function()
                    OL.callbacks.update()
                end,
                desc = "Update",
            },
            {
                "<leader>ol",
                function()
                    OL.log:flush()
                    OL.load(
                        "snacks", {}, function(snacks)
                            snacks.notifier.show_history()
                        end
                    )
                end,
                desc = "Log History",
            },
            {
                "<leader>ov",
                function()
                    OL.log:flush(true)
                    OL.load(
                        "snacks", {}, function(snacks)
                            snacks.notifier.show_history()
                        end
                    )
                end,
                desc = "Verbose Log History",
            },

        },
    }
)

---
--- --- Settings ---
---

function OL.opt(key, val, opts)
    if val == nil then
        val = true
    end
    if opts == nil then
        opts = {}
    end
    local set = vim.opt
    if opts.gopt then
        set = vim.opt_global
    elseif opts.lopt then
        set = vim.opt_local
    elseif opts.g then
        set = vim.g
    end
    if not OL.callbacks.post.triggered and not opts.force then
        OL.callbacks.post:add(
            function()
                set[key] = val
            end
        )
    else
        set[key] = val
    end
end

function OL.gopt(key, val, opts)
    opts = opts or {}
    opts.gopt = true
    OL.opt(key, val, opts)
end

function OL.lopt(key, val, opts)
    opts = opts or {}
    opts.lopt = true
    OL.opt(key, val, opts)
end

function OL.g(key, val, opts)
    opts = opts or {}
    opts.g = true
    OL.opt(key, val, opts)
end
