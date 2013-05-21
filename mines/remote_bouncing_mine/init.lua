
--Remote Bouncing Mine Mod

local MINE_DAMAGE=1 			--the minimum mine damage
local MINE_VERTICAL_VELOCITY=5	--the speed the mine travels vertically on detonation

--register entities, tools & nodes

MINE_REMOTE_BOUNCING_MINE_ENTITY={
	physical = false,
	timer=0,
	textures = {"mine_mine_side.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

minetest.register_entity("remote_bouncing_mine:remote_bouncing_mine_entity", MINE_REMOTE_BOUNCING_MINE_ENTITY)
minetest.register_node("remote_bouncing_mine:remote_bouncing_mine", {
	description  = "Remote Bouncing Mine",
   	tiles = {
        'mines_remote_inactive.png',
    },
	paramtype = "light",
	inventory_image  = "mines_remote_inactive.png",
    groups = {cracky=2,oddly_breakable_by_hand=5,flammable=3,explody=9},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.1,-.375,-.1,.1,-.2,.1},
		{-.2,-.375,-.2,-.15,.1,-.15},
		}
	},
})

--ABM's

minetest.register_abm({
	nodenames = {"remote_bouncing_mine:remote_bouncing_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if MINE_REMOTE_ACTIVE==true then
		print("mine remote(bouncing)= active")
		end
		if MINE_REMOTE_ACTIVE==true then
			if MINE_REMOTE_POSITION_X >= (pos.x - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_X <= (pos.x + MINE_REMOTE_DETECTION_RADIUS) then
				if MINE_REMOTE_POSITION_Y >= (pos.y - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Y <= (pos.y + MINE_REMOTE_DETECTION_RADIUS) then
					if MINE_REMOTE_POSITION_Z >= (pos.z - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Z <= (pos.z + MINE_REMOTE_DETECTION_RADIUS) then
					local node = minetest.env:get_node(pos)
					local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)           --get the objects within 5 blocks								 		  --if there are 2 entities in the radius(1 for the mine and one for the target) then
							if minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= air then	 	 --if the block 1 space above is not air, remove it
								minetest.env:dig_node({x=pos.x,y=pos.y+1,z=pos.z})
							end	
							if minetest.env:get_node({x=pos.x,y=pos.y+2,z=pos.z}).name ~= air then		  --if the block 2 spaces above is not air, remove it
								minetest.env:dig_node({x=pos.x,y=pos.y+2,z=pos.z})
							end
							local obj=minetest.env:add_entity({x=pos.x,y=pos.y,z=pos.z}, "remote_bouncing_mine:remote_bouncing_mine_entity")
							obj:setvelocity({x=0, y=MINE_VERTICAL_VELOCITY, z=0})						  --add the active mine entity to the current position and set it's velocity
							local obj=minetest.env:dig_node(pos)
					end
				end
			end
		end
	end,
})

MINE_REMOTE_BOUNCING_MINE_ENTITY.on_step = function(self, dtime)
	
	self.timer=self.timer+dtime
	MINE_VERTICAL_VELOCITY=(.4-self.timer)*10
	self.object:setvelocity({x=0, y=MINE_VERTICAL_VELOCITY, z=0})
	local pos = self.object:getpos()
	if pos~= nil then
		local objs5 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)	--gets the objects within a specific radius and assigns them different names
		local objs4 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 4)
		local objs3 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 3)
		local objs2 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		if self.timer>0.5 then												--if the entity has existed for more than .5 seconds(giving it time to move a couple blocks up into the air) then
			print ("mine entity causing damage")
			for k, obj in pairs(objs5) do
			local player_pos = obj:getpos()
                if check_if_path_clear3(pos, player_pos) == true and obj:get_player_name()~="" then--this makes it only damage players, not other entities(if the object is an entity, the name will be "")
				obj:set_hp(obj:get_hp()-MINE_DAMAGE)							--remove health from the objects within each of the different distances from the mine
				for k, obj in pairs(objs4) do									--the closer the object is to the mine, the more times health gets removed, so if the object is within 2 blocks, it
					obj:set_hp(obj:get_hp()-MINE_DAMAGE)						--would get 4*MINE_DAMAGE health removed, because it is within the 5,4,3,and 2 radius zones
					for k, obj in pairs(objs3) do
						obj:set_hp(obj:get_hp()-MINE_DAMAGE)
						for k, obj in pairs(objs2) do
							obj:set_hp(obj:get_hp()-MINE_DAMAGE)
						end
					end
					end
				end
			end
		self.object:remove() 
		end
		for k, obj in pairs(objs5) do
			if obj:get_hp()<=0 then 
				obj:remove()
			end
		end
	end
end
check_if_path_clear3 = function (pos, player_pos)
	local scanning = true
    local player_pos=player_pos
    local distance_scanning = 1

    while scanning==true do
		    local player_pos_x=player_pos.x-pos.x
    local player_pos_y=player_pos.y-pos.y
    local player_pos_z=player_pos.z-pos.z
		  local node_being_scanned = {x=player_pos_x*distance_scanning + pos.x,y=player_pos_y*distance_scanning + pos.y,z=player_pos_z*distance_scanning + pos.z}
        if minetest.env:get_node(node_being_scanned).name == "air" or minetest.env:get_node(node_being_scanned).name == "remote_bouncing_mine:remote_bouncing_mine" then
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
	output = '"remote_bouncing_mine:remote_bouncing_mine" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'bouncing_mine:bouncing_inactive_mine', ''},
		{'', '', ''},
	}
})


