local flip_map = {
    a = "b", b = "a",
    c = "d", d = "c",
}

local function shift_by_2(param2)
    param2 = (param2 or 0) + 2
    if (param2 >= 4) then param2 = param2 - 4 end
    return param2
end

minetest.register_tool("door_flipper:flipper", {
    description = "Door Flipper",
    wield_image = "door_flipper_flipper.png",
    inventory_image = "door_flipper_flipper.png",
    
    on_use = function(itemstack, user, pointed)
        local player, pos, node, state, new_name
        
        if pointed.type ~= "node" then return itemstack end
        
        player = user:get_player_name()
        
        pos = pointed.under
        node = minetest.get_node(pos)
        
        state = node.name:match("_([abcd])$")
        if state then goto found end
        
        pos = vector.offset(pos, 0, -1, 0)
        node = minetest.get_node(pos)
        
        state = node.name:match("_([abcd])$")
        if state then goto found end
        
        if true then return itemstack end -- bypass optimization
        
        ::found::
        
        if minetest.is_protected(pos, player) then return itemstack end
        
        new_name = node.name:sub(1, -2)..flip_map[state]
        minetest.swap_node(pos, { name = new_name, param2 = node.param2 })
        
        return itemstack
    end,
})
