data:extend(
    {
        {
            type = "fluid",
            name = "wlw-freshwater",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/freshwater.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-freshwater",
            default_temperature = 15,
            max_temperature = 100,
            heat_capacity = "0.2KJ",
            base_color = {r=0, g=0.34, b=0.6},
            flow_color = {r=0.9, g=0.9, b=0.9}
        },
        {
            type = "fluid",
            name = "wlw-molten-copper",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-copper.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-copper",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.722, g=0.451, b=0.20},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.722, g=0.451, b=0.20}
        },
        {
            type = "fluid",
            name = "wlw-molten-electrum",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-electrum.png",
            icon_size = 64, icon_mipmaps = 4,
            oreder = "wlw-molten-electrum",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=57, g=255, b=20},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=57, g=255, b=20}
        },
        {
            type = "fluid",
            name = "wlw-molten-gold",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-gold.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-gold",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=1, g=0.843, b=0},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=1, g=0.843, b=0}
        },
        {
            type = "fluid",
            name = "wlw-molten-iron",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-iron.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-iron",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.75, g=0.6, b=0.6},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.75, g=0.6, b=0.6}
        },
        {
            type = "fluid",
            name = "wlw-molten-lead",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-lead.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-lead",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.294, g=0, b=0.51},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.294, g=0, b=0.51}
        },
        {
            type = "fluid",
            name = "wlw-molten-platinum",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-platinum.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-platinum",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.396, g=1, b=0.478},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.396, g=1, b=0.478}
        },
        {
            type = "fluid",
            name = "wlw-molten-silver",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-silver.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-silver",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0, g=0.784, b=0.784},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0, g=0.784, b=0.784}
        },
        {
            type = "fluid",
            name = "wlw-molten-steel",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-steel.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-steel",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.294, g=0.294, b=0.294},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.294, g=0.294, b=0.294}
        },
        {
            type = "fluid",
            name = "wlw-molten-tin",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/molten-tin.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-molten-tin",
            default_temperature = 200,
            -- Joules needed to heat 1 Unit by 1 degree Celsius (may need adjusting)
            heat_capacity = "0.1KJ",
            -- base_color is used for filling bars like flamethrower turret bar in tooltip
            base_color = {r=0.667, g=0.667, b=0.667},
            -- flow_color is used for pipe windows or storage tank fill gauges. I don't see why they can't be the same /shrug
            flow_color = {r=0.667, g=0.667, b=0.667}
        },
        {
            type = "fluid",
            name = "wlw-saltwater",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fluid/saltwater.png",
            icon_size = 64, icon_mipmaps = 4,
            order = "wlw-saltwater",
            default_temperature = 15,
            max_temperature = 100,
            heat_capacity = "0.2KJ",
            -- these colors are pulled from vanilla water.
            base_color = {r=0, g=0.34, b=0.6},
            flow_color = {r=0.7, g=0.7, b=0.7}
        },
    }
)