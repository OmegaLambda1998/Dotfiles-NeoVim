--- Check if we need to reload the file when it changed
CFG.aucmd:on(
    {
        "FocusGained",
        "TermClose",
        "TermLeave",
    }, function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end, {
        group = "checktime",
    }
)

--- Highlight on yank
CFG.aucmd:on(
    "TextYankPost", function()
        (vim.hl or vim.highlight).on_yank()
    end, {
        group = "highlight_yank",
    }
)

--- Resize splits if window got resized
CFG.aucmd:on(
    { "VimResized" }, function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end, {
        group = "resize_splits",
    }
)

--- Go to last loc when opening a buffer
CFG.aucmd:on(
    "BufReadPost", function(event)
        local exclude = {
            "gitcommit",
        }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or
            vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, "\"")
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end, {
        group = "last_loc",
    }
)

--- Close some filetypes with <q>
CFG.aucmd:on(
    "FileType", function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(
            function()
                vim.keymap.set(
                    "n", "q", function()
                        vim.cmd("close")
                        pcall(
                            vim.api.nvim_buf_delete, event.buf, {
                                force = true,
                            }
                        )
                    end, {
                        buffer = event.buf,
                        silent = true,
                        desc = "Quit buffer",
                    }
                )
            end
        )
    end, {
        group = "close_with_q",
        pattern = {
            "PlenaryTestPopup",
            "checkhealth",
            "dbout",
            "gitsigns-blame",
            "grug-far",
            "help",
            "lspinfo",
            "neotest-output",
            "neotest-output-panel",
            "neotest-summary",
            "notify",
            "qf",
            "spectre_panel",
            "startuptime",
            "tsplayground",
        },
    }
)

--- Make it easier to close man-files when opened inline
CFG.aucmd:on(
    "FileType", function(event)
        vim.bo[event.buf].buflisted = false
    end, {
        group = "man_unlisted",
        pattern = {
            "man",
        },
    }
)

--- Auto create dir when saving a file, in case some intermediate directory does not exist
CFG.aucmd:on(
    { "BufWritePre" }, function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end, {
        group = "auto_create_dir",
    }
)

