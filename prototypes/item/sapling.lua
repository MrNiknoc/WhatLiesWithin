local sapling = table.deepcopy(data.raw["item"]["iron-stick"])

sapling.name="wlw-sapling"
sapling.icon = "__WhatLiesWithinGraphics__/graphics/icons/sapling.png" -- placeholder graphic, looks really bad lol
sapling.stack_size = 200
sapling.fuel_value = "100KJ"
sapling.fuel_category = "chemical"
sapling.order = "wlw-sapling"
sapling.subgroup = "raw-resource"

data:extend{sapling}