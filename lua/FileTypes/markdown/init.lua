local ft = "md"
local filetype = "markdown"
---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "iwes"
CFG.aucmd:on(
    "FileType", function(args)
        vim.lsp.start(
            {
                name = lsp,
                cmd = {
                    lsp,
                },
                filetypes = {
                    filetype,
                },
                root_dir = vim.fs.root(
                    args.buf, {
                        ".iwe",
                    }
                ),
                flags = {
                    debounce_text_changes = 500,
                },
            }
        )
    end, {
        pattern = "markdown",
    }
)

