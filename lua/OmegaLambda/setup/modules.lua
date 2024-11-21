---
--- === Modules ===
---
---
--- --- Loading ---
---
function OL.load(m, args, callback)

    if args == nil then
        args = {}
    end
    local from = args.from
    if from then
        local path = OL.paths
        if type(from) == "string" and from ~= "root" then
            path = path[from]
        else
            path = from
        end
        m = path:module(m)
    end
    args.args = { m }
    OL.log:trace("Loading %s", m)
    local mod = OL.try(require, args)
    if mod then
        if callback then
            args.args = {
                mod,
            }
            return OL.try(callback, args)
        end
        return mod
    end
    return nil
end

function OL.load_setup(m, args, opts)
    return OL.load(
               m, args, function(mod)
            mod.setup(opts)
        end
           )
end

function OL.loadall(pattern, args)
    local path = OL.paths
    local from = args.from
    if from then
        if type(from) == "string" and from ~= "root" then
            path = path[from]
        else
            path = from
        end
    end
    args.from = nil

    local filters = {}
    local exclude = args.exclude

    if not exclude then
        filters = {
            function(_)
                return false
            end,
        }
    else
        if exclude and type(exclude) ~= "table" then
            exclude = {
                exclude,
            }
        end
        for _, ex in ipairs(exclude) do
            if type(ex) == "function" then
                table.insert(filters, ex)
            elseif type(ex) == "string" then
                table.insert(
                    filters, function(m)
                        local ptn = OL.fstring("^.*%s$", ex)
                        return string.find(m, ptn)
                    end
                )
            end
        end
    end

    local function filter(m)
        for _, f in ipairs(filters) do
            if f(m) then
                return false
            end
        end
        return true
    end

    for m in path:glob(pattern) do
        m = m:gsub("(/[^%.]+)%.lua$", "%1")
        if not string.find(m, "%.[%w]+$") then --- Not a directory or lua file
            m = vim.fs.basename(m)
            m = path:module(m)
            if filter(m) then
                OL.load(m, args)
            end
        end
    end
end
