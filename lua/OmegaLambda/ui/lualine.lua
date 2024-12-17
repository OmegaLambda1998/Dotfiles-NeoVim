local spec, opts = OL.spec:add("nvim-lualine/lualine.nvim")
spec.event = "VeryLazy"
spec.dependencies = {
    "meuter/lualine-so-fancy.nvim",
    "dokwork/lualine-ex",
}

opts.options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = {
        left = "",
        right = "",
    },
    section_separators = {
        left = "",
        right = "",
    },
    disabled_filetypes = {
        statusline = {
            "snacks_dashboard",
        },
        winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
    },
}
opts.sections = {
    lualine_a = {
        "fancy_mode",
    },
    lualine_b = {
        "ex.git.branch",
    },
    lualine_c = {
        { "ex.cwd" },
    },
    lualine_x = {
        {
            "fancy_macro",
        },
        {
            "fancy_searchcount",
        },
        {
            "fancy_diagnostics",
        },
        {
            "fancy_diff",
            source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end,
        },
    },
    lualine_y = {
        {
            "ex.lsp.all",
            only_attached = true,
        },
        {
            "fancy_filetype",
        },
    },
    lualine_z = {
        {
            "ex.location",
            padding = {
                left = 0,
                right = 1,
            },
        },
    },
}
opts.inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
        "filename",
    },
    lualine_x = {
        "location",
    },
    lualine_y = {},
    lualine_z = {},
}
opts.tabline = {}
opts.winbar = {}
opts.inactive_winbar = {}
opts.extensions = {
    "fzf",
    "lazy",
    "man",
    "mason",
    "oil",
}

spec.init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
    else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
    end
end

function spec.config(_, o)
    table.insert(o.sections.lualine_x, OL.load("snacks.profiler").status())
    OL.load(
        "lualine_require", {}, function(lr)
            lr.require = OL.load
        end
    )
    vim.o.laststatus = vim.g.lualine_laststatus
    OL.load_setup("lualine", {}, o)

    -- initial setting
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 3

    local cmd_status = vim.api.nvim_create_augroup(
        "CmdlineStatus", {
            clear = true,
        }
    )

    -- Set up a custom User event
    -- Capture keys that enter Command-line mode
    -- "CmdlineEnter" event doesn't happen until after these keys are pressed, which isn't fast enough
    -- to counteract the cmdline scroll shift
    for _, char in pairs {
        ":",
        "/",
        "?",
        "!",
    } do
        vim.keymap.set(
            "", char, function()
                vim.fn.feedkeys(char, "n") -- 'n': do not remap keys, any other option locks up Vim
                vim.api.nvim_exec_autocmds(
                    "User", {
                        pattern = "CmdlineEnterPre",
                        group = "CmdlineStatus",
                    }
                )
            end
        )
    end

    vim.api.nvim_create_autocmd(
        {
            "CmdlineLeave",
        }, {
            group = "CmdlineStatus",
            callback = function()
                vim.api.nvim_exec_autocmds(
                    "User", {
                        pattern = "CmdlineLeavePost",
                        group = "CmdlineStatus",
                    }
                )
            end,
        }
    )

    -- Toggle between the statusline and cmdline based on the custom events
    vim.api.nvim_create_autocmd(
        "User", {
            group = "CmdlineStatus",
            pattern = {
                "CmdlineEnterPre",
                "CmdlineLeavePost",
            },
            callback = function(ctx)
                local fillchar = vim.opt.fillchars:get().horiz or "─"
                if ctx.match == "CmdlineEnterPre" then
                    vim.opt.cmdheight = 1
                    vim.opt.laststatus = 0
                    -- make last statusline look like a window separator if there are splits
                    vim.opt.statusline = "%#WinSeparator#" ..
                                             string.rep(
                            fillchar, vim.fn.winwidth "."
                        )
                else
                    vim.opt.cmdheight = 0
                    vim.opt.laststatus = 3
                    -- reset your statusline
                    vim.opt.statusline = ""
                end
            end,
        }
    )

end

