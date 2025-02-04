local ft = "md"
local filetype = "markdown"

---
--- === Appearance ===
---
local render = CFG.spec:add("MeanderingProgrammer/render-markdown.nvim")
render.ft = {
    filetype,
}

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "iwes"
local bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")

CFG.aucmd:on(
    "FileType", function(args)
        vim.lsp.start(
            {
                name = lsp,
                cmd = {
                    vim.fs.joinpath(bin, lsp),
                },
                filetypes = {
                    filetype,
                },
                root_dir = vim.fs.root(
                    args.buf, {
                        ".iwe",
                    }
                ),
                ---@diagnostic disable-next-line: missing-fields
                flags = {
                    debounce_text_changes = 500,
                },
            }
        )
    end, {
        pattern = filetype,
    }
)

---
--- === Overseer ===
---
local function get_lsp_root_dir()
    local clients = vim.lsp.get_clients(
        { bufnr = 0 }
    )
    if clients and #clients > 0 then
        for _, client in ipairs(clients) do
            if client.config.root_dir then
                return client.config.root_dir
            end
        end
    end
end

table.insert(CFG.overseer.ft, filetype)
CFG.overseer.templates[filetype] = {
    name = "IWE index to readme",
    builder = function(params)
        local cwd = vim.fs.joinpath(
            get_lsp_root_dir() or vim.fn.getcwd(), ".iwe"
        )
        return {
            cmd = "iwe squash --key index > '../README.md'",
            cwd = cwd,
        }
    end,
    condition = {
        filetype = {
            filetype,
        },
        callback = function(_)
            local cwd = vim.fs.joinpath(
                get_lsp_root_dir() or vim.fn.getcwd(), ".iwe"
            )
            return vim.uv.fs_stat(cwd)
        end,
    },
}
