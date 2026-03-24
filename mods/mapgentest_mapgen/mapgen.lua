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

local blocks_per_chunk = tonumber(core.get_mapgen_setting("chunksize"))
local mapblock_size = 16
local mapchunk_size = blocks_per_chunk * mapblock_size
local mapchunk_offset = -mapblock_size * math.floor(blocks_per_chunk / 2)

-- Mapgen generates a mapchunk with a shell of one mapblock from each
-- side. This means that the emerged cuboid area starts at xyz:
-- 'overgen_min' and ends at 'overgen_max'. Meanwhile the mapchunk is
-- inside of emerged area and starts at xyz: 'chunk_min' and ends at
-- xyz: 'chunk_max'.
local chunk_min = mapblock_size
local chunk_max = mapblock_size + mapchunk_size - 1
local overgen_min = 0
local overgen_max = mapchunk_size + 2 * mapblock_size - 1

local function on_edge(b)
    if b == chunk_min or b == chunk_max then
        return true
    end
end

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

function draw_helper_grid(...)
    local vm, pos_min, pos_max, blockseed = ...

    -- Read data into LVM
    local data = vm:get_data()
    local emin, emax = vm:get_emerged_area()
    local va = VoxelArea(emin, emax)
    for z = chunk_min, chunk_max do
        for y = chunk_min, chunk_max do
            for x = chunk_min, chunk_max do
                if on_edge(z) or on_edge(y) or on_edge(x) then
                    local i = z * va.zstride + y * va.ystride + x + 1
                    local marker = node_to_edge_marker[data[i]]
                    if marker then
                        data[i] = marker
                    end
                end
            end
        end
    end

    -- Write data
    vm:set_data(data)
end


local function mapgen(...)
    local t1 = core.get_us_time()
    local vm, pos_min, pos_max, blockseed = ...
    draw_helper_grid(...)
    --core.log("error", string.format("elapsed time: %g ms", (core.get_us_time() - t1) / 1000))
end

core.register_on_generated(mapgen)
