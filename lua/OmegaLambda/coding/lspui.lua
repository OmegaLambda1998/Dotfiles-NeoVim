OL.map(
    {
        "<leader>d",
        group = "Diagnostics",
        desc = "Diagnostics",
    }
)

---
--- === Inlay Hints ===
---

local function inlay_hints()
    local spec, opts = OL.spec:add("felpafel/inlay-hint.nvim")
    spec.branch = "nightly"
    spec.event = {
        "LspAttach",
    }
    opts.virt_text_pos = "inline"
    ---comment
    ---@param line_hints lsp.InlayHint[]
    ---@param options table
    ---@param bufnr integer
    ---@return table
    function opts.display_callback(line_hints, options, bufnr)
        if options.virt_text_pos == "inline" then
            local lhint = {}
            for _, hint in pairs(line_hints) do
                local line = vim.api.nvim_win_get_cursor(0)[1]
                if hint.position.line == line - 1 then
                    -- Skip adding hint if it occurs on the same line as the cursor
                    goto continue
                end
                local text = ""
                local label = hint.label
                if type(label) == "string" then
                    text = label
                else
                    for _, part in ipairs(label) do
                        text = text .. part.value
                    end
                end
                if hint.paddingLeft then
                    text = " " .. text
                end
                if hint.paddingRight then
                    text = text .. " "
                end
                lhint[#lhint + 1] = {
                    text = text,
                    col = hint.position.character,
                }
                ::continue::
            end
            return lhint
        elseif options.virt_text_pos == "eol" or options.virt_text_pos ==
            "right_align" then
            local k1 = {}
            local k2 = {}
            table.sort(
                line_hints, function(a, b)
                    return a.position.character < b.position.character
                end
            )
            for _, hint in pairs(line_hints) do
                local line = vim.api.nvim_win_get_cursor(0)[1]
                if hint.position.line == line - 1 then
                    -- Skip adding hint if it occurs on the same line as the cursor
                    goto continue
                end
                local label = hint.label
                local kind = hint.kind
                local node = kind == 1 and vim.treesitter.get_node(
                    {
                        bufnr = bufnr,
                        pos = {
                            hint.position.line,
                            hint.position.character - 1,
                        },
                    }
                ) or nil
                local node_text = node and
                                      vim.treesitter
                                          .get_node_text(node, bufnr, {}) or ""
                local text = ""
                if type(label) == "string" then
                    text = label
                else
                    for _, part in ipairs(label) do
                        text = text .. part.value
                    end
                end
                if kind == 1 then
                    k1[#k1 + 1] = text:gsub(":%s*", node_text .. ": ")
                else
                    k2[#k2 + 1] = text:gsub(":$", "")
                end
                ::continue::
            end
            local text = ""
            if #k2 > 0 then
                text = "<- (" .. table.concat(k2, ",") .. ")"
            end
            if #text > 0 then
                text = text .. " "
            end
            if #k1 > 0 then
                text = text .. "=> " .. table.concat(k1, ", ")
            end

            return text
        end
        return nil
    end

    OL.aucmd(
        "InlayHint", {
            {
                "CursorMoved",
                "CursorMovedI",
            },
            function(_)
                if not OL.is_pager() then
                    OL.load(
                        "inlay-hint", {}, function(hint)
                            if hint and hint.is_enabled and hint.is_enabled() then
                                hint.enable()
                            end
                        end
                    )
                end
            end,
        }
    )
end
inlay_hints()

---
--- === Winbar Context ===
---
local function barbecue()
    OL.callbacks.colourscheme.barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
    }

    OL.spec:add("SmiteshP/nvim-navic")
    local spec, opts = OL.spec:add("utilyre/barbecue.nvim")
    opts.create_autocmd = false
    spec.event = {
        "LspAttach",
    }

    function spec.config(_, o)
        OL.load_setup("barbecue", {}, o)
        vim.api.nvim_create_autocmd(
            {
                "WinResized", -- or WinResized on NVIM-v0.9 and higher
                "BufWinEnter",
                "CursorHold",
                "InsertLeave",
            }, {
                group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                callback = function()
                    require("barbecue.ui").update()
                end,
            }
        )
    end

    opts.theme = "catppuccin"
end

barbecue()

---
--- === Code Actions ===
---
local function action_preview()

    OL.spec:add(
        "MunifTanjim/nui.nvim", {
            config = function(_, o)
            end,
        }
    )

    local spec, opts = OL.spec:add("aznhe21/actions-preview.nvim")
    spec.keys = {
        {
            "<leader>a",
            function()
                return OL.load(
                    "actions-preview", {}, function(ap)
                        return ap.code_actions()
                    end

                )
            end,
            desc = "Code Action",
        },
        {
            "<leader>da",
            function()
                return OL.load(
                    "actions-preview", {}, function(ap)
                        return ap.code_actions()
                    end

                )
            end,
            desc = "Code Action",
        },
    }

    OL.map(
        {
            group = "Diagnostics",
            spec.keys,
        }
    )
end

action_preview()

---
--- === Hover ===
---
local function hover()
    local spec, opts = OL.spec:add("lewis6991/hover.nvim")

    spec.keys = {
        {
            "K",
            function()
                OL.load(
                    "hover", {}, function(hvr)
                        hvr.hover()
                    end

                )
            end,
            desc = "Hover",
        },
        {
            "<C-K>",
            function()
                local hover_win = vim.b.hover_preview
                if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                    vim.api.nvim_set_current_win(hover_win)
                end
            end,
            desc = "Next Source",
        },
    }

    opts.title = true
    opts.preview_window = false

    opts.providers = {
        "diagnostic",
        "fold_preview",
        "gh",
        "gh_user",
        "lsp",
        "man",
    }

    opts.init = function()
        for _, provider in ipairs(opts.providers) do
            OL.load("hover.providers." .. provider)
        end
        OL.map(
            {
                group = "Diagnostics",
                spec.keys,
            }
        )
    end

end

hover()
