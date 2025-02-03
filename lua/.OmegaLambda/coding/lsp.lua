---
--- === Mason ===
---
OL.spec:add("williamboman/mason-lspconfig.nvim")

---@class OLMasonLSP: OLConfig
OL.callbacks.mason_lsp = OL.OLConfig.new()
OL.callbacks.mason_lsp.install = OL.OLConfig.new()

---
--- === LSP Config ===
---

local spec, opts = OL.spec:add("neovim/nvim-lspconfig")
spec.dependencies = {
    "williamboman/mason.nvim",
}

vim.lsp.set_log_level(OL.log.level)
OL.load(
    "vim.lsp.log", {}, function(lsp_log)
        lsp_log.set_format_func(vim.inspect)
    end
)

---@class OLLSP: OLConfig
OL.callbacks.lsp = OL.OLConfig.new()
OL.callbacks.lsp.ft = OL.OLConfig.new(
    {
        add = function(self, ft)
            table.insert(self, "BufReadPost *." .. ft)
        end,
    }
)

spec.cmd = {
    "LspInfo",
}
spec.event = OL.callbacks.lsp.ft

---
--- === Colourscheme ===
---

local severity = vim.diagnostic.severity
local icons = {
    [severity.ERROR] = " ",
    [severity.WARN] = " ",
    [severity.HINT] = " ",
    [severity.INFO] = " ",
}

OL.callbacks.colourscheme.semantic_tokens = true

OL.callbacks.colourscheme.native_lsp = {
    enabled = true,
    virtual_text = {
        errors = {
            "italic",
        },
        hints = {
            "italic",
        },
        warnings = {
            "italic",
        },
        information = {
            "italic",
        },
        ok = {
            "italic",
        },
    },
    underlines = {
        errors = {
            "underdouble",
        },
        warnings = {
            "undercurl",
        },
        information = {
            "underdashed",
        },
        hints = {
            "underdotted",
        },
        ok = {
            "underline",
        },
    },
    inlay_hints = {
        background = true,
    },
}

--- Diagnostics
local diag_opts = {
    severity_sort = true,
    source = true,
}
opts.diagnostics = vim.tbl_deep_extend(
    "force", diag_opts, {
        enabled = true,
        underline = diag_opts,
        virtual_text = false,
        signs = {
            text = icons,
        },
        float = diag_opts,
        update_in_insert = true,
        jump = {},
    }
)
opts.diagnostics.jump.float = opts.diagnostics.float

--- Inlay Hints
OL.callbacks.lsp.inlay_hints_exclude = OL.OLConfig.new()
opts.inlay_hints = {
    enabled = true,
    exclude = OL.callbacks.lsp.inlay_hints_exclude,
}

--- Code Lens
opts.codelens = {
    enabled = false,
}

--- Document Highlight
opts.document_highlight = {
    enabled = true,
}

--- Global Capabilities
opts.capabilities = {}

--- Servers
OL.callbacks.lsp.servers = OL.OLConfig.new()
opts.servers = OL.callbacks.lsp.servers
function OL.callbacks.lsp:add(server, o)
    OL.callbacks.lsp.servers[server] = o
end

---
--- --- Setup ---
---

--- Diagnostics
local function setup_diagnostics(o)
    vim.diagnostic.config(vim.deepcopy(o))
end

--- Inlay Hints
local function setup_inlay_hints(o)
    OL.aucmd(
        "lsp", {
            "LspAttach",
            function(ctx)
                local client = vim.lsp.get_client_by_id(ctx.data.client_id)
                if client and client:supports_method("textDocument/inlayHint") then
                    local buffer = ctx.buf
                    if vim.api.nvim_buf_is_valid(buffer) and
                        vim.bo[buffer].buftype == "" and
                        not vim.tbl_contains(o.exclude, vim.bo[buffer].filetype) then
                        vim.lsp.inlay_hint.enable(true)
                    end
                end
            end,
        }
    )
end

--- Code Lens
local function setup_codelens(_)
    if vim.lsp.codelens then
        OL.aucmd(
            "LspAttach", {
                {
                    "LspAttach",
                    function(ctx)
                        local client = vim.lsp
                                           .get_client_by_id(ctx.data.client_id)
                        if client and
                            client:supports_method("textDocument/codeLens") then
                            vim.lsp.codelens.refresh()
                            vim.api.nvim_create_autocmd(
                                {
                                    "BufEnter",
                                    "CursorHold",
                                    "InsertLeave",
                                }, {
                                    buffer = 0,
                                    callback = vim.lsp.codelens.refresh,
                                }
                            )
                        end
                    end,
                },
            }
        )
    end
end

--- Capabilities
local function setup_capabilities(o)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    OL.load(
        "blink.cmp", {}, function(blink)
            capabilities = vim.tbl_deep_extend(
                "force", capabilities, blink.get_lsp_capabilities()
            )
        end

    )
    capabilities = vim.tbl_deep_extend("force", capabilities, o)
    return capabilities
end

--- Servers

OL.spec:add("artemave/workspace-diagnostics.nvim")

OL.map(
    {
        "<leader>dD",
        function()
            for _, client in ipairs(vim.lsp.get_clients()) do
                require("workspace-diagnostics").populate_workspace_diagnostics(
                    client, 0
                )
            end
        end,
        desc = "Populate Workspace Diagnostics",
    }
)

local function setup_server(server, server_opts, global_capabilities)
    if server_opts == nil or server_opts.enabled == false then
        return
    end
    local lsp = OL.load("lspconfig")
    local o = vim.tbl_deep_extend(
        "force", {
            capabilities = vim.deepcopy(global_capabilities),
        }, server_opts
    )
    lsp[server].setup(o)
    if server_opts.callback then
        server_opts.callback(server_opts)
    end
end

local function setup_servers(servers, capabilities)
    --- get all the servers that are available through mason-lspconfig
    local all_mslp_servers = vim.tbl_keys(
        OL.load(
            "mason-lspconfig.mappings.server"
        ).lspconfig_to_package
    )

    local ensure_installed = OL.callbacks.mason_lsp.install
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
    OL.load_setup(
        "mason-lspconfig", {}, {
            ensure_installed = ensure_installed,
            handlers = {
                function(server)
                    local server_opts = servers[server]
                    return setup_server(server, server_opts, capabilities)
                end,
            },
        }
    )
end

function spec.config(_, o)
    if o.diagnostics.enabled then
        setup_diagnostics(o.diagnostics)
    end
    if o.inlay_hints.enabled then
        setup_inlay_hints(o.inlay_hints)
    end
    if o.codelens.enabled then
        setup_codelens(o.codelens)
    end
    local capabilities = setup_capabilities(o.capabilities)
    setup_servers(o.servers, capabilities)
end

