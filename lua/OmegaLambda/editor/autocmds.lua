-- Check if we need to reload the file when it changed
OL.aucmd(
  "checktime", {
      {
          "FocusGained",
          "TermClose",
          "TermLeave",
      },
      function()
          if vim.o.buftype ~= "nofile" then
              vim.cmd("checktime")
          end
      end,
  }

)

-- Highlight on yank
OL.aucmd(
  "highlight_yank", {
      {
          "TextYankPost",
      },
      function()
          (vim.hl or vim.highlight).on_yank()
      end,
  }
)

-- resize splits if window got resized
OL.aucmd(
  "resize_splits", {
      { "VimResized" },
      function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
      end,
  }
)

-- go to last loc when opening a buffer
OL.aucmd(
  "last_loc", {
      {
          "BufReadPost",
      },
      function(event)
          local exclude = {
              "gitcommit",
          }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) or
            vim.b[buf].lazyvim_last_loc then
              return
          end
          vim.b[buf].lazyvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
      end,
  }

)

-- close some filetypes with <q>
OL.aucmd(

  "close_with_q", {
      { "FileType" },
      function(event)
          vim.bo[event.buf].buflisted = false
          vim.schedule(
            function()
                OL.map(
                  {
                      "q",
                      function()
                          vim.cmd("close")
                          pcall(
                            vim.api.nvim_buf_delete, event.buf, {
                                force = true,
                            }
                          )
                      end,
                      mode = {
                          "n",
                      },
                      buffer = event.buf,
                      silent = true,
                      desc = "Quit buffer",
                  }
                )
            end
          )
      end,
      pattern = {
          "PlenaryTestPopup",
          "checkhealth",
          "dbout",
          "gitsigns-blame",
          "grug-far",
          "help",
          "lspinfo",
          "neotest-output",
          "neotest-output-panel",
          "neotest-summary",
          "notify",
          "qf",
          "snacks_win",
          "spectre_panel",
          "startuptime",
          "tsplayground",
      },

  }
)

-- make it easier to close man-files when opened inline
OL.aucmd(
  "man_unlisted", {
      { "FileType" },
      function(event)
          vim.bo[event.buf].buflisted = false
      end,
      pattern = {
          "man",
      },
  }
)

-- Fix conceallevel for json files
OL.aucmd(
  "json_conceal", {
      { "FileType" },
      function()
          vim.opt_local.conceallevel = 0
      end,
      pattern = {
          "json",
          "jsonc",
          "json5",
      },
  }
)

-- Auto create dir when saving a file, in case some intermediate directory does not exist
OL.aucmd(
  "auto_create_dir", {
      {
          "BufWritePre",
      },
      function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
              return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
      end,
  }
)
