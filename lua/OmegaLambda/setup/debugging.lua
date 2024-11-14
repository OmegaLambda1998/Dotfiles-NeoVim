---
--- === Debugging ===
---

---
--- === Logging ===
---

function OL.debug(msg, ...)
	if OL.verbose then
		vim.print(string.format(msg, ...))
	end
end

---
--- === Error Handling ===
---

function OL.try(fn, args)
	args.args = table.unpack(args.args or {})
	local ok, result = xpcall(fn, debug.traceback, args.args)
	if not ok then
		if not args.callback then
			if args.strict then
				error(result)
			else
				vim.notify(result, vim.log.levels.WARN)
			end
		else
			args.callback(result)
		end
	end
	return result
end
