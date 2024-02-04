-- this is where we place our AutoplaceControl(s) for ores and other things. They won't work without one :)

data:extend(
    {
        {
            type = "autoplace-control",
            name = "wlw-gold-ore",
            richness = true,
            order = "wlw-gold-ore",
            can_be_disabled = false,
            category = "resource"
        },
        {
            -- prototype type
            type = "autoplace-control",
            -- always wlw-blank-ore for ores
            name = "wlw-lead-ore",
            -- whether richeness can be modified in the map gen settings
            richness = true,
            -- Used to order prototypes in inventory, recipes and GUI's. Always wlw-blank-ore to keep our stuff ordered together.
            order = "wlw-lead-ore",
            -- can this be disabled? in this case it's necessary to beat the game so no.
            can_be_disabled = false,
            -- which category to be displayed in within the map gen settings, always resource for ores
            category = "resource"
        },
        {
            type = "autoplace-control",
            name = "wlw-platinum-ore",
            richness = true,
            order = "wlw-platinum-ore",
            can_be_disabled = false,
            category = "resource"
        },
        {
            type = "autoplace-control",
            name = "wlw-silver-ore",
            richness = true,
            order = "wlw-silver-ore",
            can_be_disabled = false,
            category = "resource"
        },
        {
            type = "autoplace-control",
            name = "wlw-tin-ore",
            richness = true,
            order = "wlw-tin-ore",
            can_be_disabled = false,
            category = "resource"
        }
    }
)