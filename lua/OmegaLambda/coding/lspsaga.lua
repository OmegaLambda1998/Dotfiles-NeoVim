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
    sign_priority = 20,
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
              -- {
              --     "[" .. string.upper(d),
              --     function()
              --         OL.load(
              --           "lspsaga.diagnostic", {}, function(lspsaga)
              --               lspsaga:goto_first(severity)
              --           end
              --         )
              --     end,
              --     desc = OL.fstring(desc, "first", name),
              -- },
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
              -- {
              --     "]" .. string.upper(d),
              --     function()
              --         OL.load(
              --           "lspsaga.diagnostic", {}, function(lspsaga)
              --               lspsaga:goto_last(severity)
              --           end
              --         )
              --     end,
              --     desc = OL.fstring(desc, "last", name),
              -- },
          },
      }
    )
end

--- Hover Docs ---
OL.map(
  {
      'K',
      function()
          vim.cmd('Lspsaga hover_doc')
      end,
      mode = 'n',
      desc = "LSP Hover Docs",
  }
)
