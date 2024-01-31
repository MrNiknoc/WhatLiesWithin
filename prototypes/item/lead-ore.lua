-- this is the item, not the ore resource. The resource can be found in prototypes/entity.
-- create a local variable to copy an existing prototype.
local leadore = table.deepcopy(data.raw["item"]["stone"])

leadore.name = "wlw-lead-ore"
leadore.icon = "__WhatLiesWithinGraphics__/graphics/icons/lead-ore.png"
leadore.order = "wlw-lead-ore"
leadore.subgroup = "raw-resource"

leadore.pictures =
{
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/lead-ore.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/lead-ore-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/lead-ore-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/lead-ore-3.png", scale = 0.25, mipmap_count = 4 }
}


-- this line tells the game to use our prototype. NECESSARY!!!
data:extend{leadore}