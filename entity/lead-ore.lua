-- this is the ore resource, not the item. The item can be found in prototypes/item.
-- we need this line to be able to autoplace the ore.
local resource_autoplace = require("resource-autoplace")
-- create a local variable to copy an existing prototype.
-- we'll be using stone ore but turning it purple.
local leadore = table.deepcopy(data.raw["resource"]["stone"])

leadore.name = "wlw-lead-ore"
leadore.map_color = {46,65,94,255}

-- this is where the autoplace settings of our ore are set.
leadore.autoplace = resource_autoplace.resource_autoplace_settings {
    name = "wlw-lead-ore",
    -- all vanilla ores are order b, probably want order b for everything as well. vanilla oil is order c so it won't be placed if an order b thing is already there.
    order = "a-b-b",
    -- change base_density to have richer/less rich patches near the starting area. 10 is the default for vanilla iron ore whereas stone is 4.
    base_density = 4,
    -- should it be placed in the starting area? this forces that.
    has_starting_area_placement = false,
    -- everything below here is the default for stone. I'm not sure what they do.
    regular_rq_factor_multiplier = 1.0,
    starting_rq_factor_multiplier = 1.1,
}

-- this is where the graphics of our ore are set.
leadore.stages = {
    sheet = {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/ores/lead.png",
        priority = "extra-high",
        -- lead ore uses the high res version of stone graphics which has bigger tiles.
        size = 128,
        frame_count = 8,
        variation_count = 8,
        -- and high res graphics need to be scaled to 0.5 to fit 64x64.
        scale = 0.5
    }
}

leadore.minable = { mining_time = 1.25, result = "wlw-lead-ore", count = 1, mining_particle = "wooden-particle"}

-- this line tells the game to use our prototype. NECESSARY!!!
data:extend{leadore}