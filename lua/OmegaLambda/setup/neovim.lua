---
--- === NeoVim ===
---

---
--- --- Auto Commands ---
---

function OL.augroup(name, opts)
	if opts == nil or opts.clear == nil then
		opts = {clear = true}
	end
	name = "OL" .. name:gsub("^%l", string.upper)
	return vim.api.nvim_create_augroup(name, opts)
end

function OL.autocmd(events, callback, opts)
	if type(events) == "string" then
		events = {events}
	end
	events = OL.flatten(events)

	if opts == nil then opts = {} end
	if opts.group == nil then opts.group = "autocmd" end
	if type(opts.group) == "string" then opts.group = OL.augroup(opts.group) end
	
	opts.callback = callback

	vim.api.nvim_create_autocmd(events, opts)
end

OL.callbacks.autocommands = OLCall.new()
OL.callbacks.post:add(OL.callbacks.autocommands)
function OL.aucmd(name, ...)
	local cmds = OL.pack(...)
	local events, callback, opts
	for _, cmd in ipairs(cmds) do
		OL.callbacks.autocommands:add(function()
			events = cmd["events"] or cmd[1]	
			callback = cmd["callback"] or cmd[2]
			opts = {}
			for k, v in pairs(cmd) do
				if not vim.tbl_contains({"events", "callback", 1, 2}, k) then
					opts[k] = v
				end
			end
			if opts.group == nil then opts.group = OL.augroup(name) end
			OL.autocmd(events, callback, opts)		
		end)
	end
end

OL.events = OLConfig.new()
function OL.events.trigger(event)
	vim.api.nvim_exec_autocmds("User", {pattern = event})	
end

OL.events.callback_pre = "OLCallbackPre"
OL.callbacks.pre.event = OL.events.callback_pre
OL.events.callback_post = "OLCallbackPost"
OL.callbacks.post.event = OL.events.callback_post
OL.events.init_end = "OLInitEnd"

OL.aucmd("init", {{
	"User",
	function() OL.log:flush() end,
	pattern = OL.events.init_end
}})

---
--- --- User Commands ---
---


---
--- --- Keymaps ---
---

function OL.map(...)
	local args = OL.pack(...)
	OL.callbacks.post:add(function()
		OL.load("which-key", {}, function(wk)
			wk.add(OL.unpack(args))
		end)
	end)
end

---
--- --- Settings ---
---

function OL.opt(key, val, opts)
	if val == nil then
		val = true
	end
	if opts == nil then
		opts = {}
	end
	local set = vim.opt
	if opts.gopt then
		set = vim.opt_global
	elseif opts.lopt then
		set = vim.opt_local
	elseif opts.g then
		set = vim.g
	end
	OL.callbacks.post:add(function()
		set[key] = val
	end)
end

function OL.gopt(key, val)
	OL.opt(key, val, {gopt = true})
end

function OL.lopt(key, val)
	OL.opt(key, val, {lopt = true})
end

function OL.g(key, val)
	OL.opt(key, val, {g = true})
end
