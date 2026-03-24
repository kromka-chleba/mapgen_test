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
        node_top = node_name("mapgen_solid"),
        depth_top = 1,
        node_filler = node_name("mapgen_solid"),
        depth_filler = 3,
        node_stone = node_name("mapgen_solid"),
        node_river_water = node_name("mapgen_water"),
        node_water_top = node_name("mapgen_water"),
        depth_water_top = 1,
        node_water = node_name("mapgen_water"),
        y_max = 31000,
        y_min = -31000,
        heat_point = 50,
        humidity_point = 50,
})

-- Forest biome with log/leaves trees; guarded by the mapgentest_forest_biome setting.
if core.settings:get_bool("mapgentest_forest_biome", false) then

    core.register_biome({
        name = "forest",
        -- Same base nodes as "base" biome.
        node_top = node_name("mapgen_solid"),
        depth_top = 1,
        node_filler = node_name("mapgen_solid"),
        depth_filler = 3,
        node_stone = node_name("mapgen_solid"),
        node_river_water = node_name("mapgen_water"),
        node_water_top = node_name("mapgen_water"),
        depth_water_top = 1,
        node_water = node_name("mapgen_water"),
        y_max = 31000,
        y_min = -31000,
        heat_point = 70,
        humidity_point = 70,
    })

    -- Build a schematic table for a simple trunk-and-canopy tree.
    -- Schematic data ordering: [z [y [x]]] (z outermost, x innermost).
    -- The 3×3 footprint has the trunk at (x=1, z=1); canopy corners are air.
    --   trunk_height  : number of pure-log layers at the base
    --   canopy_layers : number of layers where the trunk is surrounded by leaves
    -- The schematic also appends one top leaf node, giving a total height of
    -- trunk_height + canopy_layers + 1.
    local function make_tree_schematic(trunk_height, canopy_layers)
        local W, D = 3, 3
        local H    = trunk_height + canopy_layers + 1
        local log_node    = node_name("log")
        local leaves_node = node_name("leaves")
        local data = {}

        for z = 0, D - 1 do
            for y = 0, H - 1 do
                for x = 0, W - 1 do
                    local is_center = (x == 1 and z == 1)
                    local is_corner = (x ~= 1 and z ~= 1)
                    local name, prob

                    if y < trunk_height then
                        -- Trunk: center column is log, everything else is air.
                        if is_center then
                            name = log_node
                            prob = 255
                        else
                            name = "air"
                            prob = 0
                        end
                    elseif y < trunk_height + canopy_layers then
                        -- Canopy: center stays log; corners stay air; all
                        -- other positions (edges of the cross) become leaves.
                        if is_center then
                            name = log_node
                            prob = 255
                        elseif is_corner then
                            name = "air"
                            prob = 0
                        else
                            name = leaves_node
                            prob = 255
                        end
                    else
                        -- Top cap: single leaf at the centre, air elsewhere.
                        if is_center then
                            name = leaves_node
                            prob = 255
                        else
                            name = "air"
                            prob = 0
                        end
                    end

                    table.insert(data, {name = name, prob = prob})
                end
            end
        end

        return {size = {x = W, y = H, z = D}, data = data}
    end

    -- Three height variants:
    --   small  : trunk 3 + canopy 1 + top 1 = 5 nodes tall
    --   medium : trunk 6 + canopy 2 + top 1 = 9 nodes tall
    --   tall   : trunk 29 + canopy 2 + top 1 = 32 nodes tall
    local small_tree_schematic  = make_tree_schematic(3,  1)
    local medium_tree_schematic = make_tree_schematic(6,  2)
    local tall_tree_schematic   = make_tree_schematic(29, 2)

    core.register_decoration({
        name = "mapgentest_mapgen:small_tree",
        deco_type = "schematic",
        place_on = {node_name("mapgen_solid")},
        biomes = {"forest"},
        fill_ratio = 0.02,
        schematic = small_tree_schematic,
        flags = "place_center_x, place_center_z",
    })

    core.register_decoration({
        name = "mapgentest_mapgen:medium_tree",
        deco_type = "schematic",
        place_on = {node_name("mapgen_solid")},
        biomes = {"forest"},
        fill_ratio = 0.01,
        schematic = medium_tree_schematic,
        flags = "place_center_x, place_center_z",
    })

    core.register_decoration({
        name = "mapgentest_mapgen:tall_tree",
        deco_type = "schematic",
        place_on = {node_name("mapgen_solid")},
        biomes = {"forest"},
        fill_ratio = 0.005,
        schematic = tall_tree_schematic,
        flags = "place_center_x, place_center_z",
    })

end -- mapgentest_forest_biome
