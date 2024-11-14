OL.paths.coding = "coding"

OL.load("mason", {from = OL.paths.coding})

OL.loadall("*", {from = OL.paths.coding, exclude = {"init", "mason"}})
