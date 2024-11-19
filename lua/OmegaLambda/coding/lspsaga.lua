local spec, opts = OL.spec:add("nvimdev/lspsaga.nvim")
spec.event = {
    "LspAttach",
}

---
--- === Opts ===
---

--- Breadcrumbs ---
opts.symbol_in_winbar = {
    enable = true,
    hide_keyword = false,
}

--- Call Hierarchy ---
opts.callhierarchy = {}

--- Code Actions ---
opts.code_action = {
    num_shortcut = true,
    server_name = true,
    extend_gitsigns = true,
    only_in_cursor = false,
}

--- Definitions ---
opts.definition = {}

--- Diagnostics ---
opts.diagnostic = {
    show_code_action = true,
    jump_num_shortcut = true,
    text_hl_follow = true,
    border_follow = true,
    extend_relatedInformation = true,
    diagnostic_only_current = true,
}

--- Finder ---
opts.finder = {}

--- Float Terminal ---

--- Hover Docs ---
opts.hover = {
    open_cmd = "!browser",
}

--- Implement ---
opts.implement = {
    enable = false,
}

--- Lightbulb ---
opts.lightbulb = {
    enable = true,
    sign = false,
    virtual_text = true,
    sign_priority = 200,
}

--- Outline ---
opts.outline = {}

--- Rename ---
opts.rename = {}

--- Scroll Preview ---
opts.scroll_preview = {}

--- UI ---
opts.ui = {}

---
--- === Keys ===
---

--- Diagnostics ---
local diagnostics = {
    e = {
        severity = vim.diagnostic.severity.ERROR,
        name = "Error",
    },
    w = {
        severity = vim.diagnostic.severity.WARN,
        name = "Warn",
    },
    i = {
        severity = vim.diagnostic.severity.INFO,
        name = "Info",
    },
    h = {
        severity = vim.diagnostic.severity.HINT,
        name = "Hint",
    },
    d = {},
}

for d, diagnostic in pairs(diagnostics) do
    local name = diagnostic.name
    local desc, severity
    if diagnostic.severity == nil then
        severity = {}
        desc = "Jump to %s diagnostic"
    else
        severity = {
            severity = diagnostic.severity,
        }
        desc = "Jump to %s %s diagnostic"
    end
    OL.map(
      {
          mode = {
              "n",
          },
          {
              {
                  "[" .. d,
                  function()
                      OL.load(
                        "lspsaga.diagnostic", {}, function(lspsaga)
                            lspsaga:goto_prev(severity)
                        end
                      )
                  end,
                  desc = OL.fstring(desc, "previous", name),
              },
              {
                  "]" .. d,
                  function()
                      OL.load(
                        "lspsaga.diagnostic", {}, function(lspsaga)
                            lspsaga:goto_next(severity)
                        end
                      )
                  end,
                  desc = OL.fstring(desc, "next", name),
              },
          },
      }
    )
end

spec.keys = {
    {
        "<leader>dc",
        function()
            vim.cmd("Lspsaga show_cursor_diagnostics")
        end,
        desc = "Cursor Diagnostics",
    },
    {
        "<leader>dl",
        function()
            vim.cmd("Lspsaga show_line_diagnostics")
        end,
        desc = "Line Diagnostics",
    },
    {
        "<leader>db",
        function()
            vim.cmd("Lspsaga show_buf_diagnostics")
        end,
        desc = "Buffer Diagnostics",
    },
    {
        "<leader>dw",
        function()
            vim.cmd("Lspsaga show_workspace_diagnostics")
        end,
        desc = "Workspace Diagnostics",
    },
    {
        "<leader>df",
        function()
            vim.cmd("Lspsaga finder")
        end,
        desc = "LSP Finder",
    },
    {
        "<leader>dpd",
        function()
            vim.cmd("Lspsaga peek_definition")
        end,
        desc = "Peek Definition",
    },
    {
        "<leader>dpt",
        function()
            vim.cmd("Lspsaga peek_type_definition")
        end,
        desc = "Peek Type Definition",
    },
    {
        "<leader>dgd",
        function()
            vim.cmd("Lspsaga goto_definition")
        end,
        desc = "Goto Definition",
    },
    {
        "<leader>dgt",
        function()
            vim.cmd("Lspsaga goto_type_definition")
        end,
        desc = "Goto Type Definition",
    },
    {
        "<leader>da",
        function()
            vim.cmd("Lspsaga code_action")
        end,
        desc = "Code Action",
    },

    {
        'K',
        function()
            vim.cmd('Lspsaga hover_doc')
        end,
        mode = 'n',
        desc = "Hover Docs",
    },

    {
        '<C-space>',
        function()
            vim.cmd('Lspsaga show_cursor_diagnostics ++unfocus')
        end,
        mode = 'n',
        desc = "Cursor Diagnostics",
    },

}

OL.map(
  {
      "<leader>d",
      group = "LSP / Diagnostics",
      desc = "LSP / Diagnostics",
      { spec.keys },
  }
)

