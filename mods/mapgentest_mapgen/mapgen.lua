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

local draw_grid = core.settings:get_bool("mapgentest_helper_grid", true)

local mapgen_solid_id       = core.get_content_id(node_name("mapgen_solid"))
local mapgen_water_id       = core.get_content_id(node_name("mapgen_water"))
local fallback_solid_id     = core.get_content_id(node_name("fallback_solid"))
local fallback_water_id     = core.get_content_id(node_name("fallback_water"))
local edge_marker_id                = core.get_content_id(node_name("edge_marker"))
local edge_marker_water_id          = core.get_content_id(node_name("edge_marker_water"))
local edge_marker_fallback_solid_id = core.get_content_id(node_name("edge_marker_fallback_solid"))
local edge_marker_fallback_water_id = core.get_content_id(node_name("edge_marker_fallback_water"))

-- Maps each node type to its corresponding colorized edge marker.
-- block_loaded is intentionally absent: it only appears after the
-- on_block_loaded callback fires, which runs after mapgen is complete,
-- so it can never be present in the voxel data during on_generated.
local node_to_edge_marker = {
    [mapgen_solid_id]   = edge_marker_id,
    [mapgen_water_id]   = edge_marker_water_id,
    [fallback_solid_id] = edge_marker_fallback_solid_id,
    [fallback_water_id] = edge_marker_fallback_water_id,
}

local function draw_helper_grid(vm, pos_min, pos_max)
    local data = vm:get_data()
    local emin, emax = vm:get_emerged_area()
    local va = VoxelArea(emin, emax)
    for z = pos_min.z, pos_max.z do
        for y = pos_min.y, pos_max.y do
            for x = pos_min.x, pos_max.x do
                if x == pos_min.x or x == pos_max.x
                    or y == pos_min.y or y == pos_max.y
                    or z == pos_min.z or z == pos_max.z
                then
                    local i = va:index(x, y, z)
                    local marker = node_to_edge_marker[data[i]]
                    if marker then
                        data[i] = marker
                    end
                end
            end
        end
    end
    vm:set_data(data)
end


local function mapgen(vm, pos_min, pos_max, blockseed)
    if draw_grid then
        draw_helper_grid(vm, pos_min, pos_max)
    end
end

core.register_on_generated(mapgen)
