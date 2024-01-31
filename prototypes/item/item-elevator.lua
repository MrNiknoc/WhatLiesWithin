local item_elevator = {
    name = "wlw-item-elevator",
    type = "item-with-tags",
    order = "wlw-item-elevator",
    icon = "__WhatLiesWithinGraphics__/graphics/icons/item-elevator.png",
    -- this is the height of the icon, for example this file is 120(width) x 64(height)
    icon_size = 64,
    stack_size = 50,
    place_result = "wlw-item-elevator",
    subgroup = "transport"
}

data:extend{item_elevator}