CFG.treesitter = {
    ensure_installed = {},
}
local path = CFG.paths.join(
    {
        "Plugins",
        "treesitter",
    }
)

local treesitter = CFG.spec:add("nvim-treesitter/nvim-treesitter")

treesitter.main = "nvim-treesitter.configs"

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

treesitter.opts.ensure_installed = CFG.treesitter.ensure_installed

treesitter.opts.auto_install = true
treesitter.opts.sync_install = false

--- Highlight ---
treesitter.opts.highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
        local max_filesize = CFG.spec:get("snacks").opts.bigfile.size
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
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
        CFG.key:map(
            {
                "<CR>",
                "za",
                mode = {
                    "n",
                },
            }
        )
    end
)

--- Plugins ---
local plugins = {
    "rainbow_delimiters",
    "context",
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

CFG.colourscheme:set("treesitter")
