OL.paths.treesitter = "treesitter"
local spec, opts = OL.spec:add("nvim-treesitter/nvim-treesitter")

OL.callbacks.colourscheme.treesitter = true

spec.main = "nvim-treesitter.configs"

--- Setup callbacks
OL.callbacks.treesitter = OL.OLConfig.new()
OL.callbacks.treesitter.configs = OL.OLConfig.new()
OL.callbacks.treesitter.dependencies = OL.OLConfig.new()
spec.dependencies = OL.callbacks.treesitter.dependencies

spec.build = ":TSUpdate"
spec.event = {
    "VeryLazy",
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
}
spec.lazy = vim.fn.argc(-1) == 0 --- Load treesitter early when opening a file from the cmdline
function spec.init(plugin)
    OL.load(
        "lazy.core.loader", {}, function(loader)
            return loader.add_to_rtp(plugin)
        end
    )
    OL.load("nvim-treesitter.query_predicates")
end

spec.cmd = {
    "TSUpdateSync",
    "TSUpdate",
    "TSInstall",
}

---
--- --- Opts ---
--- 

--- Highlight
OL.callbacks.treesitter.exclude = OL.OLConfig.new()
opts.highlight = {
    enable = true,
    additional_vim_regex_highlighting = OL.callbacks.treesitter.exclude,
}

--- Indent
opts.indent = {
    enable = true,
}

--- Install
OL.callbacks.treesitter.include = OL.OLConfig.new(
                                      {
        "markdown",
        "markdown_inline",
    }
                                  )
opts.ensure_installed = OL.callbacks.treesitter.include

OL.callbacks.update:add(
    function()
        OL.load(
            "nvim-treesitter.install", {}, function(ts)
                OL.log:info("Updating Treesitter")
                ts.update()
            end
        )
    end
)

opts.sync_install = false
opts.auto_install = true

function spec.config(_, o)
    local ts_opts = vim.tbl_deep_extend(
                        "force", o, OL.callbacks.treesitter.configs
                    )
    OL.load_setup(spec.main, {}, ts_opts)
end

--- Fold
OL.opt("foldmethod", "expr")
OL.opt("foldexpr", "nvim_treesitter#foldexpr()")
OL.opt("foldlevel", 99)

OL.loadall(
    "*", {
        from = OL.paths.treesitter,
        exclude = {
            "init",
        },
    }
)
