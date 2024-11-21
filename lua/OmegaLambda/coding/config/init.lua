local filetypes = {
    json = "jsn",
    yaml = "yml",
    csv = "csv",
    xml = "xml",
    toml = "tml",
}
for ft, alias in pairs(filetypes) do
    table.insert(OL.callbacks.mason.ft, "BufReadPre *." .. ft)
    if alias ~= ft then
        table.insert(OL.callbacks.mason.ft, "BufReadPre *." .. alias)
    end
end

--- LSP
local servers = {
    json = {
        name = "jsonls",
        opts = {
            capabilities = {
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true,
                        },
                    },
                },
            },
        },
    },
}
for ft, server in pairs(servers) do
    table.insert(OL.callbacks.lsp.ft, "BufReadPost *." .. ft)
    if filetypes[ft] ~= ft then
        table.insert(OL.callbacks.lsp.ft, "BufReadPost *." .. filetypes[ft])
    end
    OL.callbacks.lsp.servers[server.name] = server.opts or {}
end

--- Format
local formatter = "yq"
local yq_opts = '(.. |= (\
    with(select(kind == "map"); . style="") |\
    with(select(kind == "seq"); . style="") |\
    with(select((kind == "map") and (path | length >= 1) and (. | has("<<") | not)); sort_keys(.) style="") |\
    with(select(kind == "seq" and ((. | all_c(kind == "scalar")) or (. | key == "<<"))); . style="flow") |\
    with(select(kind == "scalar" and tag == "!!str"); . style="double") \
))'
--     select(kind == "map"); . style = ""\
-- ) | with(\
--     select(kind == "scalar");. style = ""\
-- )\
for ft, alias in pairs(filetypes) do
    table.insert(OL.callbacks.format.ft, "BufWritePre *." .. ft)
    if alias ~= ft then
        table.insert(OL.callbacks.format.ft, "BufWritePre *." .. alias)
    end
    local ft_formatter = OL.fstring("%s_%s", ft, formatter)
    OL.callbacks.format.formatters_by_ft[ft] = {
        ft_formatter,
    }
    OL.callbacks.format.formatters[ft_formatter] = {
        function()

            local ft_formatter_opts = OL.load(
                                          "conform.formatters." .. formatter,
                                          {}, function(fmt)
                    return vim.deepcopy(fmt)
                end
                                      )
            ft_formatter_opts.args = {
                "-p",
                ft,
                "-o",
                ft,
                "-I2",
                yq_opts,
                "-",
            }
            return ft_formatter_opts
        end,
        mason = false,
    }
end

