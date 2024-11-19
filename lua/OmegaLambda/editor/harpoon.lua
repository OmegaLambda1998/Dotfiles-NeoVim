local spec, opts = OL.spec:add("ThePrimeagen/harpoon")
spec.branch = "harpoon2"

spec.dependencies = {
    "nvim-lua/plenary.nvim",
}

opts.menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
}

opts.settings = {
    save_on_toggle = true,
    save_on_ui_close = true,
    key = function()
        return vim.uv.cwd()
    end,
}

spec.keys = {
    {
        "<leader>ha",
        function()
            OL.load(
              "harpoon", {}, function(harpoon)
                  harpoon:list():add()
              end
            )
        end,
        desc = "Harpoon File",
    },
    {
        "<leader>hh",
        function()
            OL.load(
              "harpoon", {}, function(harpoon)
                  harpoon.ui:toggle_quick_menu(harpoon:list())
              end
            )
        end,
        desc = "Harpoon Quick Menu",
    },
    {
        "<leader>h;",
        function()
            OL.load(
              "harpoon", {}, function(harpoon)
                  harpoon:list():prev()
              end
            )
        end,
        desc = "Harpoon Next Buffer",
    },

    {
        "<leader>h,",
        function()
            OL.load(
              "harpoon", {}, function(harpoon)
                  harpoon:list():prev()
              end
            )
        end,
        desc = "Harpoon Prev Buffer",
    },
}
for i = 0, 9 do
    table.insert(
      spec.keys, {
          "<leader>h" .. i,
          function()
              require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
      }
    )
end

OL.map(
  {
      "<leader>h",
      group = "Harpoon",
      desc = "Harpoon",
      { spec.keys },
  }
)

function spec.config(_, o)
    OL.load(
      "harpoon", {}, function(harpoon)
          harpoon:setup(o)
      end
    )
end
