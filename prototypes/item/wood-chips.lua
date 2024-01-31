local woodchips = table.deepcopy(data.raw["item"]["iron-stick"])

woodchips.name = "wlw-wood-chips"
woodchips.icon = "__WhatLiesWithinGraphics__/graphics/icons/wood-chips.png"
woodchips.stack_size = 200
woodchips.fuel_value = "500KJ"
woodchips.fuel_category = "chemical"
woodchips.order = "a[wood-chips]"
woodchips.subgroup = "raw-resource"

data:extend{woodchips}