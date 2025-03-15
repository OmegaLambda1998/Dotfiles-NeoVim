local M = {
    settings = {},
}

function M.create(mode, key, val)
    mode[key] = val
end

function M:set(mode, key, val)
    if val == nil then
        val = true
    end
    table.insert(
        self.settings, {
            mode,
            key,
            val,
        }
    )
    if CFG.is_setup then
        M.create(mode, key, val)
    end
end

function M:opt(key, val)
    M:set(vim.opt, key, val)
end

function M:opt_local(key, val)
    M:set(vim.opt_local, key, val)
end

function M:opt_global(key, val)
    M:set(vim.opt_global, key, val)
end

function M:o(key, val)
    M:set(vim.o, key, val)
end

function M:go(key, val)
    M:set(vim.go, key, val)
end

function M:bo(key, val)
    M:set(vim.bo, key, val)
end

function M:wo(key, val)
    M:set(vim.wo, key, val)
end

function M:g(key, val)
    M:set(vim.g, key, val)
end

function M:b(key, val)
    M:set(vim.b, key, val)
end

function M:setup()
    for _, setting in ipairs(self.settings) do
        M.create(unpack(setting))
    end
end

return M
