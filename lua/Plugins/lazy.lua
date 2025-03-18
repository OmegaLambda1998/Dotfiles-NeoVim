local M = {}

function M.bootstrap()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system(
            {
                "git",
                "clone",
                "--filter=blob:none",
                "--branch=stable",
                lazyrepo,
                lazypath,
            }
        )
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo(
                {
                    {
                        "Failed to clone lazy.nvim:\n",
                        "ErrorMsg",
                    },
                    {
                        out,
                        "WarningMsg",
                    },
                    {
                        "\nPress any key to exit...",
                    },
                }, true, {}
            )
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
end

local opts = {
    defaults = {
        lazy = true,
        version = nil,
        cond = function()
            return not CFG.is_pager()
        end,
    },
    ui = {
        border = "single",
    },
    custom_keys = {
        ["<localleader>l"] = false,
        ["<localleader>i"] = false,
        ["<localleader>t"] = false,
    },
    checker = {
        enabled = true,
        notify = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "editorconfig",
                "gzip",
                "man",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "osc52",
                "rplugin",
                "shada",
                "spellfile",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    profiling = {
        loader = CFG.verbose,
        require = CFG.verbose,
    },
    dev = {
        path = vim.fn.stdpath("config") .. "/plugins",
    },
}

function M.setup()
    opts.spec = CFG.spec.spec
    local lazy = require("lazy")
    lazy.setup(opts)

    CFG.key:map(
        {
            "<leader>l",
            mode = "n",
            desc = "Lazy",
            group = "Lazy",
            {
                "<leader>ll",
                ":Lazy<CR>",
                desc = "Open",
            },
            {
                "<leader>lp",
                ":Lazy profile<CR>",
                desc = "Profile",
            },
            {
                "<leader>ld",
                ":Lazy debug<CR>",
                desc = "Debug",
            },
            {
                "<leader>lu",
                ":Lazy update<CR>",
                desc = "Update",
            },
            {
                "<leader>lh",
                ":Lazy health<CR>",
                desc = "Health",
            },
        }
    )
end

return M
