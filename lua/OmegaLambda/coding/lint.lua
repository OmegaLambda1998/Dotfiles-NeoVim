local index, spec, opts = OL.spec:add("mfussenegger/nvim-lint")

OL.callbacks.lint = OLConfig.new()

OL.callbacks.lint.ft = OLConfig.new()
spec.event = OL.callbacks.lint.ft

OL.callbacks.lint.linters_by_ft = OLConfig.new()
opts.linters_by_ft = OL.callbacks.lint.linters_by_ft

OL.callbacks.lint.linters = OLConfig.new()
opts.linters = OL.callbacks.lint.linters

--- When to trigger linter
opts.events = {"BufWritePost", "BufReadPost", "InsertLeave"}

function spec.config(_, opts)
    local M = {}

    local lint = OL.load("lint")
    for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
            lint.linters[name] = vim.tbl_deep_extend("force",
                                                     lint.linters[name], linter)
            if type(linter.prepend_args) == "table" then
                lint.linters[name].args = lint.linters[name].args or {}
                vim.list_extend(lint.linters[name].args, linter.prepend_args)
            end
        else
            lint.linters[name] = linter
        end
    end
    lint.linters_by_ft = opts.linters_by_ft

    function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
            local argv = {...}
            timer:start(ms, 0, function()
                timer:stop()
                vim.schedule_wrap(fn)(unpack(argv))
            end)
        end
    end

    function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = {filename = vim.api.nvim_buf_get_name(0)}
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
            local linter = lint.linters[name]
            if not linter then
                LazyVim.warn("Linter not found: " .. name, {title = "nvim-lint"})
            end
            return linter and
                       not (type(linter) == "table" and linter.condition and
                           not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then lint.try_lint(names) end
    end

    OL.aucmd("lint", {opts.events, M.debounce(100, M.lint)})
end
