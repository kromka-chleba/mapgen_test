pcity_nodes = {}

-- Load files
local mod_name = minetest.get_current_modname()
local mod_path = minetest.get_modpath(mod_name)

dofile(mod_path.."/utils.lua")
dofile(mod_path.."/nodes.lua")

minetest.register_mapgen_script(mod_path.."/utils.lua")
