local M = {}

M.spec = {}

M.get = function(self, name)
    for _, spec in ipairs(self.spec) do
        local url = spec[1] --[[@as string]]
        if url:find(name, 0, true) then
            return spec
        end
    end
    return nil
end

M.add = function(self, url, opts, spec)
    local plugin = {
        url,
        opts = opts or {},
        cond = function()
            return not CFG.is_pager()
        end,
    }
    for k, v in pairs(spec or {}) do
        plugin[k] = v
    end
    plugin.pre = {
        insert = function(s, fn)
            table.insert(s, fn)
        end,
    }
    plugin.post = {
        insert = function(s, fn)
            table.insert(s, fn)
        end,
    }
    plugin.config = function(p, o)
        for _, fn in ipairs(p.pre) do
            o = fn(o)
        end
        if p.setup ~= false then
            if not p.main then
                p.main = p.name:gsub(".nvim", "")
            end
            require(p.main).setup(o)
        end
        for _, fn in ipairs(p.post) do
            fn()
        end
    end
    table.insert(self.spec, plugin)
    return plugin
end

return M
