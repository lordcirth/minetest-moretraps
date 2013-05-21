--Remote Mine Mod
MINE_REMOTE_ACTIVE=false
local REMOTE_ACTIVATION_TIME=5
local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5
MINE_REMOTE_POSITION_X=0
MINE_REMOTE_POSITION_Y=0
MINE_REMOTE_POSITION_Z=0
MINE_REMOTE_DETECTION_RADIUS=30
--register entities, tools & nodes
minetest.register_node("remote_normal_mine:remote_normal_mine", {
	description  = "Remote Mine",
   	tiles = {
        'mines_remote_inactive.png',
    },
	paramtype = "light",
	inventory_image = "mines_remote_inactive.png",
   	groups = {cracky=7,oddly_breakable_by_hand=9,flammable=3,explody=0},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.2,-.375,-.2,-.15,.1,-.15},
		}
	},
})
minetest.register_node("remote_normal_mine:active_remote", {
	description  = "Mine Remote",
	groups = {cracky=7,oddly_breakable_by_hand=9,flammable=0,explody=0},
	paramtype = "light",
	inventory_image  = "remote.png",
	tiles = {
        'mines_remote_inactive.png',
    },
	node_box = {
		type = "fixed",
		fixed = {
		{-.5,-.5,-.5,.5,.25,.5},
		{-.4,.25,-.4,.4,.3,.4},
		{-.05,.25,-.05,.05,.5,.05},
		}
	},
})
minetest.register_node("remote_normal_mine:inactive_remote", {
	description  = "Mine Remote",
	paramtype = "light",
	inventory_image  = "mines_remote_inactive.png",
	tiles = {
        'mines_remote_inactive.png',
    },
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.5,-.5,-.5,.5,.25,.5},
		{-.4,.25,-.4,.4,.3,.4},
		{-.05,.25,-.05,.05,.5,.05},
		}
	},
	on_punch=function(pos)
		print ("remote normal mine is activated by remote")
		MINE_REMOTE_POSITION_X=pos.x
		MINE_REMOTE_POSITION_Y=pos.y
		MINE_REMOTE_POSITION_Z=pos.z
		MINE_REMOTE_ACTIVE = true
		local node = minetest.env:get_node(pos)
		node.name = ("remote_normal_mine:active_remote")
		minetest.env:add_node(pos,node)
      end,
})

--ABM's

minetest.register_abm({
	nodenames = {"remote_normal_mine:active_remote"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if REMOTE_ACTIVATION_TIME <= 0 then
			print ("remote normal mine is deactivated by remote")
						REMOTE_ACTIVATION_TIME=5
			MINE_REMOTE_POSITION_X=pos.x
			MINE_REMOTE_POSITION_Y=pos.y
			MINE_REMOTE_POSITION_Z=pos.z
			MINE_REMOTE_ACTIVE = false
			local node = minetest.env:get_node(pos)
			node.name = ("remote_normal_mine:inactive_remote")
			minetest.env:add_node(pos,node)

		else
			REMOTE_ACTIVATION_TIME=REMOTE_ACTIVATION_TIME-1
		end
	end,
})

minetest.register_abm({
	nodenames = {"remote_normal_mine:remote_normal_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if MINE_REMOTE_ACTIVE==true then
		print("mine remote(normal)= active")
		end
		if MINE_REMOTE_ACTIVE==true then
			if MINE_REMOTE_POSITION_X >= (pos.x - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_X <= (pos.x + MINE_REMOTE_DETECTION_RADIUS) then
				if MINE_REMOTE_POSITION_Y >= (pos.y - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Y <= (pos.y + MINE_REMOTE_DETECTION_RADIUS) then
					if MINE_REMOTE_POSITION_Z >= (pos.z - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Z <= (pos.z + MINE_REMOTE_DETECTION_RADIUS) then
						print ("normal mine remotely activated and exploding")
						local objs5 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)	--gets the objects within a specific radius and assigns them different names
						local objs4 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 4)
						local objs3 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 3)
						local objs2 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
						for k, obj in pairs(objs5) do
						local player_pos = obj:getpos()
                            if check_if_path_clear4(pos, player_pos) == true and obj:get_player_name()~="" then--this makes it only damage players, not other entities(if the object is an entity, the name will be "")
						obj:set_hp(obj:get_hp()-MINE_DAMAGE)
							for k, obj in pairs(objs4) do
							obj:set_hp(obj:get_hp()-MINE_DAMAGE)
								for k, obj in pairs(objs3) do
								obj:set_hp(obj:get_hp()-MINE_DAMAGE)
									for k, obj in pairs(objs2) do
									obj:set_hp(obj:get_hp()-MINE_DAMAGE)
									end
								end
							end
						end
						for k, obj in pairs(objs5) do
							if obj:get_hp()<=0 then
								obj:remove()
							end
						end

					end
											minetest.env:remove_node({x=pos.x,y=pos.y,z=pos.z})
				end
				end
			end
		end
	end,
})
check_if_path_clear4 = function (pos, player_pos)
	local scanning = true
    local player_pos=player_pos
    local distance_scanning = 1
    local player_pos_x=player_pos.x-pos.x
    local player_pos_y=player_pos.y-pos.y
    local player_pos_z=player_pos.z-pos.z
    while scanning==true do
		  local node_being_scanned = {x=player_pos_x*distance_scanning + pos.x,y=player_pos_y*distance_scanning + pos.y,z=player_pos_z*distance_scanning + pos.z}
        if minetest.env:get_node(node_being_scanned).name == "air" or minetest.env:get_node(node_being_scanned).name == "remote_normal_mine:remote_normal_mine" then
            print ("player x,y,z="..pos.x - player_pos.x.." "..pos.y - player_pos.y.." "..pos.z - player_pos.z.."")
            if distance_scanning > .2 then
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
            print ("player is blocked")
            print ("player x,y,z="..pos.x - player_pos.x.." "..pos.y - player_pos.y.." "..pos.z - player_pos.z.."")
            print ("node x,y,z = "..player_pos_x*distance_scanning + pos.x.." "..player_pos_y*distance_scanning + pos.y.." "..player_pos_z*distance_scanning + pos.z.."")
            print ("node = "..minetest.env:get_node(node_being_scanned).name.."")
			scanning=false
            return false
        end
    end
end
--crafting recipes
minetest.register_craft({
	output = '"remote_normal_mine:remote_normal_mine" 99',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'normal_mine:normal_inactive_mine', ''},
		{'', '', ''},
	}
})
minetest.register_craft({
	output = '"remote_normal_mine:inactive_remote" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'default:steel_ingot', 'default:mese_crystal', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})