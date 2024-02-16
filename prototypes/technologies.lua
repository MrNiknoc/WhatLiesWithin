data:extend(
    {
        {
            type = "technology",
            name = "wlw-alloying",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/alloying-machine.png",
            icon_size = 64,
            prerequisites = {"wlw-casting"},
            unit =
            {
                count = 300,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-alloying-machine"},
                -- all the molten alloys should be unlocked here.
                {type = "unlock-recipe", recipe = "wlw-molten-electrum"}
            }
        },
        {
            type = "technology",
            name = "wlw-arboriculture",
            icon = "__base__/graphics/icons/wood.png",
            icon_size = 64,
            prerequisites = {"wlw-fertilizer","automation-2"},
            unit =
            {
                count = 100,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {
                    type = "unlock-recipe",
                    recipe = "wlw-wood"
                }
            }
        },
        {
            type = "technology",
            name = "wlw-biter-butchery-1",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/biter-butchery-1.png",
            icon_size = 64,
            localised_name = "Biter butchery 1",
            localised_description = "Unlocks the ability to butcher biter larvae and pupae. You'll need something to feed your growing swarm...",
            prerequisites = {"automation", "logistic-science-pack"},
            unit = 
            {
                count = 50,
                ingredients = 
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butchering-machine-1"},
                {type = "unlock-recipe", recipe = "wlw-butcher-biter-larva"},
                {type = "unlock-recipe", recipe = "wlw-butcher-biter-pupa"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-butchery-2",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/biter-butchery-2.png",
            icon_size = 64,
            localised_name = "Biter butchery 2",
            localised_description = "You can now chop up medium biters as well!",
            prerequisites = {"automation-2", "fluid-handling", "wlw-biter-butchery-1", "chemical-science-pack"},
            unit = 
            {
                count = 100,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butchering-machine-2"},
                {type = "unlock-recipe", recipe = "wlw-butcher-small-biter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-small-biter-untamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-medium-biter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-medium-biter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-butchery-3",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/biter-butchery-3.png",
            icon_size = 64,
            localised_name = "Biter butchery 3",
            localised_description = "You can now chop up big biters as well!",
            prerequisites = {"automation-3", "wlw-biter-husbandry-3", "wlw-biter-butchery-2"},
            unit = 
            {
                count = 200,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butchering-machine-3"},
                {type = "unlock-recipe", recipe = "wlw-butcher-big-biter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-big-biter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-butchery-4",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/biter-butchery-4.png",
            icon_size = 64,
            localised_name = "Biter butchery 4",
            localised_description = "You can now chop up behemoth biters as well!",
            prerequisites = {"wlw-biter-butchery-3", "utility-science-pack"},
            unit = 
            {
                count = 400,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1},
                    {"utility-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butcher-behemoth-biter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-behemoth-biter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-husbandry-1",
            icon = "__base__/graphics/icons/small-biter.png",
            icon_size = 64,
            localised_name = "Biter husbandry 1",
            localised_description = "Husbandry machines allow you to incubate and train your very own biter swarm! Biters have excellent night vision.",
            prerequisites = {"military-2", "wlw-biter-butchery-1", "wlw-fertilizer"},
            unit = 
            {
                count = 50,
                ingredients = 
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-machine-1"},
                {type = "unlock-recipe", recipe = "wlw-biter-incubation-1"},
                {type = "unlock-recipe", recipe = "wlw-biter-incubation-2"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-small-biter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-small-biter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-small-biter"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-husbandry-2",
            icon = "__base__/graphics/icons/medium-biter.png",
            icon_size = 64,
            localised_name = "Biter husbandry 2",
            localised_description = "Unlock the ability to grow and train your very own medium biters.",
            prerequisites = {"wlw-biter-husbandry-1", "wlw-biter-butchery-2", "military-science-pack", "chemical-science-pack"},
            unit = 
            {
                count = 100,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-machine-2"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-small-biter-to-medium"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-medium-biter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-medium-biter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-medium-biter"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-husbandry-3",
            icon = "__base__/graphics/icons/big-biter.png",
            icon_size = 64,
            localised_name = "Biter husbandry 3",
            localised_description = "Unlock the ability to grow and train your very own big biters.",
            prerequisites = {"wlw-biter-husbandry-2", "production-science-pack", "military-3"},
            unit = 
            {
                count = 200,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 2},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-machine-3"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-medium-biter-to-big"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-big-biter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-big-biter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-big-biter"}
            }
        },
        {
            type = "technology",
            name = "wlw-biter-husbandry-4",
            icon = "__base__/graphics/icons/behemoth-biter.png",
            icon_size = 64,
            localised_name = "Biter husbandry 4",
            localised_description = "Unlock the ability to grow and train your very own behemoth biters.",
            prerequisites = {"wlw-biter-husbandry-3", "utility-science-pack", "military-4"},
            unit = 
            {
                count = 400,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1},
                    {"utility-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-big-biter-to-behemoth"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-behemoth-biter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-behemoth-biter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-behemoth-biter"}
            }
        },
        {
            type = "technology",
            name = "wlw-casting",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/casting-machine.png",
            icon_size = 64,
            prerequisites = {"wlw-melting"},
            unit =
            {
                count = 200,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 20
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-casting-machine"},
                {type = "unlock-recipe", recipe = "wlw-copper-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-copper-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-copper-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-copper-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-gold-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-gold-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-gold-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-gold-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-iron-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-iron-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-iron-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-iron-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-lead-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-lead-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-lead-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-lead-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-platinum-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-platinum-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-platinum-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-platinum-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-silver-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-silver-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-silver-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-silver-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-steel-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-steel-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-steel-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-steel-sheet-cast"},
                {type = "unlock-recipe", recipe = "wlw-tin-block-cast"},
                {type = "unlock-recipe", recipe = "wlw-tin-ingot-cast"},
                {type = "unlock-recipe", recipe = "wlw-tin-plate-cast"},
                {type = "unlock-recipe", recipe = "wlw-tin-sheet-cast"}
            }
        },
        {
            type = "technology",
            name = "wlw-charcoal",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/charcoal.png",
            icon_size = 64,
            prerequisites = {"advanced-material-processing"},
            unit =
            {
                count = 50,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {
                    type = "unlock-recipe",
                    recipe = "wlw-charcoal"
                }
            }
        },
        {
            type = "technology",
            name = "wlw-coke",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/coke.png",
            icon_size = 64,
            prerequisites = {"wlw-charcoal", "advanced-material-processing"},
            unit =
            {
                count = 100,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 15
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-coke"}
            }
        },
        {
            type = "technology",
            name = "wlw-fertilizer",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/fertilizer.png",
            icon_size = 64,
            prerequisites = {"wlw-wood-processing"},
            unit =
            {
                count = 100,
                ingredients =
                {
                    {"automation-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-fertilizer"}
            }
        },
        {
            type = "technology",
            name = "wlw-high-density-steel",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/high-density-steel.png",
            icon_size = 64,
            prerequisites = {"wlw-precision-smelting", "wlw-coke", "chemical-science-pack"},
            unit =
            {
                count = 200,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-high-density-steel"}
            }
        },
        {
            type = "technology",
            name = "wlw-high-density-structure",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/high-density-structure.png",
            icon_size = 64,
            prerequisites = {"wlw-high-density-steel", "low-density-structure", "wlw-casting", "production-science-pack"},
            unit =
            {
                count = 300,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1}
                },
                time = 15
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-high-density-structure"}
            }
        },
        {
            type = "technology",
            name = "wlw-item-elevator",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/item-elevator.png",
            icon_size = 64,
            prerequisites = {"logistic-science-pack", "concrete"},
            unit =
            {
                count = 300,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-item-elevator"}
            }
        },
        {
            type = "technology",
            name = "wlw-landfill-from-fertilizer-and-biter-meat",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/landfill-from-fertilizer-and-biter-meat.png",
            icon_size = 64,
            prerequisites = {"wlw-landfill-from-wood-chips", "wlw-biter-butchery-1"},
            unit =
            {
                count = 50,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-landfill-from-fertilizer-and-biter-meat"}
            }
        },
        {
            type = "technology",
            name = "wlw-landfill-from-wood-chips",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/landfill-from-wood-chips.png",
            icon_size = 256,
            prerequisites = {"logistic-science-pack", "landfill", "automation-2", "wlw-wood-processing"},
            unit =
            {
                count = 50,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-landfill-from-wood-chips"}
            }
        },
        {
            type = "technology",
            name = "wlw-metal-compacting",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/gold-block.png",
            icon_size = 64,
            prerequisites = {"wlw-precision-smelting", "chemical-science-pack"},
            unit =
            {
                count = 100,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-copper-block"},
                {type = "unlock-recipe", recipe = "wlw-copper-ingot"},
                {type = "unlock-recipe", recipe = "wlw-copper-sheet"},
                {type = "unlock-recipe", recipe = "wlw-copper-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-copper-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-copper-sheet-unpack"},
                {type = "unlock-recipe", recipe = "wlw-gold-block"},
                {type = "unlock-recipe", recipe = "wlw-gold-ingot"},
                {type = "unlock-recipe", recipe = "wlw-gold-sheet"},
                {type = "unlock-recipe", recipe = "wlw-gold-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-gold-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-gold-sheet-unpack"},
                {type = "unlock-recipe", recipe = "wlw-iron-block"},
                {type = "unlock-recipe", recipe = "wlw-iron-ingot"},
                {type = "unlock-recipe", recipe = "wlw-iron-sheet"},
                {type = "unlock-recipe", recipe = "wlw-iron-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-iron-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-iron-sheet-unpack"},
                {type = "unlock-recipe", recipe = "wlw-lead-block"},
                {type = "unlock-recipe", recipe = "wlw-lead-ingot"},
                {type = "unlock-recipe", recipe = "wlw-lead-sheet"},
                {type = "unlock-recipe", recipe = "wlw-lead-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-lead-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-lead-sheet-unpack"},
                {type = "unlock-recipe", recipe = "wlw-silver-block"},
                {type = "unlock-recipe", recipe = "wlw-silver-ingot"},
                {type = "unlock-recipe", recipe = "wlw-silver-sheet"},
                {type = "unlock-recipe", recipe = "wlw-silver-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-silver-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-silver-sheet-unpack"},
                {type = "unlock-recipe", recipe = "wlw-tin-block"},
                {type = "unlock-recipe", recipe = "wlw-tin-ingot"},
                {type = "unlock-recipe", recipe = "wlw-tin-sheet"},
                {type = "unlock-recipe", recipe = "wlw-tin-block-unpack"},
                {type = "unlock-recipe", recipe = "wlw-tin-ingot-unpack"},
                {type = "unlock-recipe", recipe = "wlw-tin-sheet-unpack"},
            }
        },
        {
            type = "technology",
            name = "wlw-melting",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/melting-machine.png",
            icon_size = 64,
            prerequisites = {"wlw-metal-compacting", "chemical-science-pack"},
            unit =
            {
                count = 200,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 20
            },
            effects =
            {
                {type = "unlock-recipe", recipe= "wlw-melting-machine"},
                {type = "unlock-recipe", recipe = "wlw-copper-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-copper-cable-melt"},
                {type = "unlock-recipe", recipe = "wlw-copper-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-copper-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-copper-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-copper-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-cable-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-gold-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-iron-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-iron-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-iron-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-iron-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-iron-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-lead-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-lead-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-lead-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-lead-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-lead-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-cable-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-platinum-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-cable-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-silver-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-steel-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-steel-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-steel-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-steel-sheet-melt"},
                {type = "unlock-recipe", recipe = "wlw-tin-block-melt"},
                {type = "unlock-recipe", recipe = "wlw-tin-ingot-melt"},
                {type = "unlock-recipe", recipe = "wlw-tin-ore-melt"},
                {type = "unlock-recipe", recipe = "wlw-tin-plate-melt"},
                {type = "unlock-recipe", recipe = "wlw-tin-sheet-melt"}
            }
        },
        {
            type = "technology",
            name = "wlw-multi-core-processing-unit",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/multi-core-processing-unit.png",
            icon_size = 64,
            prerequisites = {"wlw-alloying", "advanced-electronics-2", "production-science-pack"},
            unit =
            {
                count = 300,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-multi-core-processing-unit"}
            }
        },
        {
            type = "technology",
            name = "wlw-precision-smelting",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/gold-plate.png",
            icon_size = 64,
            prerequisites = {"advanced-material-processing"},
            unit =
            {
                count = 200,
                ingredients =
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-lead-plate"},
                {type = "unlock-recipe", recipe = "wlw-gold-cable"},
                {type = "unlock-recipe", recipe = "wlw-gold-plate"},
                {type = "unlock-recipe", recipe = "wlw-platinum-cable"},
                {type = "unlock-recipe", recipe = "wlw-platinum-plate"},
                {type = "unlock-recipe", recipe = "wlw-silver-cable"},
                {type = "unlock-recipe", recipe = "wlw-silver-plate"}
            }
        },
        {
            type = "technology",
            name = "wlw-primitive-burner-generator",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/primitive-burner-generator.png",
            icon_size = 64,
            unit = 
            {
                count = 50,
                ingredients =
                {
                    {"automation-science-pack", 1}
                },
                time = 30
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-primitive-burner-generator"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-butchery-1",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/spitter-butchery-1.png",
            icon_size = 64,
            localised_name = "Spitter butchery 1",
            localised_description = "Unlocks the ability to butcher spitter larvae and pupae.",
            prerequisites = {"wlw-biter-butchery-1"},
            unit = 
            {
                count = 50,
                ingredients = 
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butcher-spitter-larva"},
                {type = "unlock-recipe", recipe = "wlw-butcher-spitter-pupa"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-butchery-2",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/spitter-butchery-2.png",
            icon_size = 64,
            localised_name = "Spitter butchery 2",
            localised_description = "You can now chop up medium spitters as well!",
            prerequisites = {"wlw-biter-butchery-2", "wlw-spitter-butchery-1"},
            unit = 
            {
                count = 100,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butcher-small-spitter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-small-spitter-untamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-medium-spitter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-medium-spitter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-butchery-3",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/spitter-butchery-3.png",
            icon_size = 64,
            localised_name = "Spitter butchery 3",
            localised_description = "You can now chop up big spitters as well!",
            prerequisites = {"wlw-biter-butchery-3", "wlw-spitter-butchery-2"},
            unit = 
            {
                count = 200,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butcher-big-spitter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-big-spitter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-butchery-4",
            icon = "__WhatLiesWithinGraphics__/graphics/technology/spitter-butchery-4.png",
            icon_size = 64,
            localised_name = "Spitter butchery 4",
            localised_description = "You can now chop up behemoth spitters as well!",
            prerequisites = {"wlw-biter-butchery-4", "wlw-spitter-butchery-3"},
            unit = 
            {
                count = 400,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1},
                    {"utility-science-pack", 1}
                },
                time = 20
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-butcher-behemoth-spitter-tamed"},
                {type = "unlock-recipe", recipe = "wlw-butcher-behemoth-spitter-untamed"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-husbandry-1",
            icon = "__base__/graphics/icons/small-spitter.png",
            icon_size = 64,
            localised_name = "Spitter husbandry 1",
            localised_description = "Unlock the ability to grow and train your very own small spitters. Spitters have excellent night vision!",
            prerequisites = {"wlw-biter-husbandry-1"},
            unit = 
            {
                count = 50,
                ingredients = 
                {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-spitter-incubation-1"},
                {type = "unlock-recipe", recipe = "wlw-spitter-incubation-2"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-small-spitter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-small-spitter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-small-spitter"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-husbandry-2",
            icon = "__base__/graphics/icons/medium-spitter.png",
            icon_size = 64,
            localised_name = "Spitter husbandry 2",
            localised_description = "Unlock the ability to grow and train your very own medium spitters.",
            prerequisites = {"wlw-biter-husbandry-2", "wlw-spitter-husbandry-1"},
            unit = 
            {
                count = 100,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 1},
                    {"chemical-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-small-spitter-to-medium"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-medium-spitter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-medium-spitter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-medium-spitter"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-husbandry-3",
            icon = "__base__/graphics/icons/big-spitter.png",
            icon_size = 64,
            localised_name = "Spitter husbandry 3",
            localised_description = "Unlock the ability to grow and train your very own big spitters.",
            prerequisites = {"wlw-biter-husbandry-3", "wlw-spitter-husbandry-2"},
            unit = 
            {
                count = 200,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 2},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-medium-spitter-to-big"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-big-spitter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-big-spitter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-big-spitter"}
            }
        },
        {
            type = "technology",
            name = "wlw-spitter-husbandry-4",
            icon = "__base__/graphics/icons/behemoth-spitter.png",
            icon_size = 64,
            localised_name = "Spitter husbandry 4",
            localised_description = "Unlock the ability to grow and train your very own behemoth spitters.",
            prerequisites = {"wlw-biter-husbandry-4", "wlw-spitter-husbandry-3"},
            unit = 
            {
                count = 400,
                ingredients = 
                {
                    {"automation-science-pack", 2},
                    {"logistic-science-pack", 2},
                    {"military-science-pack", 2},
                    {"chemical-science-pack", 2},
                    {"production-science-pack", 1},
                    {"utility-science-pack", 1}
                },
                time = 30
            },
            effects = 
            {
                {type = "unlock-recipe", recipe = "wlw-husbandry-big-spitter-to-behemoth"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-tame-behemoth-spitter"},
                {type = "unlock-recipe", recipe = "wlw-husbandry-behemoth-spitter-breeding"},
                {type = "unlock-recipe", recipe = "wlw-exploding-behemoth-spitter"}
            }
        },
        {
            type = "technology",
            name = "wlw-wood-processing",
            icon = "__WhatLiesWithinGraphics__/graphics/icons/wood-chips.png",
            icon_size = 64,
            unit =
            {
                count = 10,
                ingredients =
                {
                    {"automation-science-pack", 1}
                },
                time = 10
            },
            effects =
            {
                {type = "unlock-recipe", recipe = "wlw-wood-chips"},
                {type = "unlock-recipe", recipe = "wlw-wood-chips-from-saplings"}
            }
        }
    }
)