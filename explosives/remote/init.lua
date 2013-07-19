--Mine remote

local remote_pos = {}
local range = 30
local remote_countdown = 2
local countdown = 5
local remote_active = false

get_distance = function(pos, mine_pos)
	return math.sqrt((mine_pos.x-pos.x)^2 + (mine_pos.y-pos.y)^2 + (mine_pos.y-pos.y)^2)
end

got_signal = function (mine_pos)
	if remote_active == true then
		if get_distance(remote_pos, mine_pos) < range then
			return true
		end
	end
end

minetest.register_node("remote:active_remote", {
	description  = "Mine Remote",
	groups = {cracky=7,oddly_breakable_by_hand=9,flammable=0,explody=0},
	paramtype = "light",
	inventory_image  = "remote_inventory_image.png",
 	tiles = {
		"remote_active_top.png", 
		"remote_active_bottom.png",
        "remote_active_side.png", 
		"remote_active_side.png",
        "remote_active_side.png", 
		"remote_active_side.png"
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
})

minetest.register_node("remote:remote", {
	description  = "Mine Remote",
	paramtype = "light",
	inventory_image  = "remote_inventory_image.png",
	tiles = {
		"remote_inactive_top.png", 
		"remote_inactive_bottom.png",
		"remote_inactive_side.png", 
		"remote_inactive_side.png",
		"remote_inactive_side.png", 
		"remote_inactive_side.png"
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
		remote_pos = {x=pos.x, y=pos.y, z=pos.z}
		remote_active = true
		local node = minetest.env:get_node(pos)
		node.name = ("remote:active_remote")
		minetest.env:add_node(pos, node)
    end,
})

minetest.register_abm({
	nodenames = {"remote:active_remote"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if countdown <= 0 then
			countdown = remote_countdown
			print ("remote normal mine is deactivated by remote")
			remote_active = false
			local node = minetest.env:get_node(pos)
			node.name = ("remote:remote")
			minetest.env:add_node(pos,node)
		else
			countdown=countdown-1
		end
	end,
})

minetest.register_craft({
	output = '"remote:remote" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'default:steel_ingot', 'default:mese_crystal', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})