local index, spec, opts = OL.spec:add("williamboman/mason.nvim")
OL.spec:add("williamboman/mason-lspconfig.nvim", {config = function() end})

spec.cmd = {"Mason"}
spec.build = ":MasonUpdate"

OL.callbacks.mason = OLConfig.new()

OL.callbacks.mason.ft = OLConfig.new()
spec.ft = OL.callbacks.mason.ft

OL.callbacks.mason.install = OLConfig.new()
opts.ensure_installed = OL.callbacks.mason.install

function spec.config(_, opts)
    OL.load_setup("mason", {}, opts)
    local mr = OL.load("mason-registry")
    mr:on("package:install:success", function()
        vim.defer_fn(function()
            OL.load("lazy.core.handler.event", {}, function(l)
                l.trigger(
                    {event = "FileType", buf = vim.api.nvim_get_current_buf()})
            end)
        end, 100)
    end)

    mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
        end
    end)
end
