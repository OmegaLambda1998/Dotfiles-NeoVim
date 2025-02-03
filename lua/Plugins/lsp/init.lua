---
--- === Mason LSPConfig ===
---
CFG.spec:add("williamboman/mason-lspconfig.nvim")
CFG.mason_lsp = {}

---
--- === LSPConfig ===
---

local lsp = CFG.spec:add("neovim/nvim-lspconfig")
local path = CFG.paths.join(
    {
        "Plugins",
        "lsp",
    }
)
require("vim.lsp.log").set_format_func(vim.inspect)

lsp.dependencies = {
    {
        "saghen/blink.cmp",
    }, --- Load first to get capabilities
}
lsp.cmd = {
    "LspInfo",
    "LspStart",
}

CFG.lsp = {}
CFG.lsp.ft = {
    add = function(self, ft)
        table.insert(self, "BufReadPost *." .. ft)
    end,
}

lsp.event = CFG.lsp.ft

--- Appearance ---

local severity = vim.diagnostic.severity
local icons = {
    [severity.ERROR] = " ",
    [severity.WARN] = " ",
    [severity.HINT] = " ",
    [severity.INFO] = " ",
}

CFG.colourscheme:set("semantic_tokens")

CFG.colourscheme:set(
    "native_lsp", {
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
)

--- Diagnostics ---

local diagnostic_opts = {
    severity_sort = true,
    source = true,
}

lsp.opts.diagnostics = vim.tbl_deep_extend(
    "force", diagnostic_opts, {
        enabled = true,
        underline = diagnostic_opts,
        virtual_text = false,
        signs = {
            text = icons,
        },
        float = diagnostic_opts,
        update_in_insert = true,
        jump = {
            float = diagnostic_opts,
        },
    }
)

function lsp.opts.diagnostics.setup(opts)
    vim.diagnostic.config(vim.deepcopy(opts))
    return opts
end

--- Inlay Hints ---

lsp.opts.inlay_hint = {
    enabled = true,
}

function lsp.opts.inlay_hint.setup(opts)
    CFG.aucmd:on(
        "LspAttach", function(ctx)
            local client = vim.lsp.get_client_by_id(ctx.data.client_id)
            if client and client:supports_method("textDocument/inlayhint") then
                local buf = ctx.buf
                if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
                    vim.lsp.inlay_hint.enable(true)
                end
            end
        end, {
            group = "LspAttach",
        }
    )
    return opts
end

--- Capabilities ---

CFG.lsp.capabilities = {}
lsp.opts.capabilities = CFG.lsp.capabilities

function lsp.opts.capabilities.setup(opts)
    opts.capabilities = vim.tbl_deep_extend(
        "force", vim.lsp.protocol.make_client_capabilities(), opts.capabilities
    )
    return opts
end

--- Servers ---

CFG.lsp.servers = {}
lsp.opts.servers = CFG.lsp.servers

local function setup_server(name, opts, capabilities)
    if opts == nil or opts.enabled == false then
        return
    end
    local lspconfig = require("lspconfig")
    local config = vim.tbl_deep_extend(
        "force", {
            capabilities = vim.deepcopy(capabilities),
        }, opts
    )
    lspconfig[name].setup(config)
    if opts.callback then
        opts.callback(opts)
    end
end

function lsp.opts.servers.setup(opts)
    local all_mslp_servers = vim.tbl_keys(
        require(
            "mason-lspconfig.mappings.server"
        ).lspconfig_to_package
    )
    local ensure_installed = CFG.mason_lsp
    local capabilities = {}
    for k, v in pairs(opts.capabilities) do
        if type(v) ~= "function" then
            capabilities[k] = v
        end
    end
    for server, server_opts in pairs(opts.servers) do
        if type(server_opts) ~= "function" then
            if server_opts == true then
                server_opts = {}
            end
            if server_opts.mason == false or
                not vim.tbl_contains(all_mslp_servers, server) then
                setup_server(server, server_opts, capabilities)
            else
                table.insert(ensure_installed, server)
            end
        end
    end
    require("mason-lspconfig").setup(
        {
            ensure_installed = ensure_installed,
            automatic_installation = true,
            handlers = {
                function(server)
                    return setup_server(
                        server, opts.servers[server], capabilities
                    )
                end,
            },
        }
    )
    return opts
end

lsp.setup = false
lsp.pre:insert(
    function(opts)
        local modes = {
            "diagnostics",
            "inlay_hint",
            "capabilities",
            "servers",
        }
        for _, mode in ipairs(modes) do
            opts = opts[mode].setup(opts)
        end
        return opts
    end
)

---
--- === Plugins ===
---

local plugins = {
    "inlay_hint",
    "hover",
}

for _, file in ipairs(plugins) do
    local plugin = require(
        path.join(
            { file }
        ).mod
    )
    if plugin.setup then
        lsp = plugin.setup(lsp)
    end
end

