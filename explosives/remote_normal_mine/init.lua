--Remote Mine Mod


--register entities, tools & nodes
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
	inventory_image = "mines_remote_inactive",
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


minetest.register_abm({
	nodenames = {"remote_normal_mine:mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if got_signal(pos)==true then
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)
			for k, obj in pairs(objs) do				
				local position = pos
				local node_name = "remote_normal_mine:mine"
				local self = not_an_entity
				explode(position, node_name, self)
			end
		end
	end,
})

--crafting recipes
minetest.register_craft({
	output = '"remote_normal_mine:mine" 99',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'normal_mine:mine', ''},
		{'', '', ''},
	}
})
