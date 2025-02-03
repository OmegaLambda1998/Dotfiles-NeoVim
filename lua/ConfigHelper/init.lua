CFG = {}

function CFG.is_pager()
    for _, arg in ipairs(vim.v.argv) do
        if arg:find("neovim-page", 0, true) then
            return true
        end
    end
    return false
end

CFG.spec = require("ConfigHelper.spec")
CFG.paths = require("ConfigHelper.paths")
CFG.key = require("ConfigHelper.keymaps")
CFG.set = require("ConfigHelper.settings")
CFG.aucmd = require("ConfigHelper.autocommands")
CFG.usrcmd = require("ConfigHelper.usercommands")
CFG.hl = require("ConfigHelper.highlights")

return CFG
