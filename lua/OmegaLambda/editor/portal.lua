local spec, opts = OL.spec:add("cbochs/portal.nvim")

spec.cmd = {
    "Portal",
}

---@type "debug" | "info" | "warn" | "error"
opts.log_level = OL.log.levels[OL.log.level]

---The base filter applied to every search.
---@type Portal.SearchPredicate | nil
opts.filter = nil

---The maximum number of results for any search.
---@type integer | nil
opts.max_results = 4

---The maximum number of items that can be searched.
---@type integer
opts.lookback = 100

---An ordered list of keys for labelling portals.
---Labels will be applied in order, or to match slotted results.
---@type string[]
opts.labels = {
    "j",
    "k",
    "h",
    "l",
}

---Select the first portal when there is only one result.
opts.select_first = false

---Keys used for exiting portal selection. Disable with [{key}] = false
---to `false`.
---@type table<string, boolean>
opts.escape = {
    ["<esc>"] = true,
}

---The raw window options used for the portal window
opts.window_options = {
    relative = "cursor",
    width = 80,
    height = math.floor(
      (vim.api.nvim_win_get_height(0) - (2 * opts.max_results)) /
        opts.max_results
    ),
    col = 2,
    focusable = false,
    border = "single",
    noautocmd = true,
}

spec.keys = {
    {
        "<leader>pc",
        function()
            OL.load(
              "portal.builtin", {}, function(portal)
                  portal.changelist.tunnel()
              end
            )
        end,
        desc = "Portal Changelist",
    },
    {
        "<leader>ph",
        function()
            OL.load(
              "portal.builtin", {}, function(portal)
                  portal.harpoon.tunnel()
              end
            )
        end,
        desc = "Portal Harpoon",
    },
    {
        "<leader>hp",
        function()
            OL.load(
              "portal.builtin", {}, function(portal)
                  portal.harpoon.tunnel()
              end
            )
        end,
        desc = "Portal Harpoon",
    },
    {
        "<leader>pj",
        function()
            OL.load(
              "portal.builtin", {}, function(portal)
                  portal.jumplist.tunnel()
              end
            )
        end,
        desc = "Portal Jumplist",
    },
    {
        "<leader>pq",
        function()
            OL.load(
              "portal.builtin", {}, function(portal)
                  portal.quickfix.tunnel()
              end
            )
        end,
        desc = "Portal Quickfix",
    },
}

OL.map(
  {
      "<leader>p",
      group = "Portal",
      desc = "Portal",
      { spec.keys },
  }
)

