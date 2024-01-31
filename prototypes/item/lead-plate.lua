-- create a local variable to copy an existing prototype.
local leadplate = table.deepcopy(data.raw["item"]["iron-plate"])

leadplate.name = "wlw-lead-plate"
leadplate.icon = "__WhatLiesWithinGraphics__/graphics/icons/lead-plate.png"
leadplate.subgroup = "raw-material"
leadplate.order = "wlw-lead-plate"

-- this line tells the game to use our prototype. NECESSARY!!!
data:extend{leadplate}