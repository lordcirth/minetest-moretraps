--Remote Mine Mod

minetest.register_node("remote_normal_mine:mine", {
	description  = "Remote Mine",
   	    tiles = {
		"active_top.png", 
		"active_bottom.png",
        "active_side.png", 
		"active_side.png",
        "active_side.png", 
		"active_side.png"
    },
	paramtype = "light",
	inventory_image = "remote_normal_mine_inventory_image.png",
   	groups = {cracky=4, oddly_breakable_by_hand=9, flammable=1, snappy = 1},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		{-.2,-.375,-.2,-.15,.1,-.15},
		}
	},
	on_punch = function (pos)
		local node_name = "remote_normal_mine:minee"
		local self = "not_an_entity"
		local mine_damage = 1
		local detection_radius = 5
		explode(pos, node_name, self, mine_damage, detection_radius)
		local node = minetest.env:get_node(pos)
		node.name = ("fire:basic_flame")
		minetest.env:add_node(pos,node)
	end,
})

minetest.register_abm({
	nodenames = {"remote_normal_mine:mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if got_signal(pos)==true then
			local position = pos
			local node_name = "remote_normal_mine:mine"
			local self = "not_an_entity"
			local mine_damage = 1
			local detection_radius = 5
			explode(pos, node_name, self, mine_damage, detection_radius)
			minetest.env:dig_node(pos)
		end
	end,
})

minetest.register_craft({
	output = '"remote_normal_mine:mine" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'normal_mine:mine', ''},
		{'', '', ''},
	}
})