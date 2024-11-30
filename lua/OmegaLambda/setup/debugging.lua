---
--- === Debugging ===
---
---
--- --- Logging ---
---
--- Better Inspect
--- Stolen from Snacks.nvim, but removed the notification
function OL.inspect(...)
    local obj = OL.pack(...)
    local len = #obj
    local caller = debug.getinfo(1, "S")
    for level = 2, 10 do
        local info = debug.getinfo(level, "S")
        if info and info.source ~= caller.source and info.what == "Lua" and
            info.source ~= "lua" and info.source ~= "@" .. vim.env.MYVIMRC then
            caller = info
            break
        end
    end
    local title = vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" ..
                      caller.linedefined
    local str = len == 1 and obj[1] or obj
    return type(str) == "string" and str or vim.inspect(str), title
end

--- Allow overwriting of notify function
function OL:update_notify(fn)
    OL.notify = fn
end
OL:update_notify(vim.notify)

--- Log Levels
local TRACE = vim.log.levels.TRACE
local DEBUG = vim.log.levels.DEBUG
local INFO = vim.log.levels.INFO
local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR
local OFF = vim.log.levels.OFF

function OL.fstring(msg, ...)
    local title
    if type(msg) == "string" then
        msg = string.format(msg, OL.unpack(OL.flatten(...)))
    end
    msg, title = OL.inspect(msg)
    return msg, title
end

---@class OLLog: OLConfig
---@field level integer
---@field min_level integer
local OLLog = OL.OLConfig.new({})

OLLog.TRACE = TRACE
OLLog.DEBUG = DEBUG
OLLog.INFO = INFO
OLLog.WARN = WARN
OLLog.ERROR = ERROR
OLLog.OFF = OFF
OLLog.levels = {
    TRACE = "trace",
    DEBUG = "debug",
    INFO = "info",
    WARN = "warn",
    ERROR = "error",
    OFF = "off",
}
OL.OLLog = OLLog

function OLLog.new(tbl)
    if tbl == nil then
        tbl = {}
    end
    if tbl.level == nil then
        if OL.verbose then
            tbl.level = INFO
            tbl.min_level = DEBUG
        else
            tbl.level = WARN
            tbl.min_level = INFO
        end
    end
    if tbl.queue == nil then
        tbl.queue = {}
    end
    return OL.OLConfig.new(tbl, OLLog)
end

function OLLog:log(level, msg, ...)
    local str, title = OL.fstring(msg, ...)
    if self.level <= level then
        OL.notify(
            str, {
                level = level,
                title = title,
            }
        )
    else
        self.queue[#self.queue + 1] = {
            msg = str,
            level = level,
            title = title,
        }
    end
end

function OLLog:flush(all)
    local queue = {}
    local str, level, title
    for _, msg in ipairs(self.queue) do
        str = msg.msg
        level = msg.level
        title = msg.title
        if all or self.min_level <= level then
            OL.notify(
                str, {
                    level = level,
                    title = title,
                }
            )
        else
            queue[#queue + 1] = {
                msg = str,
                level = level,
                title = title,
            }
        end
    end
    self.queue = queue
end

function OLLog:trace(msg, ...)
    self:log(TRACE, msg, ...)
end

function OLLog:debug(msg, ...)
    self:log(DEBUG, msg, ...)
end

function OLLog:info(msg, ...)
    self:log(INFO, msg, ...)
end

function OLLog:warn(msg, ...)
    self:log(WARN, msg, ...)
end

function OLLog:error(msg, ...)
    self:log(ERROR, msg, ...)
end

function OLLog:off(msg, ...)
    self:log(OFF, msg, ...)
end

OL.log = OLLog.new()

---
--- === Error Handling ===
---

function OL.try(fn, args)
    args.args = OL.unpack(args.args or {})
    local f = function()
        if fn == nil then
            error("Function is nil")
        end
        return fn(args.args)
    end
    local ok, result = xpcall(f, debug.traceback)
    if not ok then
        if not args.callback then
            if args.strict then
                error(result)
            else
                OL.log:error(result)
            end
        else
            args.callback(result)
        end
    end
    return result
end
