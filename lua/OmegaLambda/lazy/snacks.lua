---
--- === Snacks ===
---
local spec, opts = OL.spec:add("folke/snacks.nvim")
spec.priority = 1000
spec.lazy = false
OL.callbacks.post:add(
  function()
      OL.Snacks = OL.load("snacks")
  end
)

---
--- --- Big Files ---
---

OL.callbacks.bigfile = OL.OLCall.new(
                         {
      function(ctx)
          OL.log:trace(ctx)
          OL.log:flush()
      end,
  }
                       )

opts.bigfile = OL.OLConfig.new(
                 {
      notify = true, --- Show notification when bigfile detected
      size = 1.5 * 1024 * 1024, --- 1.5MB
      setup = OL.callbacks.bigfile,
  }
               )

---
--- --- Buf Delete ---
---

---
--- --- Dashboard ---
---
opts.dashboard = {
    preset = {},
}

local sections = {}
function sections:add(tbl)
    if type(tbl) == "string" then
        tbl = {
            section = tbl,
        }
    end
    table.insert(self, tbl)
end

sections:add("header")

opts.dashboard.sections = sections

---
--- --- Debug ---
---

OL.callbacks.post:add(
  function()
      vim.print = function(...)
          OL.Snacks.debug.inspect(...)
      end
  end
)

---
--- --- Git ---
---

---
--- --- Git Browse ---
---

---
--- --- Lazy Git ---
---

---
--- --- Notify ---
---

table.insert(
  OL.callbacks.colourscheme, {
      notfiy = true,
  }
)

OL.callbacks.post:add(
  function()
      OL.notify = function(msg, o)
          if o == nil then
              o = {}
          end
          if o.title == nil then
              o.title = "OmegaLambda"
          end
          if o.level == nil then
              o.level = vim.log.levels.INFO
          end
          OL.Snacks.notify(msg, o)
      end
  end
)

---
--- --- Notifier ---
---

table.insert(
  OL.callbacks.colourscheme, {
      notfier = true,
  }
)

opts.notifier = {
    style = "compact",
}

OL.aucmd(
  "LspProgress", {
      {
          "LspProgress",
          function(ev)
              local progress = vim.defaulttable()
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
              if not client or type(value) ~= "table" then
                  return
              end
              local p = progress[client.id]

              for i = 1, #p + 1 do
                  if i == #p + 1 or p[i].token == ev.data.params.token then
                      p[i] = {
                          token = ev.data.params.token,
                          msg = ("[%3d%%] %s%s"):format(
                            value.kind == "end" and 100 or value.percentage or
                              100, value.title or "", value.message and
                              (" **%s**"):format(value.message) or ""
                          ),
                          done = value.kind == "end",
                      }
                      break
                  end
              end

              local msg = {} ---@type string[]
              progress[client.id] = vim.tbl_filter(
                                      function(v)
                    return table.insert(msg, v.msg) or not v.done
                end, p
                                    )

              local spinner = {
                  "⠋",
                  "⠙",
                  "⠹",
                  "⠸",
                  "⠼",
                  "⠴",
                  "⠦",
                  "⠧",
                  "⠇",
                  "⠏",
              }
              vim.notify(
                table.concat(msg, "\n"), "info", {
                    id = "lsp_progress",
                    title = client.name,
                    opts = function(notif)
                        notif.icon = #progress[client.id] == 0 and " " or
                                       spinner[math.floor(
                                         vim.uv.hrtime() / (1e6 * 80)
                                       ) % #spinner + 1]
                    end,
                }
              )
          end,
      },
  }
)

---
--- --- Quick File ---
---

opts.quickfile = {
    exclude = OL.callbacks.treesitter.exclude,
}

---
--- --- Rename ---
---

---
--- --- Status Column ---
---

OL.opt("number")
OL.opt("relativenumber")
OL.opt("signcolumn", "yes")
OL.opt("statuscolumn", [[%!v:lua.require'snacks.statuscolumn'.get()]])
opts.statuscolumn = {
    left = { "sign" },
    right = {
        "fold",
        "git",
    },
    folds = {
        open = true,
        git_hl = true,
    },
    git = {
        patterns = {
            "GitSign",
        },
    },
    refresh = 50,
}

---
--- --- Terminal ---
---

---
--- --- Toggle ---
---

opts.toggle = {
    map = vim.keymap.set,
    which_key = true,
    notify = true,
    --- icons for enabled/disabled states
    icon = {
        enabled = " ",
        disabled = " ",
    },
    --- colors for enabled/disabled states
    color = {
        enabled = "green",
        disabled = "yellow",
    },
}

---
--- --- Windows ---
---

---
--- --- Words ---
---

opts.words = {
    enabled = true, -- enable/disable the plugin
    debounce = 200, -- time in ms to wait before updating
    notify_jump = false, -- show a notification when jumping
    notify_end = true, -- show a notification when reaching the end
    foldopen = true, -- open folds after jumping
    jumplist = true, -- set jump point before jumping
    modes = {
        "n",
        "i",
        "c",
    }, -- modes to show references
}

function OL.is_man()
    for _, v in ipairs(vim.v.argv) do
        if v:find("neovim-page", 1, true) then
            return true
        end
    end
    return false
end

function spec.config(_, o)
    if OL.is_man() then
        return
    end

    local job = OL.load("plenary.job")
    local path = OL.load("plenary.path")

    --- Get Font
    local fonts = path:new(OL.paths.lazy:abs("figlet")):readlines()
    math.randomseed(os.time())
    local font = fonts[math.random(#fonts)]
    OL.font = font

    --- Get root
    local cwd = vim.fs.normalize(vim.fn.getcwd())
    local root
    for dir in vim.fs.parents(cwd) do
        if vim.fn.isdirectory(dir .. "/.git") == 1 then
            root = dir
            break
        end
    end
    cwd = vim.fs.basename(root and vim.fs.normalize(root) or cwd)
    local header, _ = job:new(
                        {
          command = "figlet",
          args = {
              "-f",
              font,
              "/" .. cwd,
          },
          enable_recording = true,
      }
                      ):sync()
    o.dashboard.preset.header = table.concat(header, "\n")

    OL.load_setup("snacks", {}, o)
end
