OL.g("deprecation_warnings", false)

OL.opt("autowrite")
OL.opt("confirm")

OL.opt("expandtab")
OL.opt("shiftround")
OL.opt("shiftwidth", 4)

OL.opt("undofile")
OL.opt("undolevels", 10000)
OL.opt("updatetime", 100)
OL.opt("timeoutlen", 100)

OL.opt("virtualedit", "block")

OL.opt("showmode", false)
OL.opt("showcmd", false)

--- l use "999L, 888B" instead of "999 lines, 888 bytes"
--- m use "[+]" instead of "[Modified]"
--- r use "[RO]" instead of "[readonly]"
--- w use "[w]" instead of "written" for file write message
---     and "[a]" instead of "appended" for ':w >> file' command
--- a all of the above abbreviations
--- o overwrite message for writing a file with subsequent
---     message for reading a file (useful for ":wn" or when
---     'autowrite' on)
--- O message for reading a file overwrites any previous
---     message; also for quickfix message (e.g., ":cn")
--- s don't give "search hit BOTTOM, continuing at TOP" or
---     "search hit TOP, continuing at BOTTOM" messages; when using
---     the search count do not show "W" before the count message
--- t truncate file message at the start if it is too long
---     to fit on the command-line, "<" will appear in the left most
---     column; ignored in Ex mode
--- T truncate other messages in the middle if they are too
---     long to fit on the command line; "..." will appear in the
---     middle; ignored in Ex mode
--- W don't give "written" or "[w]" when writing a file
--- A don't give the "ATTENTION" message when an existing
---     swap file is found
--- I don't give the intro message when starting Vim
--- c don't give ins-completion-menu messages; for
---     example, "-- XXX completion (YYY)", "match 1 of 2", "The only
---     match", "Pattern not found", "Back at original", etc.
--- C don't give messages while scanning for ins-completion
---     items, for instance "scanning tags"
--- q do not show "recording @a" when recording a macro
--- F don't give the file info when editing a file, like
---     :silent was used for the command; note that this also
---     affects messages from 'autoread' reloading
--- S do not show search count message when searching, e.g.
---     "[1/5]". When the "S" flag is not present (e.g. search count
---     is shown), the "search hit BOTTOM, continuing at TOP" and
---     "search hit TOP, continuing at BOTTOM" messages are only
---     indicated by a "W" (Mnemonic: Wrapped) letter before the
---     search count statistics.
OL.opt("shortmess", "aoOstTWAIcCqFS")
