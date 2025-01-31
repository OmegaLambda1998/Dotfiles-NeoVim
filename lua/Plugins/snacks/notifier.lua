local M = {}

local opts = {
    enabled = true,
}

opts.style = "fancy"

local progress = vim.defaulttable()
local function lsp_progress(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= "table" then
        return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                    value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "", value.message and
                            (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
            }
            break
        end
    end

    local msg = {}
    progress[client.id] = vim.tbl_filter(
        function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p
    )
    local spinner = {
        "⠋",
        "⠙",
        "⠹",
        "⠸",
        "⠼",
        "⠴",
        "⠦",
        "⠧",
        "⠇",
        "⠏",
    }

    vim.notify(
        table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " " or
                                 spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) %
                                     #spinner + 1]
            end,
        }
    )
end

function M.setup(snacks)
    snacks.opts.notifier = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>n",
                    mode = {
                        "n",
                    },
                    group = "Notififications",
                    desc = "Notifications",
                    {
                        "<leader>nn",
                        function()
                            Snacks.notifier.show_history(
                                {
                                    reverse = false,
                                }
                            )
                        end,
                        desc = "Show",
                    },
                    {
                        "<leader>nc",
                        function()
                            Snacks.notifier.hide()
                        end,
                        desc = "Clear",
                    },

                }
            )
            CFG.aucmd:on(
                {
                    "LspProgress",
                }, lsp_progress, {
                    group = "LspProgress",
                }
            )
        end
    )
    return snacks
end

return M
