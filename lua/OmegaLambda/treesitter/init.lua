OL.paths.treesitter = "treesitter"

local spec, opts = OL.spec:add("nvim-treesitter/nvim-treesitter")

--- Setup callbacks
OL.callbacks.treesitter = OL.OLConfig.new()

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

--- Fold
OL.opt("foldmethod", "expr")
OL.opt("foldexpr", "nvim_treesitter#foldexpr()")
OL.opt("foldlevel", 99)

--- Config
function spec.config(_, o)
    if OL.is_man() then
        return
    end
    OL.load_setup("nvim-treesitter.configs", {}, o)
end

OL.loadall(
  "*", {
      from = OL.paths.treesitter,
      exclude = {
          "init",
      },
  }
)
