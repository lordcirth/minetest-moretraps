--Mine Mod
local MINE_DAMAGE=1
local MINE_VERTICAL_VELOCITY=5
local IS_LOCAL_MINE_COUNTDOWN_NIL = true
local COUNTDOWN_TIME = 10
local is_path_clear = false
--register entities & nodes
minetest.register_craftitem("normal_mine:gunpowder", {
    inventory_image = "throwing_string.png",
})
minetest.register_node("normal_mine:mine", {
    description  = "Mine",
    tiles = {"inactive_mine_top.png", "inactive_mine_bottom.png",
        "inactive_mine_side.png", "inactive_mine_side.png",
        "inactive_mine_side.png", "inactive_mine_side.png",
    },
    on_punch = function (pos, node)                     --on punch, make counting down true, which causes the inactive mine abm to begin counting down to mine activation
        local meta = minetest.env:get_meta(pos)
        meta:set_int("Counting_Down", 1)
        meta:set_int("Time_Until_Activation", COUNTDOWN_TIME)
    end,
    paramtype = "light",
    inventory_image  = "inventory_image.png",
    groups = {cracky=2,oddly_breakable_by_hand=5,flammable=3,explody=9},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
        {-.25,-.5,-.25,.25,-.375,.25},
        }
    },
})
minetest.register_node("normal_mine:active_mine", {
    tiles = {"active_mine_top.png", "active_mine_bottom.png",
        "active_mine_side.png", "active_mine_side.png",
        "active_mine_side.png", "active_mine_side.png",
    },
    paramtype = "light",
    inventory_image  = "mines_remote_inactive.png",
    groups = {cracky=2,oddly_breakable_by_hand=5,flammable=3,explody=9},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
        {-.25,-.5,-.25,.25,-.375,.25},
        }
    },
})
--ABM's
minetest.register_abm({
    nodenames = {"normal_mine:active_mine"},
    interval = 1,
    chance = 1,
    action = function(pos)
            local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 5)         
                for k, obj in pairs(objs) do                                          
local node_name = "normal_mine:active_mine"
	local self = not_an_entity
		explode(pos, node_name, self)

                    
                end
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
                print ("placing active mine node")
                minetest.env:add_node(pos,node)
            end
        end
    end,
})

--crafting recipies
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