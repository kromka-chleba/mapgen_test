--[[
    This is a part of "Mapgentest".
    Copyright (C) 2024 Jan Wielkiewicz <tona_kosmicznego_smiecia@interia.pl>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

-- This mod name and path
local mod_name = core.get_current_modname()
local mod_path = core.get_modpath(mod_name)

-- These aliases ensure the engine never silently replaces content with
-- unknown-node placeholders regardless of the active mapgen.
core.register_alias("mapgen_stone", node_name("fallback_solid"))
core.register_alias("mapgen_water_source", node_name("fallback_water"))
core.register_alias("mapgen_river_water_source", node_name("fallback_water"))

local use_lua_mapgen = core.settings:get_bool("mapgentest_lua_mapgen", false)

if use_lua_mapgen then
    -- Pure Lua mapgen: the "singlenode" engine generates empty chunks and the
    -- Lua script fills them with terrain from scratch.
    core.set_mapgen_setting("mg_name", "singlenode", true)
    core.register_mapgen_script(mod_path.."/lua_mapgen.lua")
else
    -- Default: engine mapgen (mgv7 or whatever minetest.conf specifies) with
    -- biomes, post-processed by Lua to draw edge markers.
    core.set_mapgen_setting("mg_flags", "nocaves, nodungeons, light, decorations, biomes", true)
    dofile(mod_path.."/biomes.lua")
    core.register_mapgen_script(mod_path.."/mapgen.lua")
end

dofile(mod_path.."/block_callback.lua")
