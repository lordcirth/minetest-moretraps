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
			explode(position, node_name, self)
			minetest.env:dig_node(pos)
			local node = minetest.env:get_node(pos)
			node.name = ("fire:basic_flame")
			minetest.env:add_node(pos,node)
		end
	end,
})
minetest.register_craft({
	output = '"remote_normal_mine:mine" 99',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'normal_mine:mine', ''},
		{'', '', ''},
	}
})