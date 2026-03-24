--[[
    This is a part of "Mapgentest".
    Copyright (C) 2024-2026 Jan Wielkiewicz <tona_kosmicznego_smiecia@interia.pl>

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

-- Check whether the on_block_loaded API is available and the setting is enabled
local callback_setting_enabled =
    core.settings:get_bool("mapgentest_block_loaded_callback", true)

if not core.register_on_block_loaded then
    if callback_setting_enabled then
        core.log("warning",
            "[mapgentest] core.register_on_block_loaded is not available on "
            .. "this version of Luanti; the block_loaded callback will not run.")
    end
    return
end

if not callback_setting_enabled then
    return
end

-- Flag to control whether the block callback is enabled
local block_callback_enabled = true

-- Register the on_block_loaded callback to replace mapgen_solid with block_loaded
local mapblock_size = 16
local mapgen_solid_id = core.get_content_id(node_name("mapgen_solid"))
local block_loaded_id = core.get_content_id(node_name("block_loaded"))

core.register_on_block_loaded(function(blockpos)
    -- Early exit if callback is disabled
    if not block_callback_enabled then
        return
    end
    
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
    
    -- Check if any mapgen_solid nodes exist and replace them with block_loaded
    local found = false
    for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
            for x = minp.x, maxp.x do
                local vi = area:index(x, y, z)
                if data[vi] == mapgen_solid_id then
                    data[vi] = block_loaded_id
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

-- Chat command to toggle the block callback
core.register_chatcommand("toggle_block_callback", {
    params = "[on|off]",
    description = "Toggle the mapblock on_load callback on or off, or query its status",
    privs = {server = true},
    func = function(name, param)
        param = param:trim():lower()
        
        if param == "" then
            -- Toggle mode
            block_callback_enabled = not block_callback_enabled
            local status = block_callback_enabled and "enabled" or "disabled"
            return true, "Block callback is now " .. status
        elseif param == "on" then
            block_callback_enabled = true
            return true, "Block callback is now enabled"
        elseif param == "off" then
            block_callback_enabled = false
            return true, "Block callback is now disabled"
        elseif param == "status" then
            local status = block_callback_enabled and "enabled" or "disabled"
            return true, "Block callback is currently " .. status
        else
            return false, "Invalid parameter. Use 'on', 'off', 'status', or no parameter to toggle"
        end
    end,
})
