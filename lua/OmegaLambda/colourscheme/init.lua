OL.paths.colourscheme = "colourscheme"

local index, spec, opts = OL.spec:add("catppuccin/nvim")
spec.name = "catppuccin"
spec.main = "catppuccin"
spec.priority = 1000

opts.flavour = "mocha"
opts.background = {
	light = "macchiato",
	dark = "mocha",
}
opts.transparent_background = true
opts.default_integrations = false

OL.callbacks.colourscheme = OLConfig.new()
opts.integrations = OL.callbacks.colourscheme

OL.callbacks.post:add(function()
	vim.cmd.colorscheme("catppuccin")
end)

OL.loadall("*", {from=OL.paths.colourscheme, exclude = {"init"}})
