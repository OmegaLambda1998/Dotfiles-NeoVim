--- Environment Variables ---
local verbose = os.getenv("NVIM_VERBOSE") and true or false
local profile = os.getenv("NVIM_PROFILE") and true or false

CFG = require("ConfigHelper").new(verbose, profile)

--- Lazy Bootstrap ---
local lazy = require("Plugins.lazy")
lazy.bootstrap()

--- Load Plugins ---
require("Plugins")

--- Load FileType Plugins ---
require("FileTypes")

--- Load Settings ---
require("Settings")

--- Setup Keymaps ---
require("Keymaps")

--- Setup autocommands ---
require("Autocommands")

--- Setup usercommands ---
require("Usercommands")

--- Lazy Setup ---
lazy.setup()

--- Setup settings ---
CFG.set:setup()

--- Setup Keymaps ---
CFG.key:setup()

--- Setup autocommands ---
CFG.aucmd:setup()

--- Setup usercommands ---
CFG.usrcmd:setup()

--- Setup highlights ---
CFG.hl:setup()

CFG.is_setup = true
