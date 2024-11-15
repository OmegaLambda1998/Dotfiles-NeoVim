local spec, opts = OL.spec:add("Saghen/blink.cmp")

spec.version = false
spec.build = "cargo build --release"

OL.callbacks.cmp = OL.OLConfig.new()
OL.callbacks.cmp.ft = OL.OLConfig.new()
OL.callbacks.cmp.sources = OL.OLConfig.new({"lsp", "path", "snippets", "buffer"})
OL.callbacks.cmp.providers = OL.OLConfig.new()

spec.event = OL.callbacks.cmp.ft

opts.sources = {
    compat = {},
    completion = {enabled_providers = OL.callbacks.cmp.sources},
    providers = OL.callbacks.cmp.providers
}

opts.trigger = {keyword_range = "full"}

opts.fuzzy = {sorts = {'score', 'kind', 'label'}}

opts.signature_help = {enabled = true}

opts.highlight = {use_nvim_cmp_as_default = false}

opts.windows = {}
opts.windows.autocomplete = {winblend = vim.o.pumblend, selection = "manual"}
opts.windows.documentation = {auto_show = true}
opts.windows.ghost_text = {enabled = true}

opts.keymap = {
    ["<CR>"] = {"accept", "fallback"},
    ["<Space>"] = {"accept", "fallback"},

    ["<Tab>"] = {"select_next", "fallback"},
    ["<S-Tab>"] = {"select_prev", "fallback"},

    ['<Up>'] = {'scroll_documentation_up', 'fallback'},
    ['<Down>'] = {'scroll_documentation_down', 'fallback'},

    ['<C-space>'] = {'show', 'show_documentation', 'hide_documentation'}
}

function spec.config(_, o)
    for name, provider in pairs(o.sources.providers) do
        if provider.fallback then
            if type(provider.fallback) ~= table then
                provider.fallback = {provider.fallback}
            end
            for _, fallback in ipairs(provider.fallback) do
                if o.sources.providers[fallback] == nil then
                    o.sources.providers[fallback] = {}
                end
                if o.sources.providers[fallback].fallback_for == nil then
                    o.sources.providers[fallback].fallback_for = {}
                end
                table.insert(o.sources.providers[fallback].fallback_for, name)
            end
        end
    end
    OL.load_setup("blink.cmp", {}, o)
end
