OL.spec:add("williamboman/mason-lspconfig.nvim", {config = function() end})
local lsp_index, lsp_spec, lsp_opts = OL.spec:add("neovim/nvim-lspconfig")

OL.callbacks.lsp = OLConfig.new()
OL.callbacks.lsp.ft = OLConfig.new()

lsp_spec.event = OL.callbacks.lsp.ft

--- Diagnostics
local icons = {
    [vim.diagnostic.severity.ERROR] = " ",
    [vim.diagnostic.severity.WARN] = " ",
    [vim.diagnostic.severity.HINT] = " ",
    [vim.diagnostic.severity.INFO] = " "
}

lsp_opts.diagnostics = {
    enabled = true,
    underline = true,
    virtual_text = {
        source = "if_many",
        spacing = 4,
        prefix = function(diagnostic) return icons[diagnostic.severity] end
    },
    signs = {text = icons},
    float = {severity_sort = true, source = "if_many"},
    update_in_insert = false,
    severity_sort = true,
    jump = {}
}

--- Inlay Hints
OL.callbacks.lsp.inlay_hints_exclude = OLConfig.new()
lsp_opts.inlay_hints = {
    enabled = true,
    exclude = OL.callbacks.lsp.inlay_hints_exclude
}

--- Code Lens
lsp_opts.codelens = {enabled = false}

--- Document Highlight
lsp_opts.document_highlight = {enabled = true}

--- Global Capabilities
lsp_opts.capabilities = {
    workspace = {fileOperations = {didRename = true, willRename = true}}
}

--- Servers
OL.callbacks.lsp.servers = OLConfig.new()
lsp_opts.servers = OL.callbacks.lsp.servers

---
--- --- Setup ---
---

--- Diagnostics
local function setup_diagnostics(opts) vim.diagnostic.config(vim.deepcopy(opts)) end

--- Inlay Hints
local function setup_inlay_hints(opts)
    OL.aucmd("lsp", {
        {
            "LspAttach", function(ctx)
                local client = vim.lsp.get_client_by_id(ctx.data.client_id)
                if client.supports_method("textDocument/inlayHint") then
                    local buffer = ctx.buf
                    if vim.api.nvim_buf_is_valid(buffer) and
                        vim.bo[buffer].buftype == "" and
                        not vim.tbl_contains(opts.inlay_hints.exclude,
                                             vim.bo[buffer].filetype) then
                        vim.lsp.inlay_hint.enable(true, {bufnr = buffer})
                    end
                end
            end
        }
    })
end

--- Code Lens
local function setup_codelens(opts)
    if vim.lsp.codelens then
        OL.aucmd("lsp", {
            {
                "LspAttach", function(ctx)
                    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
                    if client.supports_method("textDocument/codeLens") then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({
                            "BufEnter", "CursorHold", "InsertLeave"
                        }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh
                        })
                    end
                end
            }
        })
    end
end

--- Capabilities
local function setup_capabilities(opts)
    local blink = OL.load("blink.cmp")
    local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol
                                                 .make_client_capabilities(),
                                             blink.get_lsp_capabilities(), opts)
    return capabilities
end

--- Servers
local function setup_server(server, server_opts, capabilities)
    if server_opts.enabled == false then return end
    local lsp = OL.load("lspconfig")
    local opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities)
    }, server_opts)
    lsp[server].setup(opts)
end

local function setup_servers(servers, capabilities)
    --- get all the servers that are available through mason-lspconfig
    local all_mslp_servers = vim.tbl_keys(OL.load(
                                              "mason-lspconfig.mappings.server")
                                              .lspconfig_to_package)

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
        if server_opts then
            server_opts = server_opts == true and {} or server_opts
            if server_opts.enabled ~= false then
                --- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                if server_opts.mason == false or
                    not vim.tbl_contains(all_mslp_servers, server) then
                    setup_server(server, server_opts, capabilities)
                else
                    ensure_installed[#ensure_installed + 1] = server
                end
            end
        end
    end
    OL.load_setup("mason-lspconfig", {}, {
        ensure_installed = ensure_installed,
        handlers = {
            function(server)
                local server_opts = servers[server]
                return setup_server(server, server_opts, capabilities)
            end
        }
    })
end

function lsp_spec.config(_, opts)
    if opts.diagnostics.enabled then setup_diagnostics(opts.diganostics) end
    if opts.inlay_hints.enabled then setup_inlay_hints(opts.inlay_hints) end
    if opts.codelens.enabled then setup_codelens(opts.codelens) end
    local capabilities = setup_capabilities(opts.capabilities)
    setup_servers(opts.servers, capabilities)
end
