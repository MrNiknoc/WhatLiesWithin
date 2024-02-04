-- copy the corpse of the building your entity is copying (e.g. wlw-casting-machine copies chemical-plant, so that's the corpse that the wlw-casting-maching corpse should copy hehe)

-- make copies at the top of this file, and change properties later on. Keep alphabetized for sanity :)
-- remember you only have to do properties that differ from the thing you're copying, of course. E.g. icon_size and icon_mipmaps are usually going to be the same.
-- don't forget to include your new corpse in the data:extend() at the end of the file :)

local alloying_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])
local butchering_machine_1 = table.deepcopy(data.raw["corpse"]["assembling-machine-1-remnants"])
local butchering_machine_2 = table.deepcopy(data.raw["corpse"]["assembling-machine-2-remnants"])
local butchering_machine_3 = table.deepcopy(data.raw["corpse"]["assembling-machine-3-remnants"])
local casting_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])
local husbandry_machine_1 = table.deepcopy(data.raw["corpse"]["assembling-machine-1-remnants"])
local husbandry_machine_2 = table.deepcopy(data.raw["corpse"]["assembling-machine-2-remnants"])
local husbandry_machine_3 = table.deepcopy(data.raw["corpse"]["assembling-machine-3-remnants"])
local melting_machine = table.deepcopy(data.raw["corpse"]["chemical-plant-remnants"])

-- The butchering machines use this function
function make_rotated_animation_variations_from_sheet(variation_count, sheet) --makes remnants work with more than 1 variation
    local result = {}
  
    local function set_y_offset(variation, i)
      local frame_count = variation.frame_count or 1
      local line_length = variation.line_length or frame_count
      if (line_length < 1) then
        line_length = frame_count
      end
  
      local height_in_frames = math.floor((frame_count * variation.direction_count + line_length - 1) / line_length)
      -- if (height_in_frames ~= 1) then
      --   log("maybe broken sheet: h=" .. height_in_frames .. ", vc=" .. variation_count .. ", " .. variation.filename)
      -- end
      variation.y = variation.height * (i - 1) * height_in_frames
    end
  
    for i = 1,variation_count do
      local variation = util.table.deepcopy(sheet)
  
      if variation.layers then
        for _, layer in pairs(variation.layers) do
          set_y_offset(layer, i)
          if (layer.hr_version) then
            set_y_offset(layer.hr_version, i)
          end
        end
      else
        set_y_offset(variation, i)
        if (variation.hr_version) then
          set_y_offset(variation.hr_version, i)
        end
      end
  
      table.insert(result, variation)
    end
   return result
  end

alloying_machine.name = "wlw-alloying-machine-remnants"
alloying_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/alloying-machine.png"
alloying_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/remnants/alloying-machine-remnants.png"
alloying_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/remnants/hr-alloying-machine-remnants.png"

butchering_machine_1.name = "wlw-butchering-machine-1-remnants"
butchering_machine_1.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-1.png"
butchering_machine_1.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/remnants/butchering-machine-1-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/remnants/hr-butchering-machine-1-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

butchering_machine_2.name = "wlw-butchering-machine-2-remnants"
butchering_machine_2.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-2.png"
butchering_machine_2.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/remnants/butchering-machine-2-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/remnants/hr-butchering-machine-2-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

butchering_machine_3.name = "wlw-butchering-machine-3-remnants"
butchering_machine_3.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-3.png"
butchering_machine_3.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/remnants/butchering-machine-3-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/remnants/hr-butchering-machine-3-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

casting_machine.name = "wlw-casting-machine-remnants"
casting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/casting-machine.png"
casting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/remnants/casting-machine-remnants.png"
casting_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/remnants/hr-casting-machine-remnants.png"

husbandry_machine_1.name = "wlw-husbandry-machine-1-remnants"
husbandry_machine_1.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-1.png"
husbandry_machine_1.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/remnants/husbandry-machine-1-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/remnants/hr-husbandry-machine-1-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

husbandry_machine_2.name = "wlw-husbandry-machine-2-remnants"
husbandry_machine_2.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-2.png"
husbandry_machine_2.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/remnants/husbandry-machine-2-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/remnants/hr-husbandry-machine-2-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

husbandry_machine_3.name = "wlw-husbandry-machine-3-remnants"
husbandry_machine_3.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-3.png"
husbandry_machine_3.animation = make_rotated_animation_variations_from_sheet (3,
{
  filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/remnants/husbandry-machine-3-remnants.png",
  line_length = 1,
  width = 164,
  height = 142,
  frame_count = 1,
  variation_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = util.by_pixel(0, 10),
  hr_version =
  {
    filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/remnants/hr-husbandry-machine-3-remnants.png",
    line_length = 1,
    width = 328,
    height = 282,
    frame_count = 1,
    variation_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    shift = util.by_pixel(0, 9.5),
    scale = 0.5
  }
})

melting_machine.name = "wlw-melting-machine-remnants"
melting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/melting-machine.png"
melting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/remnants/melting-machine-remnants.png"
melting_machine.animation.hr_version.filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/remnants/hr-melting-machine-remnants.png"

data:extend({alloying_machine, butchering_machine_1, butchering_machine_2, butchering_machine_3, casting_machine, husbandry_machine_1, husbandry_machine_2,
    husbandry_machine_3, melting_machine})