local item_elevator = {
    name = "wlw-item-elevator",
    type = "linked-container",
    order = "wlw-item-elevator",
    icon = "__WhatLiesWithinGraphics__/graphics/icons/item-elevator.png",
    icon_size = 64,
    inventory_size = 50,
    corpse = "big-remnants",
    picture = {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/item-elevator/item-elevator.png",
        priority = "extra-high",
        width = 300,
        height = 300,
        hr_version =
        {
            filename = "__WhatLiesWithinGraphics__/graphics/entity/item-elevator/hr-item-elevator.png",
            priority = "extra-high",
            width = 608,
            height = 596,
            scale = 0.5
        }
    },
    placeable_by = {
        {
            item = "wlw-item-elevator",
            count = 1
        }
    },
    gui_mode = "all",
    collision_mask = { "item-layer", "object-layer", "player-layer", "water-tile"},
    -- for collision box one tile is 0.4 x 0.4
    dying_explosion = "rocket-silo-explosion",
    collision_box = {{-4.40, -4.40}, {4.40, 4.40}},
    selection_box = {{-4.5, -4.5}, {4.5, 4.5}},
    selection_priority = 49, -- We set this to 49 so that the medium electric pole that we put on top of it has a higher selection priority.
    drawing_box = {{-4.5, -4.5}, {4.5, 4.5}},
    allow_copy_paste = true,
    minable = {mining_time = 1, result = "wlw-item-elevator"},
    max_health = 400,
    is_military_target = false,
    create_ghost_on_death = true,
    selectable_in_game = true,
    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,
    gui_mode = "none",
    flags = {"not-rotatable", "player-creation"}
}

-- this line tells the game to use our prototype. NECESSARY!!!
data:extend{item_elevator}