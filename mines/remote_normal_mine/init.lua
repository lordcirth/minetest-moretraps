--Remote Mine Mod
MINE_REMOTE_ACTIVE=false
local REMOTE_ACTIVATION_TIME=2
local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5
MINE_REMOTE_POSITION_X=0
MINE_REMOTE_POSITION_Y=0
MINE_REMOTE_POSITION_Z=0
MINE_REMOTE_DETECTION_RADIUS=30
--register entities, tools & nodes
minetest.register_node("remote_normal_mine:remote_normal_mine", {
	description  = "Remote Mine",
   	    tiles = {"active_mine_top", "active_mine_bottom",
        "active_mine_side", "active_mine_side",
        "active_mine_side", "active_mine_side",
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
minetest.register_node("remote_normal_mine:active_remote", {
	description  = "Mine Remote",
	groups = {cracky=7,oddly_breakable_by_hand=9,flammable=0,explody=0},
	paramtype = "light",
	inventory_image  = "mine_inventory_image",
 	    tiles = {"active_remote_top", "active_remote_bottom",
        "active_remote_side", "active_remote_side",
        "active_remote_side", "active_remote_side",
    },	
	node_box = {
		type = "fixed",
		fixed = {
		{-.5,-.5,-.5,.5,.25,.5},
		{-.4,.25,-.4,.4,.3,.4},
		{-.05,.25,-.05,.05,.5,.05},
		}
	},
})
minetest.register_node("remote_normal_mine:inactive_remote", {
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
		print ("remote normal mine is activated by remote")
		MINE_REMOTE_POSITION_X=pos.x
		MINE_REMOTE_POSITION_Y=pos.y
		MINE_REMOTE_POSITION_Z=pos.z
		MINE_REMOTE_ACTIVE = true
		local node = minetest.env:get_node(pos)
		node.name = ("remote_normal_mine:active_remote")
		minetest.env:add_node(pos,node)
      end,
})

--ABM's

minetest.register_abm({
	nodenames = {"remote_normal_mine:active_remote"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if REMOTE_ACTIVATION_TIME <= 0 then
			print ("remote normal mine is deactivated by remote")
						REMOTE_ACTIVATION_TIME=2
			MINE_REMOTE_POSITION_X=pos.x
			MINE_REMOTE_POSITION_Y=pos.y
			MINE_REMOTE_POSITION_Z=pos.z
			MINE_REMOTE_ACTIVE = false
			local node = minetest.env:get_node(pos)
			node.name = ("remote_normal_mine:inactive_remote")
			minetest.env:add_node(pos,node)

		else
			REMOTE_ACTIVATION_TIME=REMOTE_ACTIVATION_TIME-1
		end
	end,
})

minetest.register_abm({
	nodenames = {"remote_normal_mine:remote_normal_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if MINE_REMOTE_ACTIVE==true then
			if MINE_REMOTE_POSITION_X >= (pos.x - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_X <= (pos.x + MINE_REMOTE_DETECTION_RADIUS) then
				if MINE_REMOTE_POSITION_Y >= (pos.y - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Y <= (pos.y + MINE_REMOTE_DETECTION_RADIUS) then
					if MINE_REMOTE_POSITION_Z >= (pos.z - MINE_REMOTE_DETECTION_RADIUS) and MINE_REMOTE_POSITION_Z <= (pos.z + MINE_REMOTE_DETECTION_RADIUS) then
						local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)
						for k, obj in pairs(objs) do				
							local position = pos
							local node_name = "remote_normal_mine:remote_normal_mine"
							local self = not_an_entity
							explode(position, node_name, self)
						end
					end
				end
			end
		end
	end,
})

--crafting recipes
minetest.register_craft({
	output = '"remote_normal_mine:remote_normal_mine" 99',
	recipe = {
		{'', 'default:stick', ''},
		{'', 'normal_mine:normal_inactive_mine', ''},
		{'', '', ''},
	}
})
minetest.register_craft({
	output = '"remote_normal_mine:inactive_remote" 1',
	recipe = {
		{'', 'default:stick', ''},
		{'default:steel_ingot', 'default:mese_crystal', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})