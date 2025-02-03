local lint = CFG.spec:add("mfussenegger/nvim-lint")

lint.main = "lint"
lint.setup = false
lint.event = {
    "BufWritePost",
    "BufReadPost",
    "InsertLeave",
}

CFG.disable.lint = false

CFG.lint = {}
CFG.lint.linters = {}

CFG.lint.linters_by_ft = {
    ["*"] = {}, --- All filetypes
    ["_"] = {}, --- Filetypes without a formatter
}

lint.opts.linters = CFG.lint.linters
lint.opts.linters_by_ft = CFG.lint.linters_by_ft

function CFG.lint:add(ft, linter, opts)
    opts = opts or {}
    self.linters_by_ft[ft] = vim.tbl_deep_extend(
        "force", self.linters_by_ft[ft] or {}, {
            linter,
        }
    )
    self.linters[linter] = vim.tbl_deep_extend(
        "force", self.linters[linter] or {}, opts
    )
    if opts.mason ~= false then
        if opts.mason then
            linter = opts.mason
        end
        table.insert(CFG.mason.ensure_installed, linter)
    end
end

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

local function run(dry_run)
    local Lint = require("lint")

    -- Use nvim-lint's logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    local names = Lint._resolve_linter_by_ft(vim.bo.filetype)

    -- Create a copy of the names table to avoid modifying the original.
    names = vim.list_extend({}, names)
    names = vim.list_extend(names, CFG.lint.linters_by_ft["*"])

    -- Filter out linters that don't exist or don't match the condition.
    local ctx = {
        filename = vim.api.nvim_buf_get_name(0),
    }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

    names = vim.tbl_filter(
        function(name)
            local linter = Lint.linters[name]
            if not linter then
                vim.print("Linter not found: " .. name)
            end
            return linter ~= nil
        end, names
    )

    if dry_run ~= true then
        -- Run linters.
        if #names > 0 then
            for _, name in ipairs(names) do
                Lint.try_lint(name)
            end
        end
    else
        return names
    end
end

CFG.usrcmd:fn(
    "LintInfo", function()
        local filetype = vim.bo.filetype
        local linters = run(true)
        if linters then
            vim.print(
                string.format(
                    "Linters for %s: %s", filetype, table.concat(linters, ", ")
                )
            )
        else
            vim.print(
                string.format("No linters configured for filetype: ", filetype)
            )
        end
    end, {}
)

lint.pre:insert(
    function(opts)
        local Lint = require("lint")
        for name, linter in pairs(opts.linters) do
            if type(linter) == "table" and type(Lint.linters[name]) == "table" then
                Lint.linters[name] = vim.tbl_deep_extend(
                    "force", Lint.linters[name], {
                        ignore_exitcode = not CFG.verbose,
                        ignore_errors = not CFG.verbose,
                    }, linter
                )
                if type(linter.prepend_args) == "table" then
                    Lint.linters[name].args = vim.list_extend(
                        linter.prepend_args, Lint.linters[name].args or {}
                    )
                end
            else
                Lint.linters[name] = linter
            end
        end
        Lint.linters_by_ft = opts.linters_by_ft
    end
)

lint.post:insert(
    function()
        CFG.aucmd:on(lint.event, debounce(100, run))
    end
)
