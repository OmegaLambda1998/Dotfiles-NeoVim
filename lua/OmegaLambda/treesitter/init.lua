OL.paths.treesitter = "treesitter"

local index, spec, opts = OL.spec:add("nvim-treesitter/nvim-treesitter")

--- Setup callbacks
OL.callbacks.treesitter = OLConfig.new()

spec.build = ":TSUpdate"
spec.event = {"VeryLazy", "BufReadPost", "BufNewFile", "BufWritePre" }
spec.lazy = vim.fn.argc(-1) == 0 --- Load treesitter early when opening a file from the cmdline
function spec.init(plugin)
	OL.load("lazy.core.loader", {}, function(loader)
		return loader.add_to_rtp(plugin) 
	end)
	OL.load("nvim-treesitter.query_predicates")
end

spec.cmd = {"TSUpdateSync", "TSUpdate", "TSInstall"}

---
--- --- Opts ---
--- 

--- Highlight
OL.callbacks.treesitter.exclude = OLConfig.new()
opts.highlight = {
	enable = true,
	additional_vim_regex_highlighting = OL.callbacks.treesitter.exclude
}

--- Indent
opts.indent = {
	enable = true
}

--- Install
OL.callbacks.treesitter.include = OLConfig.new()
opts.ensure_installed = OL.callbacks.treesitter.include

opts.sync_install = false
opts.auto_install = true

--- Fold
OL.opt("foldmethod", "expr")
OL.opt("foldexpr", "nvim_treesitter#foldexpr()")
OL.opt("foldlevel", 99)

--- Config
function spec.config(_, opts)
	OL.load_setup("nvim-treesitter.configs", {}, opts)
end

OL.loadall("*", {from=OL.paths.treesitter, exclude = {"init"}})
