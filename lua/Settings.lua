--- Leader keys
CFG.set:g("mapleader", ",")
CFG.set:g("maplocalleader", ".")

--- Virtual edit
--- +block: Allow virtual editing in visual block mode
--- +onemore: Allow the cursor to move one extra character past the last
CFG.set:opt("virtualedit", "block,onemore")

--- Saving
CFG.set:opt("autowrite") --- Write content of file when leaving file
CFG.set:opt("confirm") --- Confirm save instead of failing

--- Undo
CFG.set:opt("undofile")
CFG.set:opt("undolevels", 10000)

--- Timings
CFG.set:opt("updatetime", 300) --- Save to swap file, and trigger CursorHold events
CFG.set:opt("timeoutlen", 100) --- Wait for a mapped sequence to complete

--- Concealing
CFG.set:opt("conceallevel", 2)

--- Wrap
CFG.set:opt("breakindent") --- Indent wraps
CFG.set:opt("linebreak") --- Break on words instead of characters
CFG.set:opt("showbreak", "⤷ ") --- Show before wrapped text

--- Jump
--- +stack: Going back in jumplist then jumping somewhere else starts a new jumplist
--- +view: Try to jump back to the same view as mark
CFG.set:opt("jumpoptions", "stack,view")

--- Search
CFG.set:opt("ignorecase") --- Ignore case in search pattern
CFG.set:opt("smartcase") --- Unless search pattern contains upper case characters

--- Indentation
CFG.set:opt("shiftwidth", 4) --- Number of blanks to insert per indent
CFG.set:opt("smarttab") --- <Tab> inserts `shiftwidth` blanks
CFG.set:opt("expandtab") --- <Tab> inserts spaces instead of tabs
CFG.set:opt("shiftround") --- Round indent to multiple of shiftwidth

--- Status column
CFG.set:opt("number")

--- Splits
CFG.set:opt("splitbelow")
CFG.set:opt("splitright")

--- Cursorline
CFG.set:opt("cursorline")

--- Scrolling
CFG.set:opt("smoothscroll")

--- Show
CFG.set:opt("showmode")
CFG.set:opt("showcmd")

--- Treat _ as a word break
CFG.set:opt("iskeyword", "_", "remove")
