---
--- === Tables ===
---
function OL.iter(tbl)
    if type(tbl) == "table" then
        if vim.islist(tbl) then
            return ipairs(tbl)
        end
        return pairs(tbl)
    end
    return tbl
end

function OL.contains(tbl, key, val)
    if type(tbl) == "table" then
        local function _contains(v)
            if vim.islist(tbl) then
                return vim.list_contains(tbl, v)
            else
                return vim.tbl_contains(tbl, v)
            end
        end
        return _contains(key) and (val ~= nil and _contains(val))
    end
    return false
end

function OL.pack(...)
    local args = table.pack(...)
    if #args == 1 and type(args[1]) == "table" then
        return args[1]
    end
    return args
end

OL.unpack = function(tbl)
    if not vim.islist(tbl) then
        return tbl
    end
    return table.unpack(tbl)
end

function OL.flatten(...)
    local flat = {}
    local args = OL.pack(...)
    for _, arg in pairs(args) do
        if type(arg) == "table" then
            if vim.islist(arg) then
                vim.list_extend(flat, OL.flatten(arg))
            else
                for _, v in ipairs(arg) do
                    vim.list_extend(flat, OL.flatten(v))
                end
            end
        else
            flat[#flat + 1] = arg
        end
    end
    return flat
end

function OL.unique(tbl)
    local islist = vim.islist(tbl)
    local rtn = {}
    for key, val in OL.iter(tbl) do
        if islist and not OL.contains(rtn, val) then
            table.insert(rtn, val)
        elseif not OL.contains(rtn, key) then
            rtn[key] = val
        end
    end
    return rtn
end

