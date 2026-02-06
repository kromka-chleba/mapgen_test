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
    -- Note: Created inside callback to ensure world is ready (fixes nil error)
    local vm = core.get_voxel_manip()
    local emin, emax = vm:read_from_map(minp, maxp)
    local data = vm:get_data()
    local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    
    -- Check if any base_solid nodes exist and replace them with base_default
    local found = false
    for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
            for x = minp.x, maxp.x do
                local vi = area:index(x, y, z)
                if data[vi] == base_solid_id then
                    data[vi] = base_default_id
                    found = true
                end
            end
        end
    end
    
    -- Only write back if changes were made
    if found then
        vm:set_data(data)
        vm:write_to_map()
    end
end)
