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

-- Mapgen nodes (used in biomes)
core.register_node(
    node_name("mapgen_solid"),
    {
        description = "Mapgen Solid",
        tiles = {{name = tx_name("mapgen_solid")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

core.register_node(
    node_name("mapgen_water"),
    {
        description = "Mapgen Water",
        tiles = {{name = tx_name("mapgen_water")}},
        sunlight_propagates = true,
        use_texture_alpha = "blend",
        drawtype = "glasslike",
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- Fallback nodes (used in callbacks and aliases)
core.register_node(
    node_name("fallback_solid"),
    {
        description = "Fallback Solid",
        tiles = {{name = tx_name("fallback_solid")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

core.register_node(
    node_name("fallback_water"),
    {
        description = "Fallback Water",
        tiles = {{name = tx_name("fallback_water")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

-- Edge marker nodes (used to mark mapchunk boundaries)
core.register_node(
    node_name("edge_marker"),
    {
        description = "Edge Marker",
        tiles = {{name = tx_name("edge_marker")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)
