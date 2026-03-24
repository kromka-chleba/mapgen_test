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

local transparent = core.settings:get_bool("mapgentest_transparent_nodes", true)
-- When transparent, use [opacity:160 modifier (~63% opaque) so the texture
-- itself carries the alpha that use_texture_alpha = "blend" can render.
-- The color field performs RGB-only hardware multiplication and does not
-- affect rendered transparency.
-- All non-edge nodes share mapgen_solid as the base texture; hardware
-- coloring via the color field differentiates them visually.
local tx_base = transparent
    and tx_name("mapgen_solid") .. "^[opacity:160"
    or  tx_name("mapgen_solid")

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
        sunlight_propagates = transparent,
        use_texture_alpha = transparent and "blend" or "opaque",
        drawtype = transparent and "glasslike" or "normal",
    }
)

-- blue transparent base
core.register_node(
    node_name("mapgen_water"),
    {
        description = "Mapgen Water",
        tiles = {{name = tx_base}},
        color = "#3366cc",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent,
        use_texture_alpha = transparent and "blend" or "opaque",
        drawtype = transparent and "glasslike" or "normal",
    }
)

-- Fallback nodes (used in callbacks and aliases)
-- pink
core.register_node(
    node_name("fallback_solid"),
    {
        description = "Fallback Solid",
        tiles = {{name = tx_base}},
        color = "#ff69b4",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent,
        use_texture_alpha = transparent and "blend" or "opaque",
        drawtype = transparent and "glasslike" or "normal",
    }
)

-- yellow
core.register_node(
    node_name("fallback_water"),
    {
        description = "Fallback Water",
        tiles = {{name = tx_base}},
        color = "#ffdd00",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
        sunlight_propagates = transparent,
        use_texture_alpha = transparent and "blend" or "opaque",
        drawtype = transparent and "glasslike" or "normal",
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
        sunlight_propagates = transparent,
        use_texture_alpha = transparent and "blend" or "opaque",
        drawtype = transparent and "glasslike" or "normal",
    }
)

-- Edge marker nodes (used to mark mapchunk boundaries)
-- gray node with "E" on it
core.register_node(
    node_name("edge_marker"),
    {
        description = "Edge Marker",
        tiles = {{name = tx_name("edge_marker")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)
