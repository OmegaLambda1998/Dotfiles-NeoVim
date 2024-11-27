local filetypes = {
    json = "jsn",
    yaml = "yml",
    csv = "csv",
    xml = "xml",
    toml = "tml",
}

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
    OL.callbacks.lsp.ft:add(ft)
    if filetypes[ft] ~= ft then
        OL.callbacks.lsp.ft:add(filetypes[ft])
    end
    OL.callbacks.lsp:add(server.name, server.opts or {})
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
    OL.callbacks.format.ft:add(ft)
    if alias ~= ft then
        OL.callbacks.format.ft:add(alias)
    end

    local ft_formatter = OL.fstring("%s_%s", ft, formatter)
    OL.callbacks.format:add(
        ft, ft_formatter, {
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
    )
end

