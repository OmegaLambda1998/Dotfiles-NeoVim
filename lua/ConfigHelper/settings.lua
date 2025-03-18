local M = {
    settings = {},
}

function M.create(mode, key, val, mod)
    if mod ~= nil then
        mode[key][mod](mode[key], val)
    else
        mode[key] = val
    end
end

function M:set(mode, key, val, mod)
    if val == nil then
        val = true
    end
    table.insert(
        self.settings, {
            mode,
            key,
            val,
            mod,
        }
    )
    if CFG.is_setup then
        M.create(mode, key, val, mod)
    end
end

function M:opt(key, val, mod)
    M:set(vim.opt, key, val, mod)
end

function M:opt_local(key, val, mod)
    M:set(vim.opt_local, key, val, mod)
end

function M:opt_global(key, val, mod)
    M:set(vim.opt_global, key, val, mod)
end

function M:o(key, val, mod)
    M:set(vim.o, key, val, mod)
end

function M:go(key, val, mod)
    M:set(vim.go, key, val, mod)
end

function M:bo(key, val, mod)
    M:set(vim.bo, key, val, mod)
end

function M:wo(key, val, mod)
    M:set(vim.wo, key, val, mod)
end

function M:g(key, val, mod)
    M:set(vim.g, key, val, mod)
end

function M:b(key, val, mod)
    M:set(vim.b, key, val, mod)
end

function M:setup()
    for _, setting in ipairs(self.settings) do
        M.create(unpack(setting))
    end
end

return M
