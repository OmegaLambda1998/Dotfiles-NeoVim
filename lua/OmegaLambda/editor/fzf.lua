local spec, opts = OL.spec:add("ibhagwan/fzf-lua")

OL.callbacks.colourscheme.fzf = true

spec.cmd = {
    "FzfLua",
}

spec.keys = {
    {
        "<leader>zf",
        function()
            vim.cmd("FzfLua files")
        end,
        desc = "Open Files",
    },
    {
        "<leader>zh",
        function()
            vim.cmd("FzfLua oldfiles")
        end,
        desc = "Open Recent Files",
    },
    {
        "<leader>zg",
        function()
            vim.cmd("FzfLua live_grep_native")
        end,
        desc = "Grep Project",
    },
}

OL.map(
  {
      "<leader>z",
      group = "FzF",
      desc = "FzF",
      { spec.keys },
  }
)
