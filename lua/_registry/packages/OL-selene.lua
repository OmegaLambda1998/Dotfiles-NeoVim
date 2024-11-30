local Pkg = require("mason-core.package")
local _ = require("mason-core.functional")
local cargo = require("mason-core.managers.cargo")
local selene = Pkg.new(
    {
        name = "OL-selene",
        desc = "A blazing-fast modern Lua linter written in Rust.",
        homepage = "https://kampfkarren.github.io/selene/",
        languages = {
            Pkg.Lang.Lua,
            Pkg.Lang.Luau,
        },
        categories = {
            Pkg.Cat.Linter,
        },
        install = cargo.crate(
            "selene", {
                git = {
                    url = "https://github.com/Kampfkarren/selene",
                },
                bin = {
                    "selene",
                },
                features = "selene-lib/luajit",
            }
        ),
    }
)
return selene
