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

-- Separate transparency settings for base/solid nodes and water
-- nodes.  The color field performs RGB-only hardware multiplication
-- and does not affect rendered transparency. For transparent nodes
-- use [opacity:77 (30% opaque) so the texture itself carries the
-- alpha that use_texture_alpha = "blend" can render.  Fallback nodes
-- are always fully opaque to remain easily visible.
local transparent_base  = core.settings:get_bool("mapgentest_transparent_base_nodes",  true)
local transparent_water = core.settings:get_bool("mapgentest_transparent_water_nodes", true)

-- All non-edge nodes share mapgen_solid as the base texture; hardware
-- coloring via the color field differentiates them visually.
local tx_solid = tx_name("mapgen_solid")
local tx_base  = transparent_base  and tx_solid .. "^[opacity:77" or tx_solid
local tx_water = transparent_water and tx_solid .. "^[opacity:77" or tx_solid

-- Mapgen nodes (used in biomes)
-- gray base
core.register_node(
    node_name("mapgen_solid"),
    {
        description = "Mapgen Solid",
        tiles = {{name = tx_base}},
        color = "#808080",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_base,
        use_texture_alpha = transparent_base and "blend" or "opaque",
        drawtype = transparent_base and "glasslike" or "normal",
    }
)

-- blue
core.register_node(
    node_name("mapgen_water"),
    {
        description = "Mapgen Water",
        tiles = {{name = tx_water}},
        color = "#3366cc",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_water,
        use_texture_alpha = transparent_water and "blend" or "opaque",
        drawtype = transparent_water and "glasslike" or "normal",
    }
)

-- Fallback nodes (used in aliases) – always fully opaque to be visible
-- pink
core.register_node(
    node_name("fallback_solid"),
    {
        description = "Fallback Solid",
        tiles = {{name = tx_solid}},
        color = "#ff69b4",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        use_texture_alpha = "opaque",
        drawtype = "normal",
    }
)

-- yellow
core.register_node(
    node_name("fallback_water"),
    {
        description = "Fallback Water",
        tiles = {{name = tx_solid}},
        color = "#ffdd00",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        use_texture_alpha = "opaque",
        drawtype = "normal",
    }
)

-- on_block_loaded callback node
-- light green
core.register_node(
    node_name("block_loaded"),
    {
        description = "Block Loaded",
        tiles = {{name = tx_base}},
        color = "#90ee90",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_base,
        use_texture_alpha = transparent_base and "blend" or "opaque",
        drawtype = transparent_base and "glasslike" or "normal",
    }
)

-- Tree nodes (used in the forest biome)
-- brown
core.register_node(
    node_name("log"),
    {
        description = "Log",
        tiles = {{name = tx_base}},
        color = "#8B4513",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_base,
        use_texture_alpha = transparent_base and "blend" or "opaque",
        drawtype = transparent_base and "glasslike" or "normal",
    }
)

-- red
core.register_node(
    node_name("leaves"),
    {
        description = "Leaves",
        tiles = {{name = tx_base}},
        color = "#cc0000",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_base,
        use_texture_alpha = transparent_base and "blend" or "opaque",
        drawtype = transparent_base and "glasslike" or "normal",
    }
)

-- teal (ocean/river floor)
core.register_node(
    node_name("sea_floor"),
    {
        description = "Sea Floor",
        tiles = {{name = tx_base}},
        color = "#008080",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent_base,
        use_texture_alpha = transparent_base and "blend" or "opaque",
        drawtype = transparent_base and "glasslike" or "normal",
    }
)

-- Edge marker nodes (used to mark mapchunk boundaries)
-- Each variant uses the edge_marker texture tinted to match its node type.
-- gray (mapgen_solid)
core.register_node(
    node_name("edge_marker"),
    {
        description = "Edge Marker",
        tiles = {{name = tx_name("edge_marker")}},
        color = "#808080",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- blue (mapgen_water)
core.register_node(
    node_name("edge_marker_water"),
    {
        description = "Edge Marker Water",
        tiles = {{name = tx_name("edge_marker")}},
        color = "#3366cc",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- pink (fallback_solid)
core.register_node(
    node_name("edge_marker_fallback_solid"),
    {
        description = "Edge Marker Fallback Solid",
        tiles = {{name = tx_name("edge_marker")}},
        color = "#ff69b4",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- yellow (fallback_water)
core.register_node(
    node_name("edge_marker_fallback_water"),
    {
        description = "Edge Marker Fallback Water",
        tiles = {{name = tx_name("edge_marker")}},
        color = "#ffdd00",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- light green (block_loaded)
core.register_node(
    node_name("edge_marker_block_loaded"),
    {
        description = "Edge Marker Block Loaded",
        tiles = {{name = tx_name("edge_marker")}},
        color = "#90ee90",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)
