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

-- draw_helper_grid() is provided by helper_grid.lua, which is registered
-- as a mapgen script before this one.

local function mapgen(vm, pos_min, pos_max, blockseed)
    draw_helper_grid(vm, pos_min, pos_max)
end

core.register_on_generated(mapgen)
