
--Remote Bouncing Mine Mod


local vertical_velocity=5	

--register entities, tools & nodes

MINE_ENTITY={
	physical = false,
	timer=0,
	textures = {"mine_mine_side.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

minetest.register_entity("remote_bouncing_mine:mine_entity", MINE_ENTITY)
minetest.register_node("remote_bouncing_mine:mine", {
	description  = "Remote Bouncing Mine",
   	    tiles = {
		"active_top.png", "active_bottom.png",
        "active_side.png", "active_side.png",
        "active_side.png", "active_side.png",
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
		{-.2,-.375,-.2,-.15,.1,-.15},
		}
	},
})

--ABM's

minetest.register_abm({
	nodenames = {"remote_bouncing_mine:mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if got_signal(pos)==true then
					local node = minetest.env:get_node(pos)
					local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)           --get the objects within 5 blocks								 		  --if there are 2 entities in the radius(1 for the mine and one for the target) then
							if minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= air then	 	 --if the block 1 space above is not air, remove it
								minetest.env:dig_node({x=pos.x,y=pos.y+1,z=pos.z})
							end	
							if minetest.env:get_node({x=pos.x,y=pos.y+2,z=pos.z}).name ~= air then		  --if the block 2 spaces above is not air, remove it
								minetest.env:dig_node({x=pos.x,y=pos.y+2,z=pos.z})
							end
							local obj=minetest.env:add_entity({x=pos.x,y=pos.y,z=pos.z}, "remote_bouncing_mine:mine_entity")
							obj:setvelocity({x=0, y=vertical_velocity, z=0})						  --add the active mine entity to the current position and set it's velocity
							local obj=minetest.env:dig_node(pos)
		end
	end,
})

MINE_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local velocity=(1-self.timer)*vertical_velocity
	self.object:setvelocity({x=0, y=velocity, z=0})
	local pos = self.object:getpos()
		if self.timer>0.5 then												--if the entity has existed for more than .5 seconds(giving it time to move a couple blocks up into the air) then
			print ("mine entity causing damage")
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)
			for k, obj in pairs(objs) do
				local node_name = "remote_bouncing_mine:mine"
				explode(pos, node_name, self)
			end
	end
end

--crafting recipes	

minetest.register_craft({
	output = '"remote_bouncing_mine:mine" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'bouncing_mine:mine', ''},
		{'', '', ''},
	}
})
