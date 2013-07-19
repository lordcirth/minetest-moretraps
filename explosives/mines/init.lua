local mine_damage=1 
local detection_radius = 5

explode = function (pos, node_name, self, mine_damage, detection_radius)
	local distance_damaging = detection_radius
	local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, detection_radius)
	for k, obj in pairs(objs) do
		while distance_damaging>0 do 
			local player_pos = obj:getpos()
			local node_name = node_name
	    	if check_if_path_clear(pos, node_name, player_pos) == true and obj:get_player_name()~="" then		
				obj:set_hp(obj:get_hp()-mine_damage)					
			end
			distance_damaging=distance_damaging - 1
			if obj:get_hp()<=0 then 
				obj:remove()
			end
		end
		if self == "not_an_entity" then
			add_fire(pos)
		else
			self.object:remove()
		end
		minetest.env:dig_node(pos)
	end
end

check_if_path_clear = function(pos, node_name, player_pos)
	local scanning = true
    local player_pos=player_pos
    local distance_scanning = 1
    local player_pos_x=player_pos.x-pos.x
    local player_pos_y=player_pos.y-pos.y
    local player_pos_z=player_pos.z-pos.z
    while  scanning==true do
	local node_being_scanned = {x=player_pos_x*distance_scanning + pos.x,y=player_pos_y*distance_scanning + pos.y,z=player_pos_z*distance_scanning + pos.z}
        if minetest.env:get_node(node_being_scanned).name == "air" or minetest.env:get_node(node_being_scanned).name == node_name then
            if distance_scanning > .3 then
                distance_scanning=distance_scanning-.1
                local node_being_scanned = {x=player_pos_x*distance_scanning + pos.x,y=player_pos_y*distance_scanning + pos.y,z=player_pos_z*distance_scanning + pos.z}
            else
				scanning=false
                return true
            end
        else
			scanning=false
            return false
        end
    end
end

add_fire = function(pos)
		local node = minetest.env:get_node(pos)
		node.name = ("fire:basic_flame")
		minetest.env:add_node(pos,node)
end

print ("[mines] loaded!")