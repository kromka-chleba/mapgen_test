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
local mod_name = minetest.get_current_modname()
local mod_path = minetest.get_modpath(mod_name)

-- These are necessary so the mapgen works at all lol
minetest.register_alias("mapgen_stone", node_name("default_solid"))
minetest.register_alias("mapgen_water_source", node_name("default_water"))
minetest.register_alias("mapgen_river_water_source", node_name("default_water"))

minetest.set_mapgen_setting("mg_flags", "nocaves, nodungeons, light, decorations, biomes", true)

dofile(mod_path.."/biomes.lua")
minetest.register_mapgen_script(mod_path.."/mapgen.lua")
