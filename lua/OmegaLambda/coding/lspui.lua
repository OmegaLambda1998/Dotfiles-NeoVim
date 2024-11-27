OL.map(
    {
        "<leader>d",
        group = "Diagnostics",
        desc = "Diagnostics",
    }
)

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
    spec.event = {
        "LspAttach",
    }

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
            end
,
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
            end
,
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
            end
,
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
            end
,
            desc = "Hover",
        },
        {
            "<C-K>",
            function()
                local hover_win = vim.b.hover_preview
                if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                    vim.api.nvim_set_current_win(hover_win)
                end
            end
,
            desc = "Next Source",
        },
    }

    opts.title = true
    opts.preview_window = false

    opts.providers = {
        "diagnostic",
        "dictionary",
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
