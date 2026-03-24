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

-- Pure Lua mapgen (runs in the mapgen thread via core.register_mapgen_script).
-- The engine is set to "singlenode" so it produces empty chunks; this script
-- fills them with terrain from scratch using 2D Perlin-like noise.

local mapblock_size    = 16
local blocks_per_chunk = tonumber(core.get_mapgen_setting("chunksize")) or 5
local mapchunk_size    = blocks_per_chunk * mapblock_size

-- The emerged area is one mapblock shell around the chunk on every side.
-- Chunk boundaries in 0-based offsets relative to the emerged area origin:
local chunk_min = mapblock_size
local chunk_max = mapblock_size + mapchunk_size - 1

local function on_edge(offset)
    return offset == chunk_min or offset == chunk_max
end

-- Water level read from the active mapgen setting so it respects world meta.
local water_level = tonumber(core.get_mapgen_setting("water_level")) or 1

-- Content IDs
local c_air        = core.get_content_id("air")
local c_solid      = core.get_content_id(node_name("mapgen_solid"))
local c_water      = core.get_content_id(node_name("mapgen_water"))
local c_edge_solid = core.get_content_id(node_name("edge_marker"))
local c_edge_water = core.get_content_id(node_name("edge_marker_water"))

-- 2D terrain height noise parameters.
-- Uses a world-specific seed (world seed + np_terrain.seed) via
-- core.get_value_noise_map, so each world has unique terrain.
local np_terrain = {
    offset    = 0,
    scale     = 20,
    spread    = {x = 128, y = 128, z = 128},
    seed      = 5,
    octaves   = 4,
    persist   = 0.5,
    lacunarity = 2.0,
}

-- Noise map object: created lazily inside the first on_generated call because
-- ValueNoiseMap requires the mapgen environment to be fully initialized.
local nobj_terrain = nil

core.register_on_generated(function(vm, minp, maxp, blockseed)
    local emin, emax = vm:get_emerged_area()
    local data        = vm:get_data()
    local va          = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

    local side_x = emax.x - emin.x + 1
    local side_z = emax.z - emin.z + 1

    -- Initialize the noise map on first use (size stays constant for a world).
    if not nobj_terrain then
        -- z = 1 satisfies Luanti's vector reader (silences the "Invalid vector
        -- coordinate z" warning); z ≤ 1 keeps the map in 2D mode per the API.
        nobj_terrain = core.get_value_noise_map(np_terrain, {x = side_x, y = side_z, z = 1})
    end

    -- 2D heightmap over the full emerged xz plane.
    -- get_2d_map_flat uses pos={x,y} where y maps to the z world axis.
    -- Flat layout: index = z_offset * side_x + x_offset + 1  (x varies fastest).
    local nvals = nobj_terrain:get_2d_map_flat({x = emin.x, y = emin.z})

    for z = minp.z, maxp.z do
        local lz = z - emin.z
        for x = minp.x, maxp.x do
            local lx    = x - emin.x
            local ni    = lz * side_x + lx + 1
            local surf  = math.floor(nvals[ni])

            for y = minp.y, maxp.y do
                local ly = y - emin.y
                local vi = va:index(x, y, z)

                local node
                if y <= surf then
                    node = c_solid
                elseif y <= water_level then
                    node = c_water
                else
                    node = c_air
                end

                -- Replace non-air nodes at mapchunk boundary faces with
                -- the appropriate colorized edge marker.
                if node ~= c_air
                    and (on_edge(lx) or on_edge(ly) or on_edge(lz))
                then
                    if node == c_water then
                        node = c_edge_water
                    else
                        node = c_edge_solid
                    end
                end

                data[vi] = node
            end
        end
    end

    vm:set_data(data)
    -- Recompute lighting for the whole emerged area after placing nodes.
    -- Required when using singlenode mapgen because the engine does not run
    -- its own lighting step; skipping this causes lighting bugs when multiple
    -- emerge threads are active.
    vm:calc_lighting()
end)
