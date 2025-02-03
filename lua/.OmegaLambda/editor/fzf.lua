local spec, opts = OL.spec:add("ibhagwan/fzf-lua", {})

OL.callbacks.colourscheme.fzf = true

spec.cmd = {
    "FzfLua",
}

opts[1] = "default-title"

opts.winopts = {
    fullscreen = true,
    preview = {
        wrap = "wrap",
    },
}

opts.diagnostics = {
    multiline = true,
}

local function fzf_cmd(cmd, use_cwd)
    return function()
        local roots = OL.get_roots()
        local cwd
        if use_cwd then
            cwd = roots.cwd
        else
            cwd = roots.lsp or roots.root or roots.cwd
        end
        if type(cwd) == "table" then
            cwd = cwd[1]
        end
        OL.load(
            "fzf-lua", {}, function(fzf)
                fzf[cmd](
                    {
                        cwd = cwd,
                    }
                )
            end
        )
    end
end

spec.keys = {
    {
        "<leader>zf",
        fzf_cmd("files"),
        desc = "Open Files",
    },
    {
        "<leader>zh",
        fzf_cmd("oldfiles"),
        desc = "Open Recent Files",
    },
    {
        "<leader>zg",
        fzf_cmd("live_grep_native"),
        desc = "Grep Project",
    },
    {
        "<leader>dw",
        fzf_cmd("diagnostics_workspace"),
        desc = "Workspace Diagnostics",
    },
    {
        "<leader>dd",
        fzf_cmd("diagnostics_document"),
        desc = "Document Diagnostics",
    },
}

OL.map(
    {
        "<leader>z",
        group = "FzF",
        desc = "FzF",
        { spec.keys },
    }
)
