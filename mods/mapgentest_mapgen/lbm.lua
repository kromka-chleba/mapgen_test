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

if not core.settings:get_bool("mapgentest_lbm", false) then
    return
end

-- LBM that replaces the base mapgen node (mapgen_solid) with the green
-- block_loaded node each time a mapblock containing it is loaded.
core.register_lbm({
    label = "Replace mapgen_solid with block_loaded",
    name = "mapgentest_mapgen:replace_mapgen_solid",
    nodenames = {node_name("mapgen_solid")},
    run_at_every_load = true,
    bulk_action = function(pos_list, dtime_s)
        core.bulk_set_node(pos_list, {name = node_name("block_loaded")})
    end,
})
