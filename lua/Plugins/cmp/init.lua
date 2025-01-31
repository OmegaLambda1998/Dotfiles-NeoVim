local blink = CFG.spec:add("saghen/blink.cmp")

--- blink.cond = false

blink.build = "cargo build --release"
blink.event = {
    "CmdlineEnter",
}
