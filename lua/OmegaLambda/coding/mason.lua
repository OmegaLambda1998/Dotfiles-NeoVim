local spec, opts = OL.spec:add("williamboman/mason.nvim")

spec.cmd = {
    "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog",
    "MasonUpdate", "MasonUpdateAll" -- this cmd is provided by mason-extra-cmds
}
spec.build = ":MasonUpdate"
spec.dependencies = {"Zeioth/mason-extra-cmds", opts = {}} --- Adds MasonUpdateAll

OL.callbacks.mason = OL.OLConfig.new()

OL.callbacks.mason.ft = OL.OLConfig.new()
spec.event = OL.callbacks.mason.ft

OL.callbacks.mason.install = OL.OLConfig.new()
opts.ensure_installed = OL.callbacks.mason.install

OL.callbacks.update:add(function()
    OL.load("masonextracmds.mason", {}, function(m)
        OL.log:info("Updating Mason")
        m.update_all()
    end)
end)

opts.log_level = OL.log.DEBUG
opts.pip = {upgrade_pip = true}
opts.ui = {border = "single"}

function spec.config(_, o)
    OL.log:log(o.log_level, "Starting Mason")
    for name, linter in pairs(OL.callbacks.lint.linters) do
        if linter.mason ~= false then
            table.insert(o.ensure_installed, name)
        end
    end
    for name, formatter in pairs(OL.callbacks.format.formatters) do
        if formatter.mason ~= false then
            table.insert(o.ensure_installed, name)
        end
    end

    OL.load_setup("mason", {}, o)
    local mr = OL.load("mason-registry")
    mr:on("package:install:success", function()
        vim.defer_fn(function()
            OL.load("lazy.core.handler.event", {}, function(l)
                l.trigger({
                    event = "FileType",
                    buf = vim.api.nvim_get_current_buf()
                })
            end)
        end, 100)
    end)

    mr.refresh(function()
        for _, tool in ipairs(o.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
                OL.log:info("Installing %s", p)
                p:install()
            end
        end
    end)
end
