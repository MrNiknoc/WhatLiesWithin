-- KEEP ALPHABETIZED IT WILL MAKE IT EASIER TO FIND STUFF!!!

-- autoplace controls
require("prototypes.autoplace-controls")

-- corpses
require("prototypes.remnants")

-- custom input
require("prototypes.custom-input")

-- entities
require("prototypes.entity.entities")
require("prototypes.entity.item-elevator")
require("prototypes.entity.primitive-burner-generator")
require("prototypes.entity.resources")
require("prototypes.entity.turrets")
require("prototypes.entity.units")

-- fluids
require("prototypes.fluid.fluids")

-- items
require("prototypes.item.charcoal")
require("prototypes.item.fertilizer")
-- items holds everything that was made once I decided to put it all in one file :)
require("prototypes.item.items")
require("prototypes.item.lead-block")
require("prototypes.item.lead-ingot")
require("prototypes.item.lead-ore")
require("prototypes.item.lead-plate")
require("prototypes.item.lead-sheet")
require("prototypes.item.sapling")
require("prototypes.item.item-elevator")
require("prototypes.item.wood-chips")

-- recipes
require("prototypes.recipes")

-- recipe categories
require("prototypes.recipe-categories")

-- shortcuts (toolbar shortcuts)
require("prototypes.shortcut")

-- technologies
require("prototypes.technologies")

-- ***************************
-- ***************************
--      VANILLA TWEAKS
-- ***************************
-- ***************************

-- change furnaces to allow for multiple ingredient recipes
for name, prototype in pairs(data.raw.furnace) do
    local newfurnace = table.deepcopy(prototype)
    newfurnace.type = "assembling-machine"
    newfurnace.source_inventory_size = 2
    newfurnace.energy_source.emissions_per_minute = 2
    newfurnace.energy_usage = "0.2MW"
    data.raw.furnace[name] = nil
    data:extend({newfurnace})
end

-- add a dummy recipe-category prototype that we can put our dummy furnace in.
data:extend({
    {type = "recipe-category", name = "dummy"}
})
-- add a dummy furnace prototype, the game needs at least 1 defined apparently.
-- check if we've already created the dummyfurnace (should only happen if release branch and dev branch are both active)
-- and if we have, change the name of the new dummyfurnace prototype to be unique.
local num_of_dummy_furnaces = 0
for name, prototype in pairs(data.raw["assembling-machine"]) do
    if string.match(prototype.name, "wlw-dummy-furnace") then
        num_of_dummy_furnaces = num_of_dummy_furnaces + 1
    end
end
local dummyfurnace =
{
       type = "furnace",
       name = "wlw-dummy-furnace" .. num_of_dummy_furnaces,
       icon = "__base__/graphics/icons/stone-furnace.png",
       icon_size = 64, icon_mipmaps = 4,
       energy_source = {type = "electric", usage_priority = "secondary-input"},
       energy_usage = "0.1KJ",
       crafting_speed = 1,
       crafting_categories = {"dummy"},
       source_inventory_size = 1,
       result_inventory_size = 1
}
data:extend({dummyfurnace})

-- change plate icons to fit the plate > ingot > sheet > block convention. (plate = iron plate, ingot = steel-plate, sheet = stone-brick, block = solid-fuel)
data.raw["item"]["copper-plate"].icon = "__WhatLiesWithin__/graphics/icons/copper-plate.png"
data.raw["item"]["iron-plate"].icon = "__WhatLiesWithin__/graphics/icons/iron-plate.png"
data.raw["item"]["steel-plate"].icon = "__WhatLiesWithin__/graphics/icons/steel-plate.png"

-- change stone, iron, and copper ore graphics to fit new plate colors
data.raw["item"]["iron-ore"].icon = "__WhatLiesWithin__/graphics/icons/iron-ore.png"
data.raw["item"]["iron-ore"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/iron-ore.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/iron-ore-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/iron-ore-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/iron-ore-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["iron-ore"].stages.sheet =
{
    filename = "__WhatLiesWithin__/graphics/entity/ores/iron.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5
}
data.raw["item"]["copper-ore"].icon = "__WhatLiesWithin__/graphics/icons/copper-ore.png"
data.raw["item"]["copper-ore"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/copper-ore.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/copper-ore-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/copper-ore-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/copper-ore-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["copper-ore"].stages.sheet =
{
    filename = "__WhatLiesWithin__/graphics/entity/ores/copper.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5
}
data.raw["item"]["stone"].icon = "__WhatLiesWithin__/graphics/icons/stone.png"
data.raw["item"]["stone"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/stone.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/stone-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/stone-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithin__/graphics/icons/stone-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["stone"].stages.sheet =
{
    filename = "__WhatLiesWithin__/graphics/entity/ores/stone.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5
}

-- change stone, iron, and copper map colors to fit new graphics
data.raw["resource"]["iron-ore"].map_color = {r=0.9}
data.raw["resource"]["copper-ore"].map_color = {r=0.75,g=0.4}
data.raw["resource"]["stone"].map_color = {r=0.4,g=0.4,b=0.2}

-- change intermediate copper and iron product graphics to fit new plate colors
data.raw["item"]["copper-cable"].icon = "__WhatLiesWithin__/graphics/icons/copper-cable.png"
data.raw["item"]["iron-gear-wheel"].icon = "__WhatLiesWithin__/graphics/icons/iron-gear-wheel.png"
data.raw["item"]["iron-stick"].icon = "__WhatLiesWithin__/graphics/icons/iron-stick.png"

-- change green wires to be more? distinguishable from platinum cable
data.raw["item"]["green-wire"].icon = "__WhatLiesWithin__/graphics/icons/green-wire.png"

-- change steel processing research icon to match steel plates
data.raw["technology"]["steel-processing"].icon = "__WhatLiesWithin__/graphics/icons/steel-plate.png"
data.raw["technology"]["steel-processing"].icon_size = 64

-- lock electric energy distribution 1 (this will lock electric energy distribution 2 as well) behind precision smelting (the better poles require silver, gold, and platinum cables)
data.raw["technology"]["electric-energy-distribution-1"].prerequisites = {"wlw-precision-smelting", "electronics", "logistic-science-pack", "steel-processing"}
-- lock advanced electronics (red circuits) behind precision smelting as well.
data.raw["technology"]["advanced-electronics"].prerequisites = {"wlw-precision-smelting", "plastics"}

-- make all lamps military targets (makes them a high priority for biters)
for name, prototype in pairs(data.raw.lamp) do
    prototype.is_military_target = true
end

-- change all trees to have a chance to drop saplings
for name, prototype in pairs(data.raw.tree) do
    prototype.minable = {mining_time = 0.5, results = {{name="wood", amount_min=1, amount_max=4}, {name="wlw-sapling", amount_min=0, amount_max=4, probability=0.20}}}
end

-- change red circuits to use silver cable,
data.raw["recipe"]["advanced-circuit"].normal.ingredients =
{
    {type = "item", name = "wlw-silver-cable", amount = 4},
    {type = "item", name = "electronic-circuit", amount = 2},
    {type = "item", name = "plastic-bar", amount = 2}
}
data.raw["recipe"]["advanced-circuit"].expensive.ingredients =
{
    {type = "item", name = "wlw-silver-cable", amount = 8},
    {type = "item", name = "electronic-circuit", amount = 2},
    {type = "item", name = "plastic-bar", amount = 4}
}
--  blue circuits to use gold cable,
data.raw["recipe"]["processing-unit"].normal.ingredients =
{
    {type = "item", name = "wlw-gold-cable", amount = 4},
    {type = "item", name = "advanced-circuit", amount = 2},
    {type = "item", name = "electronic-circuit", amount = 20},
    {type = "fluid", name = "sulfuric-acid", amount = 5}
}
data.raw["recipe"]["processing-unit"].expensive.ingredients =
{
    {type = "item", name = "wlw-gold-cable", amount = 8},
    {type = "item", name = "advanced-circuit", amount = 2},
    {type = "item", name = "electronic-circuit", amount = 20},
    {type = "fluid", name = "sulfuric-acid", amount = 10}
}

-- rocket control units to use multi-core-processing-units and efficiency modules 2s,
data.raw["recipe"]["rocket-control-unit"].ingredients =
{
    {type = "item", name = "wlw-multi-core-processing-unit", amount = 1},
    {type = "item", name = "effectivity-module-2", amount = 1}
}

-- burner inserters to use tin plates,
data.raw["recipe"]["burner-inserter"].ingredients =
{
    {type = "item", name = "wlw-tin-plate", amount = 1},
    {type = "item", name = "iron-gear-wheel", amount = 1}
}

-- medium electric poles to use silver cable,
data.raw["recipe"]["medium-electric-pole"].ingredients =
{
    {type = "item", name = "copper-plate", amount = 2},
    {type = "item", name = "iron-stick", amount = 4},
    {type = "item", name = "steel-plate", amount = 2},
    {type = "item", name = "wlw-silver-cable", amount = 2}
}

-- big electric poles to use gold cable,
data.raw["recipe"]["big-electric-pole"].ingredients =
{
    {type = "item", name = "copper-plate", amount = 5},
    {type = "item", name = "iron-stick", amount = 8},
    {type = "item", name = "steel-plate", amount = 5},
    {type = "item", name = "wlw-gold-cable", amount = 2}
}

-- substations to use platinum cable,
data.raw["recipe"]["substation"].ingredients =
{
    {type = "item", name = "advanced-circuit", amount = 5},
    {type = "item", name = "copper-plate", amount = 5},
    {type = "item", name = "steel-plate", amount = 10},
    {type = "item", name = "wlw-platinum-cable", amount = 2}
}

-- land mines to only produce one mine per explosive, and use lead.
data.raw["recipe"]["land-mine"].ingredients = 
{
    {type = "item", name = "wlw-lead-plate", amount = 4},
    {type = "item", name = "explosives", amount = 1}
}

data.raw["recipe"]["land-mine"].results =
{
    {type = "item", name = "land-mine", amount = 1}
}

-- make land mines have a smaller trigger radius, damage radius, do less damage, arm slower, and have less health.
data.raw["land-mine"]["land-mine"].trigger_radius = 1
-- This timeout is in ticks, 1800 = 30s.
data.raw["land-mine"]["land-mine"].timeout = 1800
-- Small biters do 7 damage in vanilla, they should 1 shot unarmed land mines.
data.raw["land-mine"]["land-mine"].max_health = 7
data.raw["land-mine"]["land-mine"].action =
{
  type = "direct",
  action_delivery =
  {
    type = "instant",
    source_effects =
    {
      {
        type = "nested-result",
        affects_target = true,
        action =
        {
          type = "area",
          radius = 1,
          force = "enemy",
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = { amount = 25, type = "explosion"}
              },
              {
                type = "create-sticker",
                sticker = "stun-sticker"
              }
            }
          }
        }
      },
      {
        type = "create-entity",
        entity_name = "explosion"
      },
      {
        type = "damage",
        damage = { amount = 10, type = "explosion"}
      }
    }
  }
}

-- change all units to prefer targeting low health enemies
for name, prototype in pairs(data.raw["unit"]) do
    data.raw["unit"][name].attack_parameters.health_penalty = 0.5
end

-- change all turrets (in vanilla "turrets" are just worms, not laser turrets/gun turrets) to prefer targeting high health enemies
for name, prototype in pairs(data.raw["turret"]) do
    data.raw["turret"][name].attack_parameters.health_penalty = -0.5
end

-- ***************************
-- ***************************
--      END VANILLA TWEAKS
-- ***************************
-- ***************************


-- ***************************
-- ***************************
--      WLW TWEAKS
-- ***************************
-- ***************************


-- recipe alterations go in this loop.
for name, prototype in pairs(data.raw.recipe) do
    -- TODO: automatically generate melting recipes for anything that uses metal as an ingredient.
    
    -- change all wlw recipes to have allow_decomposition = false
    if string.match(prototype.name, "wlw-") then
        prototype.allow_decomposition = false
    end
    -- change all alloying/casting/melting recipes to have hide_from_player_crafting = true
    if prototype.category then
        if string.match(prototype.category, "-alloying") or string.match(prototype.category, "-casting") or string.match(prototype.category, "-melting") then
            prototype.hide_from_player_crafting = true
        end
    end
end

-- ***************************
-- ***************************
--      END WLW TWEAKS
-- ***************************
-- ***************************


-- STYLES
local styles = data.raw["gui-style"].default

styles["wlw-content-frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["wlw-controls-flow"] = {
    type = "horizontal_flow_style",
    vertical_align = "center",
    horizontal_spacing = 16
}

styles["wlw-controls-textfield"] = {
    type = "textbox_style",
    width = 36
}

styles["wlw-deep-frame"] = {
    type = "frame_style",
    parent = "slot_button_deep_frame",
    vertically_stretchable = "on",
    horizontally_stretchable = "on",
    top_margin = 16,
    left_margin = 8,
    right_margin = 8,
    bottom_margin = 4
}