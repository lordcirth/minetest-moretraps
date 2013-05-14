
--Mine Mod

local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5	
local MINE_COUNTDOWN=10	
local COUNTING_DOWN=false

--register entities & nodes

minetest.register_node("normal_mine:normal_inactive_mine", {
	description  = "Mine",
   	tile_images = {"mine_mine_top.png", "mine_mine_bottom.png",
		"mine_mine_side.png", "mine_mine_side.png",
		"mine_mine_side.png", "mine_mine_side.png",
	},
	on_punch = function (pos, node)						--on punch, make counting down true, which causes the inactive mine abm to begin counting down to mine activation
        COUNTING_DOWN=true
    end,
	inventory_image = minetest.inventorycube("mine_mine_top.png", "mine_mine_side.png", "mine_mine_side.png"),
    groups = {cracky=2,oddly_breakable_by_hand=5,flammable=1,explody=9},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
		{-.25,-.5,-.25,.25,-.375,.25},
		}
	},
})

minetest.register_node("normal_mine:normal_active_mine", {
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
		{-.1,-.375,-.1,.1,-.2,.1},
		}
		},
})

--ABM's

minetest.register_abm({
	nodenames = {"normal_mine:normal_active_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
			local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)           --get the objects within 5 blocks
				for k, obj in pairs(objs) do									 		  --if there are 2 entities in the radius(1 for the mine and one for the target) then
					if minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= air then	 	 --if the block 1 space above is not air, remove it
						minetest.env:dig_node({x=pos.x,y=pos.y+1,z=pos.z})
					end	
					if minetest.env:get_node({x=pos.x,y=pos.y+2,z=pos.z}).name ~= air then		  --if the block 2 spaces above is not air, remove it
						minetest.env:dig_node({x=pos.x,y=pos.y+2,z=pos.z})
					end
					local objs5 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)	--gets the objects within a specific radius and assigns them different names
					local objs4 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 4)
					local objs3 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 3)
					local objs2 = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)					
						print ("mine entity causing damage")
						for k, obj in pairs(objs5) do
							obj:set_hp(obj:get_hp()-MINE_DAMAGE)							--remove health from the objects within each of the different distances from the mine
							for k, obj in pairs(objs4) do									--the closer the object is to the mine, the more times health gets removed, so if the object is within 2 blocks, it
								obj:set_hp(obj:get_hp()-MINE_DAMAGE)						--would get 4*MINE_DAMAGE health removed, because it is within the 5,4,3,and 2 radius zones
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
					end
					local obj=minetest.env:dig_node(pos)
		end,
})

minetest.register_abm({
	nodenames = {"normal_mine:normal_inactive_mine"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if COUNTING_DOWN == true then
			if MINE_COUNTDOWN<=0 then
				COUNTING_DOWN=false
				MINE_COUNTDOWN=10
				local node = minetest.env:get_node(pos)
				node.name = ("normal_mine:normal_active_mine")
				print ("placing active mine node")
				minetest.env:add_node(pos,node)
			else
				print ("[mine] mine countdown = "..MINE_COUNTDOWN.."")
				MINE_COUNTDOWN=MINE_COUNTDOWN-1
			end
		end
	end
})

--crafting recipies	

minetest.register_craft({
	output = '"normal_mine:normal_inactive_mine" 99',
	recipe = {
		{'', '', ''},
		{'', 'default:coal_lump', ''},
		{'', 'default:coal_lump', ''},
	}
})
