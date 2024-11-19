-- better up/down
OL.map(
  {
      mode = {
          "n",
          "x",
      },
      {
          {
              "j",
              "v:count == 0 ? 'gj' : 'j'",
              desc = "Down",
              expr = true,
              silent = true,
          },
          {
              "<Down>",
              "v:count == 0 ? 'gj' : 'j'",
              desc = "Down",
              expr = true,
              silent = true,
          },
          {
              "k",
              "v:count == 0 ? 'gk' : 'k'",
              desc = "Up",
              expr = true,
              silent = true,
          },
          {
              "<Up>",
              "v:count == 0 ? 'gk' : 'k'",
              desc = "Up",
              expr = true,
              silent = true,
          },
      },
  }
)

-- Move to window using the <alt> hjkl keys
OL.map(
  {
      mode = { "n" },
      {
          {
              "<A-h>",
              "<A-w>h",
              desc = "Go to Left Window",
              remap = true,
          },
          {
              "<A-j>",
              "<A-w>j",
              desc = "Go to Lower Window",
              remap = true,
          },
          {
              "<A-k>",
              "<A-w>k",
              desc = "Go to Upper Window",
              remap = true,
          },

          -- Resize window using <alt> arrow keys
          {
              "<A-l>",
              "<A-w>l",
              desc = "Go to Right Window",
              remap = true,
          },
          {
              "<A-Up>",
              "<cmd>resize +2<cr>",
              desc = "Increase Window Height",
          },
          {
              "<A-Down>",
              "<cmd>resize -2<cr>",
              desc = "Decrease Window Height",
          },
          {
              "<A-Left>",
              "<cmd>vertical resize -2<cr>",
              desc = "Decrease Window Width",
          },
          {
              "<A-Right>",
              "<cmd>vertical resize +2<cr>",
              desc = "Increase Window Width",
          },
      },
  }
)

-- buffers
OL.map(
  {
      mode = { "n" },
      {

          {
              "<C-h>",
              "<cmd>bprevious<cr>",
              desc = "Prev Buffer",
          },
          {
              "<C-l>",
              "<cmd>bnext<cr>",
              desc = "Next Buffer",
          },
          {
              "[b",
              "<cmd>bprevious<cr>",
              desc = "Prev Buffer",
          },
          {
              "]b",
              "<cmd>bnext<cr>",
              desc = "Next Buffer",
          },
          {
              "<C-d>",
              function()
                  Snacks.bufdelete()
              end,
              desc = "Delete Buffer",
          },

          {
              "<leader>bd",
              function()
                  Snacks.bufdelete.other()
              end,
              desc = "Delete Other Buffers",
          },

          {
              "<leader>bD",
              "<cmd>:bd<cr>",
              desc = "Delete Buffer and Window",
          },
      },
  }
)

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
OL.map(
  {
      "<esc>",
      "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
      mode = { "n" },
      desc = "Redraw / Clear hlsearch / Diff Update",
  }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
OL.map(
  {
      mode = { "n" },
      {
          {
              "'Nn'[v:searchforward].'zv'",
              expr = true,
              desc = "Next Search Result",
          },
          {
              "'nN'[v:searchforward].'zv'",
              expr = true,
              desc = "Prev Search Result",
          },
      },
  }, {
      mode = { "x" },
      {
          {
              "'Nn'[v:searchforward]",
              expr = true,
              desc = "Next Search Result",
          },
          {
              "'nN'[v:searchforward]",
              expr = true,
              desc = "Prev Search Result",
          },
      },
  }, {
      mode = { "o" },
      {
          {
              "'Nn'[v:searchforward]",
              expr = true,
              desc = "Next Search Result",
          },
          {
              "'nN'[v:searchforward]",
              expr = true,
              desc = "Prev Search Result",
          },
      },
  }
)

-- Add undo break-points
OL.map(
  {
      mode = { "i" },
      {
          {
              ",",
              ",<c-g>u",
          },
          {
              ".",
              ".<c-g>u",
          },
          {
              ";",
              ";<c-g>u",
          },
      },
  }
)

-- better indenting
OL.map(
  {
      mode = { "v" },
      {
          {
              "<",
              "<gv",
          },
          {
              ">",
              ">gv",
          },
      },
  }
)

-- commenting
OL.map(
  {
      mode = { "n" },
      {
          {
              "gco",
              "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
              desc = "Add Comment Below",
          },
          {
              "gcO",
              "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
              desc = "Add Comment Above",
          },
      },
  }
)

-- lazy
OL.map(
  {
      "<leader>l",
      "<cmd>Lazy<cr>",
      mode = { "n" },
      desc = "Lazy",
  }
)

-- new file
OL.map(
  {
      "<leader>fn",
      "<cmd>enew<cr>",
      mode = { "n" },
      desc = "New File",
  }
)

-- quit
OL.map(
  {
      "<leader>qq",
      "<cmd>qa<cr>",
      mode = { "n" },
      desc = "Quit All",
  }
)
