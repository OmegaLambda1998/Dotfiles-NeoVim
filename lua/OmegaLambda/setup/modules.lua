---
--- === Modules ===
---

---
--- --- Loading ---
---

function OL.load(m, args)
	local from = args.from
	if from ~= nil then
		local path = OL.paths
		if from ~= "root" then
			path = path[from]
		end
		m = path:module(m)
	end
	args.args = {m}
	OL.debug("Loading %s", m)
	return OL.try(require, args)
end

function OL.loadall(pattern, args)
	local path = OL.paths
	local from = args.from
	if from and from ~= "root" then
		path = path[from]
	end
	args.from = nil
	
	local filters = {}
	local exclude = args.exclude

	if not exclude then
		filters = {function(m) return false end}
	else
		if exclude and type(exclude) ~= "table" then
			exclude = {exclude}
		end
		for _, ex in ipairs(exclude) do
			if type(ex) == "function" then
				table.insert(filters, ex)
			elseif type(ex) == "string" then
				table.insert(filters, function(m)
					return string.find(m, "^.*" .. ex)
				end)
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
		m = path:module(vim.fs.basename(m))
		if filter(m) then
			OL.load(m, args)
		end
	end
end
