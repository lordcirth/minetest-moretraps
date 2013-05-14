--Remote Mine Mod
local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5
local MINE_ACTIVE=false
local NORMAL_MINE_REMOTE_POSITION_X=0
local NORMAL_MINE_REMOTE_POSITION_Y=0
local NORMAL_MINE_REMOTE_POSITION_Z=0
local NORMAL_MINE_REMOTE_DETECTION_RADIUS=30
--register entities, tools & nodes
minetest.register_node("remote_normal_mine:remote_normal_mine", {
	description  = "Remote Mine",
   	tile_images = {"mine_mine_top.png", "mine_mine_bottom.png",
		"mine_mine_side.png", "mine_mine_side.png",
		"mine_mine_side.png", "mine_mine_side.png",
	},
	inventory_image = minetest.inventorycube("mine_mine_top.png", "mine_mine_side.png", "mine_mine_side.png"),
   	groups = {cracky=2,oddly_breakable_by_hand=5,flammable=1,explody=9},
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
	inventory_image  = "remote.png",
	tiles = {"mines_remote_active.png"},
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
		print ("remote normal mine is deactivated by remote")
		NORMAL_MINE_REMOTE_POSITION_X=pos.x
		NORMAL_MINE_REMOTE_POSITION_Y=pos.y
		NORMAL_MINE_REMOTE_POSITION_Z=pos.z
		MINE_ACTIVE = false
		local node = minetest.env:get_node(pos)
		node.name = ("remote_normal_mine:inactive_remote")
		minetest.env:add_node(pos,node)
      end,
})
minetest.register_node("remote_normal_mine:inactive_remote", {
	description  = "Mine Remote",
	inventory_image  = "remote.png",
	tiles = {"mines_remote_active.png"},
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
		MINE_ACTIVE = true
		local node = minetest.env:get_node(pos)
		node.name = ("remote_normal_mine:active_remote")
		minetest.env:add_node(pos,node)
      end,
})
--ABM's
minetest.register_abm({
	nodenames = {"remote_normal_mine:remote_normal_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if MINE_ACTIVE==true then
			if NORMAL_MINE_REMOTE_POSITION_X >= (pos.x - NORMAL_MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_X <= (pos.x + NORMAL_MINE_REMOTE_DETECTION_RADIUS) then
				if NORMAL_MINE_REMOTE_POSITION_Y >= (pos.y - NORMAL_MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_Y <= (pos.y + NORMAL_MINE_REMOTE_DETECTION_RADIUS) then
					if NORMAL_MINE_REMOTE_POSITION_Z >= (pos.z - NORMAL_MINE_REMOTE_DETECTION_RADIUS) and NORMAL_MINE_REMOTE_POSITION_Z <= (pos.z + NORMAL_MINE_REMOTE_DETECTION_RADIUS) then
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
		{'', 'default:coal_lump', ''},
		{'default:coal_lump', 'default:coal_lump', ''},
		{'', '', ''},
	}
})
minetest.register_craft({
	output = '"remote_normal_mine:inactive_remote" 1',
	recipe = {
		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
		{'', '', ''},
		{'', '', ''},
	}
})