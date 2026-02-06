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

-- These are necessary so the mapgen works at all lol
core.register_alias("mapgen_stone", node_name("default_solid"))
core.register_alias("mapgen_water_source", node_name("default_water"))
core.register_alias("mapgen_river_water_source", node_name("default_water"))

core.set_mapgen_setting("mg_flags", "nocaves, nodungeons, light, decorations, biomes", true)

dofile(mod_path.."/biomes.lua")
core.register_mapgen_script(mod_path.."/mapgen.lua")

-- Register the on_block_loaded callback to replace base_solid with base_default
local mapblock_size = 16
local base_solid_id = core.get_content_id(node_name("base_solid"))
local base_default_id = core.get_content_id(node_name("base_default"))

core.register_on_block_loaded(function(blockpos)
    -- Calculate the world position of the mapblock
    local minp = {
        x = blockpos.x * mapblock_size,
        y = blockpos.y * mapblock_size,
        z = blockpos.z * mapblock_size
    }
    local maxp = {
        x = minp.x + mapblock_size - 1,
        y = minp.y + mapblock_size - 1,
        z = minp.z + mapblock_size - 1
    }
    
    -- Create a voxel manipulator for this mapblock
    local vm = core.get_voxel_manip()
    local emin, emax = vm:read_from_map(minp, maxp)
    local data = vm:get_data()
    local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    
    -- Replace base_solid with base_default
    for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
            for x = minp.x, maxp.x do
                local vi = area:index(x, y, z)
                if data[vi] == base_solid_id then
                    data[vi] = base_default_id
                end
            end
        end
    end
    
    -- Write the modified data back
    vm:set_data(data)
    vm:write_to_map()
end)
