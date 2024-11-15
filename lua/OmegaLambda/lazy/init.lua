---
--- === Lazy.nvim ===
---
---
--- --- Setup ---
---
--- Create Lazy config and opts
OL.spec = OLSpec.new()
OL.lazy = OLConfig.new()
OL.lazy.opts = OLConfig.new()
OL.paths.lazy = "lazy"
local opts = OL.lazy.opts

---
--- --- Default Spec ---
---

--- Icons
OL.spec:add("echasnovski/mini.icons", {opts = {}})
OL.spec:add("nvim-tree/nvim-web-devicons", {opts = {}})

---
--- --- Lazy Config ---
---

--- Directory where plugins will be installed
opts.root = vim.fn.stdpath("data") .. "/lazy"

--- Plugin spec defaults
opts.defaults = {
    --- Set this to `true` to have all your plugins lazy-loaded by default.
    --- Only do this if you know what you are doing, as it can lead to unexpected behavior.
    lazy = true, -- should plugins be lazy-loaded?
    --- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    --- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    --- version = "*", -- try installing the latest stable version for plugins that support semver
    --- default `cond` you can use to globally disable a lot of plugins
    --- when running inside vscode for example
    cond = nil ---@type boolean|fun(self:LazyPlugin):boolean|nil
}

--- Load project specific .lazy.lua spec files. They will be added at the end of the spec.
opts.local_spec = false

--- Lockfile generated after running update.
opts.lockfile = opts.root .. "/lazy-lock.json" -- 

--- Limit the maximum amount of concurrent tasks
opts.concurrency = nil

--- Lazy git options
opts.git = {
    --- Defaults for the `Lazy log` command
    log = {"--since=3 days ago"}, --- Show commits from the last 3 days
    -- log = { "-8" }, --- Show the last 8 commits
    timeout = 120, --- Kill processes that take more than 2 minutes
    url_format = "https://github.com/%s.git",
    --- Lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
    --- then set the below to false. This should work, but is NOT supported and will
    --- increase downloads a lot.
    filter = true
}

--- Lazy package sources
opts.pkg = {
    enabled = true,
    cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
    versions = true, -- Honor versions in pkg sources
    --- Fhe first package source that is found for a plugin will be used.
    sources = {"lazy", "rockspec", "packspec"}
}

--- LuaRocks package source
opts.rocks = {
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://nvim-neorocks.github.io/rocks-binaries/"
}

--- Local package source
opts.dev = {
    --- String directory where you store your local plugin projects
    path = "~/projects",
    --- Plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, --- For example {"folke"}
    fallback = false --- Fallback to git when local plugin doesn't exist
}

--- Install options
opts.install = {
    --- Install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    --- Try to load one of these colorschemes when starting an installation during startup
    colorscheme = {"habamax"}
}

--- UI
opts.ui = {
    --- A number <1 is a percentage., >1 is a fixed size
    size = {width = 0.8, height = 0.8},
    --- wrap the lines in the ui
    wrap = true,
    --- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "single",
    --- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
    backdrop = 80,
    --- Only works when border is not "none"
    title = "Lazy",
    --- "center" | "left" | "right"
    title_pos = "left",
    --- Show pills on top of the Lazy window
    pills = true,
    icons = {
        cmd = " ",
        config = "",
        event = " ",
        favorite = " ",
        ft = " ",
        init = " ",
        import = " ",
        keys = " ",
        lazy = "󰒲 ",
        loaded = "●",
        not_loaded = "○",
        plugin = " ",
        runtime = " ",
        require = "󰢱 ",
        source = " ",
        start = " ",
        task = "✔ ",
        list = {"●", "➜", "★", "‒"}
    },
    -- Leave nil, to automatically select a browser depending on your OS.
    -- If you want to use a specific browser, you can define it here
    browser = nil,
    --- how frequently should the ui process render events
    throttle = 20,
    custom_keys = {}
}

--- Diff Command
opts.diff = {
    -- Diff command <d> can be one of:
    -- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
    --   so you can have a different command for diff <d>
    -- * git: will run git diff and open a buffer with filetype git
    -- * terminal_git: will open a pseudo terminal with git diff
    -- * diffview.nvim: will open Diffview to show the diff
    cmd = "diffview.nvim"
}

--- Update checker
opts.checker = {
    --- automatically check for plugin updates
    enabled = true,
    concurrency = nil, --- Set to 1 to check for updates very slowly
    notify = true, --- Get a notification when new updates are found
    frequency = 3600, --- Check for updates every hour
    check_pinned = false --- Check for pinned packages that can't be updated
}

OL.events.update = "OLUpdate"
OL.callbacks.update = OLCall.new()
OL.callbacks.update.event = OL.events.update
OL.callbacks.update:add(function()
    OL.load("lazy", {}, function(lazy)
        OL.log:info("Updating Lazy")
        lazy.sync({wait = false, show = false})
    end)
end)

--- Detect config changes
opts.change_detection = {
    --- Automatically check for config file changes and reload the ui
    enabled = true,
    --- get a notification when changes are found
    notify = true
}

--- Performance
opts.performance = {
    cache = {enabled = true},
    --- Reset the package path to improve startup time
    reset_packpath = true,
    rtp = {
        --- Reset the runtime path to $VIMRUNTIME and your config directory
        reset = true,
        --- Add any custom paths here that you want to includes in the rtp
        paths = {},
        --- List any plugins you want to disable here
        disabled_plugins = {
            -- "gzip",
            -- "matchit",
            -- "matchparen",
            -- "netrwPlugin",
            -- "tarPlugin",
            -- "tohtml",
            -- "tutor",
            -- "zipPlugin",
        }
    }
}

--- Lazy can generate helptags from the headings in markdown readme files,
--- so :help works even for plugins that don't have vim docs.
--- When the readme opens with :help it will be correctly displayed as markdown
opts.readme = {
    enabled = true,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    files = {"README.md", "lua/**/README.md"},
    --- Only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true
}

--- State info for checker and other things
opts.state = vim.fn.stdpath("state") .. "/lazy/state.json"

--- Enable profiling of lazy.nvim. This will add some overhead,
--- so only enable this when you are debugging lazy.nvim
opts.profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    loader = OL.verbose,
    -- Track each new require in the Lazy profiling tab
    require = OL.verbose
}
OL.log:debug("Lazy Profiling set to %s", opts.profiling)

---
--- --- Bootstrap ---
---

function OL.lazy.bootstrap()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({
            "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo,
            lazypath
        })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                {"Failed to clone lazy.nvim:\n", "ErrorMsg"},
                {out, "WarningMsg"}, {"\nPress any key to exit..."}
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)
end

---
--- --- Setup ---
---

function OL.lazy.setup()
    OL.lazy.opts.spec = OL.spec
    require("lazy").setup(OL.lazy.opts)
end
