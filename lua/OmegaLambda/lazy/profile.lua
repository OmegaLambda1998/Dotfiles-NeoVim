local spec, opts = OL.spec:add("stevearc/profile.nvim")

spec.cond = OL.should_profile
spec.lazy = not OL.should_profile

function spec.config(_, o)
    if OL.should_profile then
        local profile = OL.load("profile")
        profile.instrument_autocmds()
        if OL.should_profile:lower():match("^start") then
            profile.start("*")
        else
            profile.instrument("*")
        end
    end

    function OL.toggle_profile(file)
        local prof = require("profile")
        if prof.is_recording() then
            prof.stop()
            if file == nil then
                vim.ui.input(
                    {
                        prompt = "Save profile to:",
                        completion = "file",
                        default = "profile.json",
                    }, function(filename)
                        if filename then
                            prof.export(filename)
                            vim.notify(string.format("Wrote %s", filename))
                        end
                    end
                )
            else
                prof.export(file)
                vim.notify(string.format("Wrote %s", file))
            end
        else
            prof.start("*")
        end
    end

    vim.keymap.set("", "<f1>", OL.toggle_profile)
end
