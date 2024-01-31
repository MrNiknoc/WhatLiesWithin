local effectivity = 1
local layers = {
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/primitive-burner-generator.png",
      priority = "extra-high",
      line_length = 1,
      frame_count = 1,
      repeat_count = 48,
      animation_speed = 0.5,
      width = 81,
      height = 64,
      --shift = util.by_pixel(0, -10),
      hr_version = {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/hr-primitive-burner-generator.png",
        priority = "extra-high",
        line_length = 1,
        frame_count = 1,
        repeat_count = 48,
        animation_speed = 0.5,
        width = 151,
        height = 146,
        --shift = util.by_pixel(0, -10),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/primitive-burner-generator-shadow.png",
      priority = "extra-high",
      width = 81,
      height = 64,
      shift = util.by_pixel(14.5, 2),
      draw_as_shadow = true,
      repeat_count = 48,
      hr_version = {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/hr-primitive-burner-generator-shadow.png",
        priority = "extra-high",
        width = 164,
        height = 74,
        scale = 0.5,
        draw_as_shadow = true,
        shift = util.by_pixel(14.5, 13),
        repeat_count = 48,
      }
    }
  }
}
local fire_glow = {
  filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/primitive-burner-generator-glow.png",
  priority = "extra-high",
  line_length = 1,
  frame_count = 1,
  repeat_count = 48,
  animation_speed = 1,
  width = 54,
  height = 74,
  --shift = util.by_pixel(0, 4),
  blend_mode = "additive",
  draw_as_glow = true,
  hr_version = {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/hr-primitive-burner-generator-glow.png",
    priority = "extra-high",
    line_length = 1,
    frame_count = 1,
    repeat_count = 48,
    animation_speed = 1,
    width = 106,
    height = 144,
    --shift = util.by_pixel(0, 5),
    blend_mode = "additive",
    scale = 0.5,
    draw_as_glow = true
  }
}
local fire_light = {
  filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/primitive-burner-generator-fire.png",
  priority = "extra-high",
  line_length = 8,
  frame_count = 48,
  animation_speed = 1,
  width = 160/8,
  height = 294/6,
  shift = util.by_pixel(-0.5, 5.5),
  blend_mode = "additive",
  draw_as_light = true,
  hr_version = {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/primitive-burner-generator/hr-primitive-burner-generator-fire.png",
    priority = "extra-high",
    line_length = 8,
    frame_count = 48,
    animation_speed = 1,
    width = 328/8,
    height = 600/6,
    shift = util.by_pixel(-0.75, 5.5),
    blend_mode = "additive",
    scale = 0.5,
    draw_as_light = true,
  }
}
local fire_and_glow = {
  layers = {
    fire_glow,
    fire_light
  }
}
local burner_generator = {
  type = "burner-generator",
  name = "wlw-primitive-burner-generator",
  icon = "__WhatLiesWithinGraphics__/graphics/icons/primitive-burner-generator.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-neutral", "player-creation", "not-rotatable"},
  minable = {mining_time = 0.5, result = "wlw-primitive-burner-generator"},
  max_health = 250,
  corpse = "small-remnants",
  placeable_by = 
    {
        {
            item = "wlw-primitive-burner-generator",
            count = 1
        }
    },
  vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
  resistances =
  {
    { type = "fire", percent = 100 },
    { type = "explosion", percent = 30 },
    { type = "impact", percent = 50 }
  },
  collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
  selection_box = {{-0.8, -1}, {0.8, 1}},
  max_power_output = "20kW",
  burner =
  {
    type = "burner",
    fuel_categories = {"chemical"},
    effectivity = effectivity,
    fuel_inventory_size = 2,
    emissions_per_minute = 5,
    light_flicker =
    {
      minimum_light_size = 1,
      light_intensity_to_size_coefficient = 0.25,
      color = {1,0.6,0},
      minimum_intensity = 0.05,
      maximum_intensity = 0.3
    },
    smoke =
    {
      {
        name = "smoke",
        north_position = util.by_pixel(20, -55),
        south_position = util.by_pixel(20, -55),
        east_position = util.by_pixel(20, -55),
        west_position = util.by_pixel(20, -55),
        frequency = 30,
        starting_vertical_speed = 0.0,
        starting_frame_deviation = 60,
        deviation = {-1, 1},
      }
    }
  },
  energy_source = {
    type = "electric",
    usage_priority = "secondary-output",
  },
  working_sound =
  {
    sound =
    {
      filename = "__base__/sound/furnace.ogg",
      volume = 1.6
    },
    max_sounds_per_type = 3
  },
  min_perceived_performance = 0.25,
  performance_to_sound_speedup = 0.5,
  idle_animation = {
    north = layers,
    south = layers,
    east = layers,
    west = layers,
  },
  always_draw_idle_animation = true,
  animation = {
    north = fire_and_glow,
    south = fire_and_glow,
    east = fire_and_glow,
    west = fire_and_glow,
  }
}
data:extend({burner_generator})