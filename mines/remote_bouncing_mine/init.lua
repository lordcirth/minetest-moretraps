
--Remote Bouncing Mine Mod

local MINE_DAMAGE=1 			--the minimum mine damage
local MINE_VERTICAL_VELOCITY=5	--the speed the mine travels vertically on detonation
local BOUNCING_MINE_REMOTE_POSITION_X=0
local BOUNCING_MINE_REMOTE_POSITION_Y=0
local BOUNCING_MINE_REMOTE_POSITION_Z=0

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
			if BOUNCING_MINE_REMOTE_POSITION_X >= (pos.x - MINE_REMOTE_DETECTION_RADIUS) and BOUNCING_MINE_REMOTE_POSITION_X <= (pos.x + MINE_REMOTE_DETECTION_RADIUS) then
				if BOUNCING_MINE_REMOTE_POSITION_Y >= (pos.y - MINE_REMOTE_DETECTION_RADIUS) and BOUNCING_MINE_REMOTE_POSITION_Y <= (pos.y + MINE_REMOTE_DETECTION_RADIUS) then
					if BOUNCING_MINE_REMOTE_POSITION_Z >= (pos.z - MINE_REMOTE_DETECTION_RADIUS) and BOUNCING_MINE_REMOTE_POSITION_Z <= (pos.z + MINE_REMOTE_DETECTION_RADIUS) then
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
			self.object:remove() 
		end
		for k, obj in pairs(objs5) do
			if obj:get_hp()<=0 then 
				obj:remove()
			end
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


