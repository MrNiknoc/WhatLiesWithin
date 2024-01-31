-- copy the corpse of the building your entity is copying (e.g. wlw-casting-machine copies chemical-plant, so that's the corpse that the wlw-casting-maching corpse should copy hehe)

-- make copies at the top of this file, and change properties later on. Keep alphabetized for sanity :)
-- remember you only have to do properties that differ from the thing you're copying, of course. E.g. icon_size and icon_mipmaps are usually going to be the same.
-- don't forget to include your new corpse in the data:extend() at the end of the file :)

local alloying_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])
local casting_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])
local melting_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])

alloying_machine.name = "wlw-alloying-machine-remnants"
alloying_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/alloying-machine.png"
alloying_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/remnants/alloying-machine-remnants.png"
alloying_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/remnants/hr-alloying-machine-remnants.png"

casting_machine.name = "wlw-casting-machine-remnants"
casting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/casting-machine.png"
casting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/remnants/casting-machine-remnants.png"
casting_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/remnants/hr-casting-machine-remnants.png"

melting_machine.name = "wlw-melting-machine-remnants"
melting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/melting-machine.png"
melting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/remnants/melting-machine-remnants.png"
melting_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/remnants/hr-melting-machine-remnants.png"

data:extend({alloying_machine, casting_machine, melting_machine})