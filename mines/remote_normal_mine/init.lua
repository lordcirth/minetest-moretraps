--Remote Mine Mod
MINE_REMOTE_ACTIVE=false
local REMOTE_ACTIVATION_TIME=2
local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5
local NORMAL_MINE_REMOTE_POSITION_X=0
local NORMAL_MINE_REMOTE_POSITION_Y=0
local NORMAL_MINE_REMOTE_POSITION_Z=0
MINE_REMOTE_DETECTION_RADIUS=30
--register entities, tools & nodes
minetest.register_node("remote_normal_mine:remote_normal_mine", {
	description  = "Remote Mine",
   	tiles = {
        'mines_remote_inactive.png',
    },
	paramtype = "light",
	inventory_image = "mines_remote_inactive.png",
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
	inventory_image  = "remote.png",
	tiles = {
        'mines_remote_inactive.png',
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
	inventory_image  = "mines_remote_inactive.png",
	tiles = {
        'mines_remote_inactive.png',
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
		NORMAL_MINE_REMOTE_POSITION_X=pos.x
		NORMAL_MINE_REMOTE_POSITION_Y=pos.y
		NORMAL_MINE_REMOTE_POSITION_Z=pos.z
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
		local ORIGINAL_REMOTE_ACTIVATION_TIME = REMOTE_ACTIVATION_TIME
		if REMOTE_ACTIVATION_TIME <= 0 then
			print ("remote normal mine is deactivated by remote")
			NORMAL_MINE_REMOTE_POSITION_X=pos.x
			NORMAL_MINE_REMOTE_POSITION_Y=pos.y
			NORMAL_MINE_REMOTE_POSITION_Z=pos.z
			MINE_REMOTE_ACTIVE = false
			local node = minetest.env:get_node(pos)
			node.name = ("remote_normal_mine:inactive_remote")
			minetest.env:add_node(pos,node)
			REMOTE_ACTIVATION_TIME=ORIGINAL_REMOTE_ACTIVATION_TIME
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
		print("mine remote(normal)= active")
		end
		if MINE_REMOTE_ACTIVE==true then
			if NORMAL_MINE_REMOTE_POSITION_X >= (pos.x - MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_X <= (pos.x + MINE_REMOTE_DETECTION_RADIUS) then
				if NORMAL_MINE_REMOTE_POSITION_Y >= (pos.y - MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_Y <= (pos.y + MINE_REMOTE_DETECTION_RADIUS) then
					if NORMAL_MINE_REMOTE_POSITION_Z >= (pos.z - MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_Z <= (pos.z + MINE_REMOTE_DETECTION_RADIUS) then
						print ("normal mine remotely activated and exploding")
						local objs5 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)	--gets the objects within a specific radius and assigns them different names
						local objs4 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 4)
						local objs3 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 3)
						local objs2 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
						for k, obj in pairs(objs5) do
						obj:set_hp(obj:get_hp()-MINE_DAMAGE)
							for k, obj in pairs(objs4) do
							obj:set_hp(obj:get_hp()-MINE_DAMAGE)
								for k, obj in pairs(objs3) do
								obj:set_hp(obj:get_hp()-MINE_DAMAGE)
									for k, obj in pairs(objs2) do
									obj:set_hp(obj:get_hp()-MINE_DAMAGE)
									end
								end
							end
						end
						for k, obj in pairs(objs5) do
							if obj:get_hp()<=0 then
								obj:remove()
							end
						end
						minetest.env:remove_node({x=pos.x,y=pos.y,z=pos.z})
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
		{'', '', ''},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})