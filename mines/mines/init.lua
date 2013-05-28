local MINE_DAMAGE=1 
local detection_radius = 5

explode = function (pos, node_name, self)
	local distance_damaging = detection_radius
	local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, detection_radius)
	for k, obj in pairs(objs) do
		while distance_damaging>0 do 
			local player_pos = obj:getpos()
			local node_name = node_name
	    		if check_if_path_clear(pos, node_name, player_pos) == true and obj:get_player_name()~="" then		
				obj:set_hp(obj:get_hp()-MINE_DAMAGE)					
			end
			distance_damaging=distance_damaging - 1
			if obj:get_hp()<=0 then 
				obj:remove()
			end
		end
		if self~= not_an_entity then
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
            print ("player x,y,z="..pos.x - player_pos.x.." "..pos.y - player_pos.y.." "..pos.z - player_pos.z.."")
            if distance_scanning > .3 then
                print ("distance_scanning = "..distance_scanning)
                distance_scanning=distance_scanning-.1
                local node_being_scanned = {x=player_pos_x*distance_scanning + pos.x,y=player_pos_y*distance_scanning + pos.y,z=player_pos_z*distance_scanning + pos.z}
                print ("node = "..minetest.env:get_node(node_being_scanned).name.."")
            else
                print ("path is clear")
				scanning=false
                return true
            end
        else
			print ("node_name = " ..node_name)
            print ("player is blocked")
            print ("player x,y,z="..pos.x - player_pos.x.." "..pos.y - player_pos.y.." "..pos.z - player_pos.z.."")
            print ("node x,y,z = "..player_pos_x*distance_scanning + pos.x.." "..player_pos_y*distance_scanning + pos.y.." "..player_pos_z*distance_scanning + pos.z.."")
  		print ("node = "..minetest.env:get_node(node_being_scanned).name.."")
		scanning=false
            return false
        end
    end
end