local fertilizer = table.deepcopy(data.raw["item"]["iron-stick"])

fertilizer.name = "wlw-fertilizer"
fertilizer.icon = "__WhatLiesWithinGraphics__/graphics/icons/fertilizer.png"
fertilizer.stack_size = 50
fertilizer.subgroup = "raw-resource"
fertilizer.order = "wlw-fertilizer"

data:extend{fertilizer}