--Mine Mod
local countdown_time = 10
minetest.register_craftitem("normal_mine:gunpowder", {
	inventory_image = "gunpowder.png",
})
minetest.register_node("normal_mine:mine", {
	description	 = "Mine",
	drawtype = "nodebox",
	inventory_image	 = "normal_mine_inventory_image.png",
	tiles = {
		"inactive_top.png", 
		"inactive_bottom.png",
		"inactive_side.png", 
		"inactive_side.png",
		"inactive_side.png", 
		"inactive_side.png"
	},
	paramtype = "light",
	groups = {cracky=4, oddly_breakable_by_hand=9, flammable=1, snappy = 1},
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		}
	},
	on_punch = function (pos, node)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("Counting_Down", 1)
		meta:set_int("Time_Until_Activation", countdown_time)
	end,
})
minetest.register_node("normal_mine:active_mine", {
	drawtype = "nodebox",
	inventory_image	 = "normal_mine_inventory_image.png",
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
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		}
	},
})
minetest.register_abm({
	nodenames = {"normal_mine:active_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)		  					   
		local node_name = "normal_mine:active_mine"
		local self = "not_an_entity"
		explode(pos, node_name, self)
	end,
})
minetest.register_abm({
	nodenames = {"normal_mine:mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("Counting_Down") == 1 then
			if meta:get_int("Time_Until_Activation")>0 then
				meta:set_int("Time_Until_Activation", meta:get_int("Time_Until_Activation")-1)
			else
				local node = minetest.env:get_node(pos)
				node.name = ("normal_mine:active_mine")
				minetest.env:add_node(pos,node)
			end
		end
	end,
})
minetest.register_craft({
	output = '"normal_mine:mine" 4',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'normal_mine:gunpowder', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})
minetest.register_craft({
	output = '"normal_mine:gunpowder" 4',
	recipe = {
		{'', 'default:gravel', ''},
		{'default:gravel', 'default:coal_lump', 'default:gravel'},
		{'', 'default:gravel', ''},
	}
})