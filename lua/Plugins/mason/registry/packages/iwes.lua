local Pkg = require("mason-core.package")
local _ = require("mason-core.functional")
local cargo = require("mason-core.managers.cargo")

return Pkg.new(
    {
        name = "iwes",
        desc = "A lightning-fast, Neovim extension to supercharge your notes.",
        homepage = "iwe.md",
        languages = {
            Pkg.Lang.Markdown,
        },
        categories = {
            Pkg.Cat.LSP,
        },
        install = function(ctx)
            cargo.install(
                "iwes", {
                    bin = {
                        "iwes",
                    },
                }
            )
            ctx.receipt:with_primary_source(
                {
                    type = "cargo",
                }
            )
        end,
    }
)
