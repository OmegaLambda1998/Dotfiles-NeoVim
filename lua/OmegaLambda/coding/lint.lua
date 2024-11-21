local spec, opts = OL.spec:add("mfussenegger/nvim-lint")

OL.callbacks.lint = OL.OLConfig.new()

OL.callbacks.lint.ft = OL.OLConfig.new()
spec.event = OL.callbacks.lint.ft

OL.callbacks.lint.linters_by_ft = OL.OLConfig.new()
opts.linters_by_ft = OL.callbacks.lint.linters_by_ft

OL.callbacks.lint.linters = OL.OLConfig.new()
opts.linters = OL.callbacks.lint.linters

--- When to trigger linter
opts.events = {
    "BufWritePost",
    "BufReadPost",
    "InsertLeave",
}

local function debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
        local argv = {
            ...,
        }
        timer:start(
          ms, 0, function()
              timer:stop()
              vim.schedule_wrap(fn)(unpack(argv))
          end
        )
    end
end

local function run()
    local lint = OL.load("lint")
    -- Use nvim-lint's logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    -- Create a copy of the names table to avoid modifying the original.
    names = vim.list_extend({}, names)

    -- Filter out linters that don't exist or don't match the condition.
    local ctx = {
        filename = vim.api.nvim_buf_get_name(0),
    }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

    names = vim.tbl_filter(
              function(name)
          local linter = lint.linters[name]
          if not linter then
              OL.log:warn(
                "Linter not found: " .. name, {
                    title = "nvim-lint",
                }
              )
          end
          return linter and
                   not (type(linter) == "table" and linter.condition and
                     not linter.condition(ctx))
      end, names
            )

    -- Run linters.
    if #names > 0 then
        lint.try_lint(names)
    end
end

OL.aucmd("lint", opts.events, debounce(100, run))

-- Show linters for the current buffer's file type
OL.usrcmd(
  "LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = OL.load(
                        "lint", {}, function(lint)
            return lint.linters_by_ft[filetype]
        end
                      )
      if linters then
          OL.log:log(
            OL.log.level, OL.fstring(
              "Linters for %s: %s", filetype, table.concat(linters, ", ")
            )
          )
      else
          OL.log:log(
            OL.log.level,
            OL.fstring("No linters configured for filetype: ", filetype)
          )
      end
  end, {}
)

function spec.config(_, o)
    local lint = OL.load("lint")
    for name, linter in pairs(o.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
            lint.linters[name] = vim.tbl_deep_extend(
                                   "force", lint.linters[name], {
                  ignore_exitcode = not OL.verbose,
                  ignore_errors = not OL.verbose,
              }, linter
                                 )
            if type(linter.prepend_args) == "table" then
                lint.linters[name].args = lint.linters[name].args or {}
                vim.list_extend(lint.linters[name].args, linter.prepend_args)
            end
        else
            lint.linters[name] = linter
        end
    end
    lint.linters_by_ft = o.linters_by_ft
end

