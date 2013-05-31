
local remote_pos = {}
local range = 30
local REMOTE_ACTIVATION_TIME = 2
local COUNTDOWN_TIME = 2
local MINE_REMOTE_ACTIVE = false

get_distance = function (pos, mine_pos)
	return math.sqrt((mine_pos.x-pos.x)^2 + (mine_pos.y-pos.y)^2 + (mine_pos.y-pos.y)^2)
end

got_signal = function (mine_pos)
	print ("function got_signal called")
	if MINE_REMOTE_ACTIVE == true then
		if get_distance(remote_pos, mine_pos) < range then
			return true
		end
	end
end



minetest.register_node("remote:active_remote", {
	description  = "Mine Remote",
	groups = {cracky=7,oddly_breakable_by_hand=9,flammable=0,explody=0},
	paramtype = "light",
	inventory_image  = "mine_inventory_image",
 	    tiles = {"active_remote_top", "active_remote_bottom",
        "active_remote_side", "active_remote_side",
        "active_remote_side", "active_remote_side",
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
	inventory_image  = "remote_inventory_image",
	 tiles = {"inactive_remote_top", "inactive_remote_bottom",
        "inactive_remote_side", "inactive_remote_side",
        "inactive_remote_side", "inactive_remote_side",
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
		print ("remote activated")
		remote_pos = {x=pos.x, y=pos.y, z=pos.z}
		MINE_REMOTE_ACTIVE = true
		local node = minetest.env:get_node(pos)
		node.name = ("remote:active_remote")
		minetest.env:add_node(pos,node)
      end,
})

--ABM's

minetest.register_abm({
	nodenames = {"remote:active_remote"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if COUNTDOWN_TIME <= 0 then
			COUNTDOWN_TIME = REMOTE_ACTIVATION_TIME
			print ("remote is deactivated")
			MINE_REMOTE_ACTIVE = false
			local node = minetest.env:get_node(pos)
			node.name = ("remote:remote")
			minetest.env:add_node(pos,node)

		else
			COUNTDOWN_TIME=COUNTDOWN_TIME-1
		end
	end,
	on_punch = function(pos)
		print ("remote deactivated")
		MINE_REMOTE_ACTIVE = false
		local node = minetest.env:get_node(pos)
		node.name = ("remote:remote")
		minetest.env:add_node(pos,node)
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