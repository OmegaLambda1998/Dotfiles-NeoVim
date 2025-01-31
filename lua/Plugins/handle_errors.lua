local he = CFG.spec:add("aaron-p1/handle_errors.nvim")

he.lazy = false
he.build = "make"
he.setup = false

he.post:insert(
    function()
        local handle_errors = require("handle_errors")
        handle_errors.set_on_error(
            function(msg, ismultiline)
                --- Ignore blink.cmp errors
                if not msg:find("blink.cmp", 0, true) then
                    vim.print(msg)
                end
            end, true
        )
    end
)
