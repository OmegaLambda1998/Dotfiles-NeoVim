CFG.treesitter = {}
local path = CFG.paths.join(
    {
        "Plugins",
        "treesitter",
    }
)

local treesitter = CFG.spec:add("nvim-treesitter/nvim-treesitter")

treesitter.dependencies = {}

treesitter.build = ":TSUpdate"

treesitter.event = {
    "VeryLazy",
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
}

treesitter.cmd = {
    "TSUpdate",
    "TSInstall",
}

function treesitter.init(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
end

---
--- Opts ---
---

treesitter.opts.auto_install = true
treesitter.opts.sync_install = true

--- Highlight ---
treesitter.opts.highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
}

--- Indent ---
treesitter.opts.indent = {
    enable = true,
}

--- Folding ---
treesitter.post:insert(
    function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
        vim.wo.foldlevel = 99
    end
)

--- Plugins ---
local plugins = {
    "rainbow_delimiters",
}
for _, file in ipairs(plugins) do
    local plugin = require(
        path.join(
            { file }
        ).mod
    )
    if plugin.setup then
        treesitter = plugin.setup(treesitter)
    end
end
