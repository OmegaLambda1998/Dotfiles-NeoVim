OL.paths.coding = "coding"

OL.load("mason", {from = OL.paths.coding})
OL.load("lsp", {from = OL.paths.coding})
OL.load("cmp", {from = OL.paths.coding})
OL.load("format", {from = OL.paths.coding})
OL.load("lint", {from = OL.paths.coding})

OL.loadall("*", {
    from = OL.paths.coding,
    exclude = {"init", "mason", "lsp", "cmp", "format", "lint"}
})
