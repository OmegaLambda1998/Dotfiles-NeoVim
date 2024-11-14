---
--- === Setup ===
---

---
--- --- Metatables ---
---

--- Load Metatables
OL = require("OmegaLambda.setup.metatables")

--- Create Paths
OL.paths = OLPath.new({root = "OmegaLambda"})
OL.paths.setup = "setup"

---
--- --- Debugging ---
---

--- Load Debugging
require(OL.paths.setup:module("debugging"))


---
--- --- Modules ---
---

--- Load Modules
require(OL.paths.setup:module("modules"))


return OL
