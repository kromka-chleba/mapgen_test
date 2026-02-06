pcity_nodes = {}

-- Load files
local mod_name = core.get_current_modname()
local mod_path = core.get_modpath(mod_name)

dofile(mod_path.."/utils.lua")
dofile(mod_path.."/nodes.lua")

core.register_mapgen_script(mod_path.."/utils.lua")
