local ft = "md"
local filetype = "markdown"

vim.list_extend(
    CFG.treesitter.ensure_installed, {
        "markdown",
        "markdown_inline",
    }
)

---
--- === KMS ===
---

local KMdS = CFG.spec:add("OmegaLambda1998/KMdS.nvim")
KMdS.ft = { filetype }
KMdS.dev = true
KMdS.dependencies = {
    "nvim-neotest/nvim-nio",
}

---
--- === CMP ===
---

local render = CFG.spec:add("MeanderingProgrammer/render-markdown.nvim")
render.ft = {
    filetype,
}
CFG.cmp.sources[filetype] = {
    filetype,
}
CFG.cmp.providers[filetype] = {
    name = "RenderMarkdown",
    module = "render-markdown.integ.blink",
}
CFG.cmp:ft(ft)

---
--- === Overseer ===
---
-- local function get_lsp_root_dir()
--     local clients = vim.lsp.get_clients(
--         { bufnr = 0 }
--     )
--     if clients and #clients > 0 then
--         for _, client in ipairs(clients) do
--             if client.config.root_dir then
--                 return client.config.root_dir
--             end
--         end
--     end
-- end
--
-- table.insert(CFG.overseer.ft, filetype)
-- CFG.overseer.templates[filetype] = {
--     name = "IWE index to readme",
--     builder = function(_)
--         local cwd = vim.fs.joinpath(
--             get_lsp_root_dir() or vim.fn.getcwd(), ".iwe"
--         )
--         return {
--             cmd = "iwe squash --key index > '../README.md'",
--             cwd = cwd,
--         }
--     end,
--     condition = {
--         filetype = {
--             filetype,
--         },
--         callback = function(_)
--             local cwd = vim.fs.joinpath(
--                 get_lsp_root_dir() or vim.fn.getcwd(), ".iwe"
--             )
--             return vim.uv.fs_stat(cwd)
--         end,
--     },
-- }
