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

-- item-groups
require("prototypes.item.item-groups")

-- item-subgroups
require("prototypes.item.item-subgroups")

-- recipes
require("prototypes.recipes")

-- recipe categories
require("prototypes.recipe-categories")

-- shortcuts (toolbar shortcuts)
require("prototypes.shortcut")

-- technologies
require("prototypes.technologies")

function allowProductivity(recipe)
    for _, prototype in pairs(data.raw.module) do

        if prototype.effect.productivity then
            if prototype.limitation ~= nil then
                local prod_table = prototype.limitation
                -- cables
                table.insert(prod_table, recipe)
            end
        end
    
    end
end

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
       result_inventory_size = 1,
       -- added this selection_box for compatibility with BottleneckLite
       selection_box = {{-0.1,-0.1}, {0.1,0.1}}
}
data:extend({dummyfurnace})

-- change plate icons to fit the plate > ingot > sheet > block convention. (plate = iron plate, ingot = steel-plate, sheet = stone-brick, block = solid-fuel)
data.raw["item"]["copper-plate"].icon = "__WhatLiesWithinGraphics__/graphics/icons/copper-plate.png"
data.raw["item"]["iron-plate"].icon = "__WhatLiesWithinGraphics__/graphics/icons/iron-plate.png"
data.raw["item"]["steel-plate"].icon = "__WhatLiesWithinGraphics__/graphics/icons/steel-plate.png"

-- change stone, iron, and copper ore graphics to fit new plate colors
data.raw["item"]["iron-ore"].icon = "__WhatLiesWithinGraphics__/graphics/icons/iron-ore.png"
data.raw["item"]["iron-ore"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/iron-ore.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/iron-ore-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/iron-ore-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/iron-ore-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["iron-ore"].stages.sheet =
{
    filename = "__WhatLiesWithinGraphics__/graphics/entity/ores/iron.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5
}
data.raw["item"]["copper-ore"].icon = "__WhatLiesWithinGraphics__/graphics/icons/copper-ore.png"
data.raw["item"]["copper-ore"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/copper-ore.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/copper-ore-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/copper-ore-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/copper-ore-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["copper-ore"].stages.sheet =
{
    filename = "__WhatLiesWithinGraphics__/graphics/entity/ores/copper.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5
}
data.raw["item"]["stone"].icon = "__WhatLiesWithinGraphics__/graphics/icons/stone.png"
data.raw["item"]["stone"].pictures = 
{
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/stone.png",   scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/stone-1.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/stone-2.png", scale = 0.25, mipmap_count = 4 },
    { size = 64, filename = "__WhatLiesWithinGraphics__/graphics/icons/stone-3.png", scale = 0.25, mipmap_count = 4 }
}
data.raw["resource"]["stone"].stages.sheet =
{
    filename = "__WhatLiesWithinGraphics__/graphics/entity/ores/stone.png",
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
data.raw["item"]["copper-cable"].icon = "__WhatLiesWithinGraphics__/graphics/icons/copper-cable.png"
data.raw["item"]["iron-gear-wheel"].icon = "__WhatLiesWithinGraphics__/graphics/icons/iron-gear-wheel.png"
data.raw["item"]["iron-stick"].icon = "__WhatLiesWithinGraphics__/graphics/icons/iron-stick.png"

-- change green wires to be more? distinguishable from platinum cable
data.raw["item"]["green-wire"].icon = "__WhatLiesWithinGraphics__/graphics/icons/green-wire.png"

-- change steel processing research icon to match steel plates
data.raw["technology"]["steel-processing"].icon = "__WhatLiesWithinGraphics__/graphics/icons/steel-plate.png"
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

-- medium electric poles to use silver cable, and have a supply_area_distance of 4.5 (9 tiles vs 7)
data.raw["recipe"]["medium-electric-pole"].ingredients =
{
    {type = "item", name = "copper-plate", amount = 2},
    {type = "item", name = "iron-stick", amount = 4},
    {type = "item", name = "steel-plate", amount = 2},
    {type = "item", name = "wlw-silver-cable", amount = 2}
}

data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 4.5

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

-- power armor mk1 to use high density steel
data.raw["recipe"]["power-armor"].ingredients =
{
    {type = "item", name = "wlw-high-density-steel", amount = 40},
    {type = "item", name = "processing-unit", amount = 40},
    {type = "item", name = "electric-engine-unit", amount = 20}
}

-- power armor mk2 to use high density structure instead of low density structure and multi-core-processing-units instead of processing-units
data.raw["recipe"]["power-armor-mk2"].ingredients =
{
    {type = "item", name = "wlw-multi-core-processing-unit", amount = 60},
    {type = "item", name = "electric-engine-unit", amount = 40},
    {type = "item", name = "wlw-high-density-structure", amount = 30},
    {type = "item", name = "speed-module-2", amount = 25},
    {type = "item", name = "effectivity-module-2", amount = 25}
}

-- uranium fuel cells to use high density steel instead of iron
data.raw["recipe"]["uranium-fuel-cell"].ingredients =
{
    {type = "item", name = "wlw-high-density-steel", amount = 10},
    {type = "item", name = "uranium-235", amount = 1},
    {type = "item", name = "uranium-238", amount = 19}
}

-- rocket fuel to also use steel plates
data.raw["recipe"]["rocket-fuel"].ingredients =
{
    {type = "item", name = "steel-plate", amount = 2},
    {type = "item", name = "solid-fuel", amount = 10},
    {type = "fluid", name = "light-oil", amount = 10}
}

-- nuclear fuel to also use high density steel
data.raw["recipe"]["nuclear-fuel"].ingredients =
{
    {type = "item", name = "wlw-high-density-steel", amount = 2},
    {type = "item", name = "rocket-fuel", amount = 1},
    {type = "item", name = "uranium-235", amount = 1}
}

-- nuclear reactor to use gold plates instead of copper plates and high density steel instead of steel
data.raw["recipe"]["nuclear-reactor"].ingredients =
{
    {type = "item", name = "wlw-gold-plate", amount = 500},
    {type = "item", name = "wlw-high-density-steel", amount = 500},
    {type = "item", name = "advanced-circuit", amount = 500},
    {type = "item", name = "concrete", amount = 500}
}

-- solar panels to use advanced circuits instead of electronic circuits
data.raw["recipe"]["solar-panel"].ingredients =
{
    {type = "item", name = "copper-plate", amount = 5},
    {type = "item", name = "steel-plate", amount = 5},
    {type = "item", name = "advanced-circuit", amount = 15}
}

-- accumulators to use steel plates instead of iron plates and take 4 silver cable to craft
data.raw["recipe"]["accumulator"].ingredients =
{
    {type = "item", name = "steel-plate", amount = 2},
    {type = "item", name = "wlw-silver-cable", amount = 4},
    {type = "item", name = "battery", amount = 5}
}

-- explosive cannon shells to use high density steel instead of steel
data.raw["recipe"]["explosive-cannon-shell"].ingredients =
{
    {type = "item", name = "wlw-high-density-steel", amount = 2},
    {type = "item", name = "plastic-bar", amount = 2},
    {type = "item", name = "explosives", amount = 2}
}

-- artillery turrets to use high density structure instead of steel
data.raw["recipe"]["artillery-turret"].ingredients = 
{
    {type = "item", name = "wlw-high-density-structure", amount = 60},
    {type = "item", name = "iron-gear-wheel", amount = 40},
    {type = "item", name = "advanced-circuit", amount = 20},
    {type = "item", name = "concrete", amount = 60}
}

-- artillery wagons to use high density structure instead of steel
data.raw["recipe"]["artillery-wagon"].ingredients =
{
    {type = "item", name = "wlw-high-density-structure", amount = 40},
    {type = "item", name = "iron-gear-wheel", amount = 10},
    {type = "item", name = "advanced-circuit", amount = 20},
    {type = "item", name = "engine-unit", amount = 64},
    {type = "item", name = "pipe", amount = 16}
}

-- electric furnaces to use high density steel instead of steel
data.raw["recipe"]["electric-furnace"].ingredients =
{
    {type = "item", name = "wlw-high-density-steel", amount = 10},
    {type = "item", name = "advanced-circuit", amount = 5},
    {type = "item", name = "stone-brick", amount = 10}
}

-- rocket silo to use high density structure instead of steel and multi core processing units instead of processing units
data.raw["recipe"]["rocket-silo"].ingredients =
{
    {type = "item", name = "wlw-high-density-structure", amount = 1000},
    {type = "item", name = "wlw-multi-core-processing-unit", amount = 200},
    {type = "item", name = "electric-engine-unit", amount = 200},
    {type = "item", name = "pipe", amount = 100},
    {type = "item", name = "concrete", amount = 1000}
}

-- satellites to use multi core processing units instead of processing units
data.raw["recipe"]["satellite"].ingredients =
{
    {type = "item", name = "wlw-multi-core-processing-unit", amount = 100},
    {type = "item", name = "low-density-structure", amount = 100},
    {type = "item", name = "rocket-fuel", amount = 50},
    {type = "item", name = "solar-panel", amount = 100},
    {type = "item", name = "accumulator", amount = 100},
    {type = "item", name = "radar", amount = 5}
}

-- low density structures to use tin instead of steel
data.raw["recipe"]["low-density-structure"].ingredients =
{
    {type = "item", name = "copper-plate", amount = 20},
    {type = "item", name = "wlw-tin-plate", amount = 20},
    {type = "item", name = "plastic-bar", amount = 5}
}

-- centrifuges to use lead instead of steel
data.raw["recipe"]["centrifuge"].ingredients =
{
    {type = "item", name = "wlw-lead-plate", amount = 50},
    {type = "item", name = "iron-gear-wheel", amount = 100},
    {type = "item", name = "advanced-circuit", amount = 100},
    {type = "item", name = "concrete", amount = 100}
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

-- change biter spawners and spitter spawners to have a low chance of dropping a larva when killed.
for name, prototype in pairs(data.raw["unit-spawner"]) do
    if string.find(name, "biter") then
        data.raw["unit-spawner"][name].loot = 
        {
            {
                count_max = 10,
                count_min = 1,
                item = "wlw-biter-larva",
                probability = 0.1
            }
        }
    elseif string.find(name, "spitter") then
        data.raw["unit-spawner"][name].loot = 
        {
            {
                count_max = 10,
                count_min = 1,
                item = "wlw-spitter-larva",
                probability = 0.1
            }
        }
    end
end

-- hide and disable all nightvision recipes, also make their power draws 100YW in case someone does get one somehow..
for name, prototype in pairs(data.raw["night-vision-equipment"]) do
    data.raw["night-vision-equipment"][name].enabled = false
    data.raw["night-vision-equipment"][name].hidden = true
    data.raw["night-vision-equipment"][name].energy_input = "100YW"
end

-- hide the night-vision-equipment tech.
data.raw["technology"]["night-vision-equipment"].hidden = true

-- change the intensity and size of the omnidirectional personal light to compensate for no night vision.
for name, prototype in pairs(data.raw["character"]) do
    if prototype.light == nil then prototype.light = {} end
    if prototype.light ~= nil then
        for _, light in pairs(prototype.light) do
            if type(light) == "table" then
                if light.type == "basic" then
                    -- this is the circle of light around the player
                    light.intensity = 1
                    light.size = 100
                elseif light.type == "oriented" then
                    -- this is the flashlight
                    light.intensity = 1
                end
            end
        end
    end
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

-- Allow productivity modules to be used on some WLW recipes.

allowProductivity("wlw-silver-cable")
allowProductivity("wlw-gold-cable")
allowProductivity("wlw-platinum-cable")
allowProductivity("wlw-gold-plate")
allowProductivity("wlw-lead-plate")
allowProductivity("wlw-platinum-plate")
allowProductivity("wlw-silver-plate")
allowProductivity("wlw-tin-plate")
allowProductivity("wlw-high-density-steel")
allowProductivity("wlw-high-density-structure")
allowProductivity("wlw-multi-core-processing-unit")
allowProductivity("wlw-wood")
allowProductivity("wlw-wood-chips")
allowProductivity("wlw-wood-chips-from-saplings")
allowProductivity("wlw-fertilizer")
allowProductivity("wlw-charcoal")
allowProductivity("wlw-coke")

for _, prototype in pairs(data.raw.recipe) do
    -- Allow productivity on all butchering recipes
    if prototype.category == "wlw-butchery" or prototype.category == "wlw-butchery-with-fluid" then
        allowProductivity(prototype.name)
    end

    -- Don't allow productivity on any husbandry recipes.
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