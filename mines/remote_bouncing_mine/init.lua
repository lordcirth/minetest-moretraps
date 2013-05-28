
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
   	    tiles = {"active_mine_top.png", "active_mine_bottom.png",
        "active_mine_side.png", "active_mine_side.png",
        "active_mine_side.png", "active_mine_side.png",
    },	
paramtype = "light",
	inventory_image  = "inventory_image.png",
    groups = {cracky=2,oddly_breakable_by_hand=5,flammable=3,explody=9},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.1,-.375,-.1,.1,-.2,.1},
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
		if self.timer>0.5 then												--if the entity has existed for more than .5 seconds(giving it time to move a couple blocks up into the air) then
			print ("mine entity causing damage")
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)
			for k, obj in pairs(objs) do
				local node_name = "remote_bouncing_mine:remote_bouncing_mine"
				explode(pos, node_name, self)
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
