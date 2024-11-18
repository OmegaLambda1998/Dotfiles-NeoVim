OL.spec:add(
  "williamboman/mason-lspconfig.nvim", {
      config = function()
      end,
  }
)

OL.callbacks.mason_lsp = OL.OLConfig.new()
OL.callbacks.mason_lsp.install = OL.OLConfig.new()

local spec, opts = OL.spec:add("neovim/nvim-lspconfig")
vim.lsp.set_log_level(OL.log.level)

OL.callbacks.lsp = OL.OLConfig.new()
OL.callbacks.lsp.ft = OL.OLConfig.new()

spec.cmd = {
    "LspInfo",
}
spec.event = OL.callbacks.lsp.ft

--- Diagnostics
local severity = vim.diagnostic.severity
local icons = {
    [severity.ERROR] = " ",
    [severity.WARN] = " ",
    [severity.HINT] = " ",
    [severity.INFO] = " ",
}

opts.diagnostics = {
    enabled = true,
    underline = true,
    virtual_text = {
        severity = severity.ERROR,
        source = true,
        spacing = 2,
        prefix = function(diagnostic)
            return icons[diagnostic.severity]
        end,
    },
    signs = {
        text = icons,
    },
    float = {
        severity_sort = true,
        source = true,
    },
    update_in_insert = false,
    severity_sort = true,
    jump = {},
}

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
              if client and client.supports_method("textDocument/inlayHint") then
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
local function setup_codelens(o)
    if vim.lsp.codelens then
        OL.aucmd(
          "LspAttach", {
              {
                  "LspAttach",
                  function(ctx)
                      local client = vim.lsp
                                       .get_client_by_id(ctx.data.client_id)
                      if client.supports_method("textDocument/codeLens") then
                          vim.lsp.codelens.refresh()
                          vim.api.nvim_create_autocmd(
                            {
                                "BufEnter",
                                "CursorHold",
                                "InsertLeave",
                            }, {
                                buffer = buffer,
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
    local blink = OL.load("blink.cmp")
    local capabilities = vim.tbl_deep_extend(
                           "force", {},
                           vim.lsp.protocol.make_client_capabilities(),
                           blink.get_lsp_capabilities(), o
                         )
    return capabilities
end

--- Servers
local function setup_server(server, server_opts, capabilities)
    if server_opts == nil or server_opts.enabled == false then
        return
    end
    local lsp = OL.load("lspconfig")
    local o = vim.tbl_deep_extend(
                "force", {
          capabilities = vim.deepcopy(capabilities),
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
