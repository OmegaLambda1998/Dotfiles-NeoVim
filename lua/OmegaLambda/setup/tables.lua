---
--- === Tables ===
---
function OL.is_array(tbl)
    if type(tbl) ~= "table" then
        return false
    end
    local i = 0
    for _ in pairs(tbl) do
        i = i + 1
        if tbl[i] == nil then
            return false
        end
    end
    return true
end


function OL.is_dict(tbl)
    if type(tbl) ~= "table" then
        return false
    end
    return not OL.is_array(tbl)
end


function OL.iter(tbl)
    if OL.is_array(tbl) then
        return ipairs(tbl)
    elseif OL.is_dict(tbl) then
        return pairs(tbl)
    end
    return tbl
end


function OL.contains(tbl, key, val)
    local function _contains(v)
        if OL.is_array(tbl) then
            return vim.list_contains(tbl, val)
        elseif OL.is_dict(tbl) then
            return vim.tbl_contains(tbl, val)
        end
        return false
    end

    return _contains(key) and (val ~= nil and _contains(val))
end


function OL.pack(...)
    local args = table.pack(...)
    if #args == 1 and type(args[1]) == "table" then
        return args[1]
    end
    return args
end


OL.unpack = function(tbl)
    if not OL.is_array(tbl) then
        return tbl
    end
    return table.unpack(tbl)
end


function OL.flatten(...)
    local flat = {}
    local args = OL.pack(...)
    for _, arg in pairs(args) do
        if type(arg) == "table" then
            if OL.is_array(arg) then
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
    local is_array = OL.is_array(tbl)
    local rtn = {}
    for key, val in OL.iter(tbl) do
        if is_array and not OL.contains(rtn, val) then
            table.insert(rtn, val)
        elseif not OL.contains(rtn, key) then
            rtn[key] = val
        end
    end
    return rtn
end

