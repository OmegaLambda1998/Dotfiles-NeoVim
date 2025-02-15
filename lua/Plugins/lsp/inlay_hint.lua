local M = {}

local inlay_hint = CFG.spec:add("felpafel/inlay-hint.nvim")
inlay_hint.branch = "nightly"
inlay_hint.event = {
    "LspAttach",
}
inlay_hint.cond = CFG.spec:get("nvim-lspconfig").opts.inlay_hint.enabled

inlay_hint.opts.virt_text_pos = "inline"
function inlay_hint.opts.display_callback(line_hints, options, bufnr)
    local lhint = {}
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Fetch cursor position once

    for _, hint in pairs(line_hints) do
        if hint.position.line ~= line then
            local label_parts = type(hint.label) == "table" and hint.label or {
                {
                    value = hint.label,
                },
            }
            local text_parts = {}

            if hint.paddingLeft then
                text_parts[#text_parts + 1] = " "
            end

            for _, part in ipairs(label_parts) do
                text_parts[#text_parts + 1] = part.value
            end

            if hint.paddingRight then
                text_parts[#text_parts + 1] = " "
            end

            lhint[#lhint + 1] = {
                text = table.concat(text_parts),
                col = hint.position.character,
            }
        end
    end

    return lhint
end

inlay_hint.post:insert(
    function()
        CFG.aucmd:on(
            {
                "InsertEnter",
            }, function()
                local hint = require("inlay-hint")
                hint.enable(false)
            end
        )
        CFG.aucmd:on(
            {
                "CursorMoved",
                "InsertLeave",
            }, function()
                if not CFG.is_pager() then
                    local hint = require("inlay-hint")
                    hint.enable(true) --- Refresh inlay hints
                end
            end
        )
    end
)

return M
