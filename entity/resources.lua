local resource_autoplace = require("resource-autoplace")
local sounds = require("__base__.prototypes.entity.sounds")

local function resource(resource_parameters, autoplace_parameters)
    if coverage == nil then coverage = 0.02 end
  
    return
    {
      type = "resource",
      name = resource_parameters.name,
      icon = "__WhatLiesWithinGraphics__/graphics/icons/" .. resource_parameters.name:gsub("wlw%-","") .. ".png",
      icon_size = 64,
      icon_mipmaps = 4,
      flags = {"placeable-neutral"},
      order="a-b-"..resource_parameters.order,
      tree_removal_probability = 0.8,
      tree_removal_max_distance = 32 * 32,
      minable =
      {
        mining_particle = "iron-ore-particle",
        mining_time = resource_parameters.mining_time,
        result = resource_parameters.name
      },
      walking_sound = resource_parameters.walking_sound,
      collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      -- autoplace = autoplace_settings(name, order, coverage),
      autoplace = resource_autoplace.resource_autoplace_settings
      {
        name = resource_parameters.name,
        order = resource_parameters.order,
        base_density = autoplace_parameters.base_density,
        has_starting_area_placement = autoplace_parameters.starting_area_placement,
        regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
        starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
        candidate_spot_count = autoplace_parameters.candidate_spot_count
      },
      stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
      stages =
      {
        sheet =
        {
            filename = "__WhatLiesWithinGraphics__/graphics/entity/ores/" .. resource_parameters.name:gsub("wlw%-","") .. ".png",
            priority = "extra-high",
            size = 128,
            frame_count = 8,
            variation_count = 8,
            scale = 0.5
        }
      },
      map_color = resource_parameters.map_color,
      mining_visualisation_tint = resource_parameters.mining_visualisation_tint
    }
  end

data:extend(
    {
        resource(
            {
                name = "wlw-gold-ore",
                order = "b",
                map_color = {0.9, 0.9, 0},
                mining_time = 1,
                walking_sound = sounds.ore,
                mining_visualisation_tint = {r = 0.5, g = 0.5, b = 0, a = 1.000},
            },
            {
                base_density = 6,
                starting_area_placement = false,
                -- these are stone defaults, idk what they do yet so use them always.
                regular_rq_factor_multiplier = 1.0,
                starting_rq_factor_multiplier = 1.1
            }
        ),
        resource(
            {
                name = "wlw-lead-ore",
                order = "b",
                map_color = {46,65,94,255},
                mining_time = 1,
                walking_sound = sounds.ore,
                mining_visualisation_tint = {r = 0.5, g = 0, b = 0.5, a = 1.000},
            },
            {
                base_density = 6,
                starting_area_placement = false,
                -- these are stone defaults, idk what they do yet so use them always.
                regular_rq_factor_multiplier = 1.0,
                starting_rq_factor_multiplier = 1.1
            }
        ),
        resource(
            {
                name = "wlw-platinum-ore",
                order = "b",
                map_color = {80,255,80,255},
                mining_time = 1,
                walking_sound = sounds.ore,
                mining_visualisation_tint = {r = 0, g = 0.5, b = 0, a = 1.000},
            },
            {
                base_density = 6,
                starting_area_placement = false,
                -- these are stone defaults, idk what they do yet so use them always.
                regular_rq_factor_multiplier = 1.0,
                starting_rq_factor_multiplier = 1.1
            }
        ),
        resource(
            {
                name = "wlw-silver-ore",
                order = "b",
                map_color = {100,100,190,255},
                mining_time = 1,
                walking_sound = sounds.ore,
                mining_visualisation_tint = {r = 0.4, g = 0.4, b = 0.4, a = 1.000},
            },
            {
                base_density = 6,
                starting_area_placement = false,
                -- these are stone defaults, idk what they do yet so use them always.
                regular_rq_factor_multiplier = 1.0,
                starting_rq_factor_multiplier = 1.1
            }
        ),
        resource(
            {
                name = "wlw-tin-ore",
                order = "b",
                map_color = {200,200,200,255},
                mining_time = 1,
                walking_sound = sounds.ore,
                mining_visualisation_tint = {r = 0.9, g = 0.9, b = 0.9, a = 1.000},
            },
            {
                base_density = 6,
                starting_area_placement = true,
                -- these are stone defaults, idk what they do yet so use them always.
                regular_rq_factor_multiplier = 1.0,
                starting_rq_factor_multiplier = 1.1
            }
        ),
    }
)