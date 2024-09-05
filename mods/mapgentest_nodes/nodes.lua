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

minetest.register_node(
    node_name("default_solid"),
    {
        description = "Default Solid",
        tiles = {{name = tx_name("default_solid")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

minetest.register_node(
    node_name("default_water"),
    {
        description = "Default Water",
        tiles = {{name = tx_name("default_water")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

minetest.register_node(
    node_name("base_solid"),
    {
        description = "Base Solid",
        tiles = {{name = tx_name("base_solid")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

minetest.register_node(
    node_name("base_water"),
    {
        description = "Base Water",
        tiles = {{name = tx_name("base_water")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)

minetest.register_node(
    node_name("mapchunk_edge"),
    {
        description = "Mapchunk Edge",
        tiles = {{name = tx_name("mapchunk_edge")}},
        groups = {cracky = 3, stone = 1},
        paramtype = "light",
    }
)
