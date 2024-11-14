---
--- === Snacks ===
---

local index, spec, opts = OL.spec:add("folke/snacks.nvim")
spec.priority = 1000
spec.lazy = false
OL.callbacks.post:add(function()
	Snacks = OL.load("snacks")
end)

---
--- --- Big Files ---
---

OL.callbacks.bigfile = OLCall.new({
	function(ctx)
		OL.log:trace(ctx)
		OL.log:flush()
	end
})

opts.bigfile = OLConfig.new({
	notify = true, --- Show notification when bigfile detected
	size = 1.5 * 1024 * 1024, --- 1.5MB
	setup = OL.callbacks.bigfile
})

---
--- --- Buf Delete ---
---

---
--- --- Debug ---
---

OL.callbacks.post:add(function()
	vim.print = function(...) Snacks.debug.inspect(...) end
end)

---
--- --- Git ---
---

---
--- --- Git Browse ---
---


---
--- --- Lazy Git ---
---

---
--- --- Notify ---
---

table.insert(OL.callbacks.colourscheme, {notfiy = true})

OL.callbacks.post:add(function()
	OL.notify = function(msg, opts)
		if opts == nil then
			opts = {}
		end
		if opts.title == nil then
			opts.title = "OmegaLambda"
		end
		if opts.level == nil then
			opts.level = vim.log.levels.INFO
		end
		Snacks.notify(msg, opts)
	end
end)

---
--- --- Notifier ---
---

table.insert(OL.callbacks.colourscheme, {notfier = true})

opts.notifier = {
	style = "compact",
}

OL.aucmd("lsp", {
	{"LspProgress", function(ev)
		local progress = vim.defaulttable()
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
	    	if not client or type(value) ~= "table" then
	      		return
	    	end
	    	local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
			  		token = ev.data.params.token,
			  		msg = ("[%3d%%] %s%s"):format(
			    			value.kind == "end" and 100 or value.percentage or 100,
			    			value.title or "",
			    			value.message and (" **%s**"):format(value.message) or ""
			  		),
			  		done = value.kind == "end",
				}
				break
			end
		end

	    	local msg = {} ---@type string[]
	    	progress[client.id] = vim.tbl_filter(function(v)
	      		return table.insert(msg, v.msg) or not v.done
	    	end, p)

	    	local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	    	vim.notify(table.concat(msg, "\n"), "info", {
	      		id = "lsp_progress",
	      		title = client.name,
	      		opts = function(notif)
			notif.icon = #progress[client.id] == 0 and " "
		  		or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
	      		end,
	    	})
	end}
})

---
--- --- Quick File ---
---

opts.quickfile = {
	exclude = OL.callbacks.treesitter.exclude
}

---
--- --- Rename ---
---

---
--- --- Status Column ---
---

OL.opt("number")
OL.opt("relativenumber")
OL.opt("signcolumn", "yes")
opts.statuscolumn = {
	left = {"sign"},
	right = {"fold", "git"},
	folds = {
		open = true,
		git_hl = true,
	},
	git = {
		patterns = { "GitSign", },
	},
	refresh = 50
}

---
--- --- Terminal ---
---

---
--- --- Toggle ---
---

opts.toggle = {
	map = vim.keymap.set,
	which_key = true,
	notify = true,
  	--- icons for enabled/disabled states
  	icon = {
    		enabled = " ",
    		disabled = " ",
  	},
  	--- colors for enabled/disabled states
  	color = {
    		enabled = "green",
    		disabled = "yellow",
  	},
}

---
--- --- Windows ---
---

---
--- --- Words ---
---

opts.words = {
  enabled = true, -- enable/disable the plugin
  debounce = 200, -- time in ms to wait before updating
  notify_jump = false, -- show a notification when jumping
  notify_end = true, -- show a notification when reaching the end
  foldopen = true, -- open folds after jumping
  jumplist = true, -- set jump point before jumping
  modes = { "n", "i", "c" }, -- modes to show references
}
