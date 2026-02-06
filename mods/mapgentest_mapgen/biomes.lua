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

core.register_biome({
        name = "base",
        node_top = node_name("base_solid"),
        depth_top = 1,
        node_filler = node_name("base_solid"),
        depth_filler = 3,
        node_stone = node_name("base_solid"),
        node_river_water = node_name("base_water"),
        node_water_top = node_name("base_water"),
        depth_water_top = 1,
        node_water = node_name("base_water"),
        y_max = 31000,
        y_min = -31000,
        heat_point = 50,
        humidity_point = 50,
})
