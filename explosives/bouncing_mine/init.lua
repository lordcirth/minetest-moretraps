--Bouncing Mine Mod

local vertical_velocity=5
local countdown_time=10	
	
MINE_ENTITY={
	physical = false,
	timer=0,
	textures = {"mine_entity.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

minetest.register_entity("bouncing_mine:mine_entity", MINE_ENTITY)

minetest.register_node("bouncing_mine:mine", {
	description  = "Bouncing Mine",
    tiles = {
		"inactive_top.png", 
		"inactive_bottom.png",
        "inactive_side.png", 
		"inactive_side.png",
        "inactive_side.png", 
		"inactive_side.png"
    },
	paramtype = "light",
	inventory_image  = "bouncing_mine_inventory_image.png",
    groups = {cracky=4, oddly_breakable_by_hand=9, flammable=1, snappy = 1},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.1,-.375,-.1,.1,-.2,.1},
		}
	},
   	on_punch = function (pos, node)						 
    	local meta = minetest.env:get_meta(pos)
        meta:set_int("Counting_Down", 1)
		meta:set_int("Time_Until_Activation", countdown_time)
    end,
})

minetest.register_node("bouncing_mine:active_mine", {
   	 tiles = {
   	 	"active_top.png", 
	 	"active_bottom.png",
        "active_side.png", 
		"active_side.png",
        "active_side.png", 
		"active_side.png"
    },	
	paramtype = "light",
    groups = {cracky=4, oddly_breakable_by_hand=9, flammable=1, snappy = 1},
	drawtype = "nodebox",
	inventory_image  = "bouncing_mine_inventory_image.png",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.1,-.375,-.1,.1,-.2,.1},
		}
	},
	on_punch = function (pos)
		local node_name = "bouncing_mine:active_mine"
		local self = "not_an_entity"
		local mine_damage = 1
		local detection_radius = 5
		explode(pos, node_name, self, mine_damage, detection_radius)
		minetest.env:dig_node(pos)
		local node = minetest.env:get_node(pos)
		node.name = ("fire:basic_flame")
		minetest.env:add_node(pos,node)
	end,
})

minetest.register_abm({
	nodenames = {"bouncing_mine:active_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
	local node = minetest.env:get_node(pos)
	local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)           
		for k, obj in pairs(objs) do									 		  
			if minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= air then	 	 				
				minetest.env:dig_node({x=pos.x,y=pos.y+1,z=pos.z})
			end	
			if minetest.env:get_node({x=pos.x,y=pos.y+2,z=pos.z}).name ~= air then		  				
				minetest.env:dig_node({x=pos.x,y=pos.y+2,z=pos.z})
			end
			local obj=minetest.env:add_entity({x=pos.x,y=pos.y,z=pos.z}, "bouncing_mine:mine_entity")
			obj:setvelocity({x=0, y=vertical_velocity, z=0})								
			minetest.env:dig_node(pos)
			add_fire(pos)
		end	
	end,
})

minetest.register_abm({
	nodenames = {"bouncing_mine:mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
	local meta = minetest.env:get_meta(pos)	
		if meta:get_int("Counting_Down") == 1 then
			if meta:get_int("Time_Until_Activation")>0 then
				meta:set_int("Time_Until_Activation", meta:get_int("Time_Until_Activation")-1)
			else
				local node = minetest.env:get_node(pos)
				node.name = ("bouncing_mine:active_mine")
				minetest.env:add_node(pos,node)
			end
		end
	end,
})

MINE_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local velocity=(1-self.timer)*vertical_velocity
	self.object:setvelocity({x=0, y=velocity, z=0})
	local pos = self.object:getpos()
	if self.timer>0.75 then
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)
		local node_name = "bouncing_mine:active_mine"
		local mine_damage = 1
		local detection_radius = 5
		explode(pos, node_name, self, mine_damage, detection_radius)
	end
end

minetest.register_craft({
	output = '"bouncing_mine:mine" 1',
	recipe = {
		{'', 'normal_mine:mine', ''},
		{'', 'normal_mine:gunpowder', ''},
		{'', '', ''},
	}
})