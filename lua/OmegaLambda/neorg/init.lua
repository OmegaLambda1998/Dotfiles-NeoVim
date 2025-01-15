local spec, opts = OL.spec:add("nvim-neorg/neorg")

spec.ft = { "norg" }
spec.cmd = { "Neorg" }
spec.build = ":Neorg sync-parsers"
spec.dependencies = {
    {
        "3rd/image.nvim",
    },
    {
        "benlubas/neorg-interim-ls",
    },
    {
        "benlubas/neorg-query",
    },
    {
        "benlubas/neorg-se",
    },
}

opts.load = {}
spec.keys = {
    "<leader>n",
    group = "neorg",
    desc = "neorg",
}
table.insert(
    spec.keys, {
        "<leader>nn",
        function()
            if vim.bo.filetype ~= "norg" then
                vim.cmd(":Neorg index")
            else
                vim.cmd(":Neorg return")
            end
        end,
        desc = "Open / Return",
    }
)
OL.map(spec.keys)

---
--- === Config ===
---

local keys = {}

--- Defaults
opts.load["core.defaults"] = {}
vim.list_extend(
    keys, {
        {
            "<localleader>n",
            desc = "note",
        },
        {
            "<localleader>nn",
            "<Plug>(neorg.dirman.new-note)",
            desc = "new note",
        },
    }
)

--- Completion
opts.load["core.completion"] = {
    config = {
        engine = {
            module_name = "external.lsp-completion",
        },
    },
}

--- Concealer
opts.load["core.concealer"] = {
    config = {
        icon_preset = "varied",
    },
}

--- Dirman

opts.load["core.dirman"] = {
    config = {
        workspaces = {
            core = "~/Core",
        },
        index = "index.norg",
        use_popup = false,
    },
}

local function is_workspace(dir, index)
    local index_norg_path = dir .. "/" .. index
    return vim.uv.fs_stat(index_norg_path) ~= nil
end

local function get_workspaces(workspaces, index)
    local core = vim.fn.expand(workspaces.core)

    local function scan_dir(path)
        for _, entry in ipairs(vim.fn.readdir(path, [[v:val !~ '^\.\|\~$']])) do
            local full_path = path .. "/" .. entry
            if vim.uv.fs_stat(full_path).type == "directory" then
                if is_workspace(full_path, index) then
                    local name = vim.fn.fnamemodify(full_path, ":t"):lower()
                    workspaces[name] = full_path
                end
                scan_dir(full_path)
            end
        end
    end
    scan_dir(core)
    return workspaces
end

--- Hop
opts.load["core.esupports.hop"] = {
    config = {
        external_filetypes = {
            "pdf",
        },
    },
}
vim.list_extend(
    keys, {
        {
            "<CR>",
            "<Plug>(neorg.esupports.hop.hop-link)",
            desc = "Hop",
        },
        {
            "<C-CR>",
            "<Plug>(neorg.esupports.hop.hop-link.vsplit)",
            desc = "Hop",
        },
    }
)

--- Indent
opts.load["core.esupports.indent"] = {
    config = {
        format_on_enter = false,
        format_on_escape = true,
    },
}
vim.list_extend(
    keys, {
        {
            "<",
            "<Plug>(neorg.promo.demote.range)",
            desc = "Demote",
            mode = {
                "v",
            },
        },
        {
            "<<",
            "<Plug>(neorg.promo.demote.nested)",
            desc = "Demote Recursively",
        },
        {
            "<,",
            "<Plug>(neorg.promo.demote)",
            desc = "Demote",
        },
        {
            ">",
            "<Plug>(neorg.promo.promote.range)",
            desc = "Promote",
            mode = {
                "v",
            },
        },
        {
            ">>",
            "<Plug>(neorg.promo.promote.nested)",
            desc = "Promote Recursively",
        },
        {
            ">.",
            "<Plug>(neorg.promo.promote)",
            desc = "Promote",
        },
    }
)

--- Metagen
-- The default template found in the config for this module.
local default_template = {
    -- The title field generates a title for the file based on the filename.
    {
        "title",
        function()
            local title = vim.fn.expand("%:p:t:r")
            --- Get directory name if index file
            if title == "index" then
                title = vim.fn.expand("%:p:h:t")
            end
            --- Capitalise
            return title:gsub("^%l", string.upper)
        end,
    },
    -- The description field is always kept empty for the user to fill in.
    {
        "description",
        "",
    },
    -- The categories field is always kept empty for the user to fill in.
    {
        "categories",
        "[\n\n]",
    },
}

opts.load["core.esupports.metagen"] = {
    config = {
        template = default_template,
        type = "none",
        update_date = false,
    },
}
vim.list_extend(
    keys, {
        {
            "<localleader>i",
            desc = "insert",
        },
        {
            "<localleader>im",
            ":Neorg inject-metadata<CR>",
            desc = "insert meta",
        },
    }
)

--- Markdown Export
opts.load["core.export.markdown"] = {
    config = {
        extensions = "all",
    },
}

--- Keybind
opts.load["core.keybinds"] = {
    config = {
        default_keybinds = false,
    },
}

--- Journal
opts.load["core.journal"] = {
    config = {
        journal_folder = "Areas/Journal",
        strategy = "flat",
        workspace = "core",
    },
}

--- LaTeX
opts.load["core.latex.renderer"] = {
    config = {},
}

--- Looking glass
opts.load["core.looking-glass"] = {
    config = {},
}
vim.list_extend(
    keys, {
        {
            "<localleader>g",
            desc = "goto",
        },
        {
            "<localleader>gc",
            "<Plug>(neorg.looking-glass.magnify-code-block)",
            desc = "Looking Glass",
        },
    }
)

--- Pivot (lists)
vim.list_extend(
    keys, {
        {
            "<localleader>l",
            desc = "list",
        },
        {
            "<localleader>li",
            "<Plug>(neorg.pivot.list.invert)",
            desc = "list invert",
        },
        {
            "<localleader>lt",
            "<Plug>(neorg.pivot.list.toggle)",
            desc = "list toggle",
        },
    }
)

--- Table of Contents
vim.list_extend(
    keys, {
        {
            "<localleader>gt",
            ":Neorg toc<CR>",
            desc = "table of contents",
        },
    }
)

--- Tasks
opts.load["core.todo-introspector"] = {}
opts.load["core.qol.todo_items"] = {
    config = {
        order = {
            {
                "undone",
                " ",
            },
            {
                "pending",
                "-",
            },
            {
                "done",
                "x",
            },
        },
        order_with_children = {
            {
                "undone",
                " ",
            },
            {
                "pending",
                "-",
            },
            {
                "done",
                "x",
            },
        },

    },
}
vim.list_extend(
    keys, {
        {
            "<localleader>t",
            desc = "task",
        },
        {
            "<localleader>ta",
            "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)",
            desc = "task is ambiguous",
        },
        {
            "<localleader>tc",
            "<Plug>(neorg.qol.todo-items.todo.task-cancelled)",
            desc = "task is cancelled",
        },
        {
            "<localleader>td",
            "<Plug>(neorg.qol.todo-items.todo.task-done)",
            desc = "task is done",
        },
        {
            "<localleader>th",
            "<Plug>(neorg.qol.todo-items.todo.task-on-hold)",
            desc = "task is on hold",
        },
        {
            "<localleader>ti",
            "<Plug>(neorg.qol.todo-items.todo.task-important)",
            desc = "task is important",
        },
        {
            "<localleader>tp",
            "<Plug>(neorg.qol.todo-items.todo.task-pending)",
            desc = "task is pending",
        },
        {
            "<localleader>tr",
            "<Plug>(neorg.qol.todo-items.todo.task-recurring)",
            desc = "task is recurring",
        },
        {
            "<localleader>tu",
            "<Plug>(neorg.qol.todo-items.todo.task-undone)",
            desc = "task is undone",
        },
    }
)

--- Storage
opts.load["core.storage"] = {
    config = {
        path = "~/Core/Resources/neorg/neorg.mpack",
    },
}

opts.load["core.summary"] = {
    config = {
        strategy = "default",
    },
}
vim.list_extend(
    keys, {
        {
            "<localleader>is",
            ":Neorg generate-workspace-summary ",
            desc = "insert summary",
        },
    }
)

---
--- === External Modules ===
---

--- Queries
opts.load["external.query"] = {
    -- Populate the database. Indexing happens on a separate thread, so doesn't block
    -- neovim. We also
    index_on_launch = true,

    -- Update the db entry when a file is written
    update_on_change = true,
}

--- LSP
opts.load["external.interim-ls"] = {
    config = {
        -- default config shown
        completion_provider = {
            -- Enable or disable the completion provider
            enable = true,

            -- Show file contents as documentation when you complete a file name
            documentation = true,

            -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
            categories = true,
        },
    },
}

opts.load["external.search"] = {
    -- values shown are the default
    config = {
        -- Index the workspace when neovim launches. This process happens on a separate thread, so
        -- it doesn't significantly contribute to startup time or block neovim
        index_on_start = true,
    },
}
vim.list_extend(
    keys, {
        {
            "<localleader>s",
            desc = "search",
        },
        {
            "<localleader>ss",
            ":Neorg search query fulltext",
            desc = "search notes",
        },
        {
            "<localleader>sc",
            ":Neorg search query fulltext categories",
            desc = "search categories",
        },

    }
)

spec.config = function(_, o)
    o.load["core.dirman"].config.workspaces = get_workspaces(
        o.load["core.dirman"].config.workspaces,
            o.load["core.dirman"].config.index
    )

    o.load["core.dirman"].config.default_workspace = function()
        local basename = vim.fs.basename(vim.fn.getcwd()):lower()
        local workspaces = o.load["core.dirman"].config.workspaces
        if workspaces[basename] ~= nil then
            return basename
        end
        return "core"
    end

    OL.load_setup("neorg", {}, o)
    OL.map({ keys })
end
