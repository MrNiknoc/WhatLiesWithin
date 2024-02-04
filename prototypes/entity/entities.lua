-- by far the easiest way to do this will be to deepcopy an existing entity and change it.
-- if you ABSOLUTELY MUST make a custom entity (and I mean ABSOLUTELY MUST because it's going to be a huge pain)
-- then look in __base__/prototypes/entity/entities.lua for code to take from.

-- make copies at the top of this file, and change properties later on. Keep alphabetized for sanity :)
-- remember you only have to do properties that differ from the thing you're copying, of course. E.g. icon_size and icon_mipmaps are usually going to be the same.
-- don't forget to include your new entity in the data:extend() at the end of the file :)
local alloying_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
local butchering_machine_1 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])
local butchering_machine_2 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
local butchering_machine_3 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
local casting_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
local husbandry_machine_1 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
local husbandry_machine_2 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
local husbandry_machine_3 = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
local melting_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])

-- most properties can be adjusted as simply as machine.property = whatever, but animations have proven difficult.
-- look in __base__/prototypes/entity/entities.lua to see how they use this function to create their animations
-- or you can just copy how you did it with the casting machine the first time. Hopefully it's the same. :D

-- Butchering machines are at the bottom.

function make_4way_animation_from_spritesheet(animation)
    local function make_animation_layer(idx, anim)
      local start_frame = (anim.frame_count or 1) * idx
      local x = 0
      local y = 0
      if anim.line_length then
        y = anim.height * math.floor(start_frame / (anim.line_length or 1))
      else
        x = idx * anim.width
      end
      return
      {
        filename = anim.filename,
        priority = anim.priority or "high",
        flags = anim.flags,
        x = x,
        y = y,
        width = anim.width,
        height = anim.height,
        frame_count = anim.frame_count or 1,
        line_length = anim.line_length,
        repeat_count = anim.repeat_count,
        shift = anim.shift,
        draw_as_shadow = anim.draw_as_shadow,
        force_hr_shadow = anim.force_hr_shadow,
        apply_runtime_tint = anim.apply_runtime_tint,
        animation_speed = anim.animation_speed,
        scale = anim.scale or 1,
        tint = anim.tint,
        blend_mode = anim.blend_mode
      }
    end
  
    local function make_animation_layer_with_hr_version(idx, anim)
      local anim_parameters = make_animation_layer(idx, anim)
      if anim.hr_version and anim.hr_version.filename then
        anim_parameters.hr_version = make_animation_layer(idx, anim.hr_version)
      end
      return anim_parameters
    end
  
    local function make_animation(idx)
      if animation.layers then
        local tab = { layers = {} }
        for k,v in ipairs(animation.layers) do
          table.insert(tab.layers, make_animation_layer_with_hr_version(idx, v))
        end
        return tab
      else
        return make_animation_layer_with_hr_version(idx, animation)
      end
    end
  
    return
    {
      north = make_animation(0),
      east = make_animation(1),
      south = make_animation(2),
      west = make_animation(3)
    }
  end

  function butcheringmachine2pipepictures()
    return
    {
      north =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end
  
  function butcheringmachine3pipepictures()
    return
    {
      north =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end

  function husbandrymachine1pipepictures()
    return
    {
      north =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end

  function husbandrymachine2pipepictures()
    return
    {
      north =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/husbandry-machine-2-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/husbandry-machine-2-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/husbandry-machine-2-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/husbandry-machine-2-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end
  
  function husbandrymachine3pipepictures()
    return
    {
      north =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3-pipe-N.png",
        priority = "extra-high",
        width = 35,
        height = 18,
        shift = util.by_pixel(2.5, 14),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/hr-husbandry-machine-3-pipe-N.png",
          priority = "extra-high",
          width = 71,
          height = 38,
          shift = util.by_pixel(2.25, 13.5),
          scale = 0.5
        }
      },
      east =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3-pipe-E.png",
        priority = "extra-high",
        width = 20,
        height = 38,
        shift = util.by_pixel(-25, 1),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/hr-husbandry-machine-3-pipe-E.png",
          priority = "extra-high",
          width = 42,
          height = 76,
          shift = util.by_pixel(-24.5, 1),
          scale = 0.5
        }
      },
      south =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3-pipe-S.png",
        priority = "extra-high",
        width = 44,
        height = 31,
        shift = util.by_pixel(0, -31.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/hr-husbandry-machine-3-pipe-S.png",
          priority = "extra-high",
          width = 88,
          height = 61,
          shift = util.by_pixel(0, -31.25),
          scale = 0.5
        }
      },
      west =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3-pipe-W.png",
        priority = "extra-high",
        width = 19,
        height = 37,
        shift = util.by_pixel(25.5, 1.5),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/hr-husbandry-machine-3-pipe-W.png",
          priority = "extra-high",
          width = 39,
          height = 73,
          shift = util.by_pixel(25.75, 1.25),
          scale = 0.5
        }
      }
    }
  end

  pipecoverspictures = function()
    return
    {
      north =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      east =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      south =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      },
      west =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
            priority = "extra-high",
            width = 64,
            height = 64,
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
              priority = "extra-high",
              width = 128,
              height = 128,
              scale = 0.5,
              draw_as_shadow = true
            }
          }
        }
      }
    }
  end


  alloying_machine.name = "wlw-alloying-machine"
  alloying_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/alloying-machine.png"
  alloying_machine.minable = {mining_time = 0.1, result = "wlw-alloying-machine"}
  alloying_machine.max_health = 500 -- chemical plant default is 300. Casting machines are beefier :).
  alloying_machine.corpse = "wlw-alloying-machine-remnants"
  alloying_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/hr-alloying-machine.png"
  alloying_machine.crafting_categories = {"wlw-alloying"}
  alloying_machine.crafting_speed = 1
  alloying_machine.animation = make_4way_animation_from_spritesheet({ layers =
      {
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/alloying-machine.png",
          width = 108,
          height = 148,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(1, -9),
          hr_version =
          {
            filename = "__WhatLiesWithinGraphics__/graphics/entity/alloying-machine/hr-alloying-machine.png",
            width = 220,
            height = 292,
            frame_count = 24,
            line_length = 12,
            shift = util.by_pixel(0.5, -9),
            scale = 0.5
            }
        },
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
          width = 154,
          height = 112,
          repeat_count = 24,
          frame_count = 1,
          shift = util.by_pixel(28, 6),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
            width = 312,
            height = 222,
            repeat_count = 24,
            frame_count = 1,
            shift = util.by_pixel(27, 6),
            draw_as_shadow = true,
            scale = 0.5
            }
        }
      }})
      alloying_machine.working_visualisations =
      {
          {
            apply_recipe_tint = "primary",
            north_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
              frame_count = 24,
              line_length = 6,
              width = 32,
              height = 24,
              shift = util.by_pixel(24, 14),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-north.png",
                frame_count = 24,
                line_length = 6,
                width = 66,
                height = 44,
                shift = util.by_pixel(23, 15),
                scale = 0.5
              }
            },
            east_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
              frame_count = 24,
              line_length = 6,
              width = 36,
              height = 18,
              shift = util.by_pixel(0, 22),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-east.png",
                frame_count = 24,
                line_length = 6,
                width = 70,
                height = 36,
                shift = util.by_pixel(0, 22),
                scale = 0.5
              }
            },
            south_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
              frame_count = 24,
              line_length = 6,
              width = 34,
              height = 24,
              shift = util.by_pixel(0, 16),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-south.png",
                frame_count = 24,
                line_length = 6,
                width = 66,
                height = 42,
                shift = util.by_pixel(0, 17),
                scale = 0.5
              }
            },
            west_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
              frame_count = 24,
              line_length = 6,
              width = 38,
              height = 20,
              shift = util.by_pixel(-10, 12),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-west.png",
                frame_count = 24,
                line_length = 6,
                width = 74,
                height = 36,
                shift = util.by_pixel(-10, 13),
                scale = 0.5
              }
            }
          },
          {
            apply_recipe_tint = "secondary",
            north_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
              frame_count = 24,
              line_length = 6,
              width = 32,
              height = 22,
              shift = util.by_pixel(24, 14),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-north.png",
                frame_count = 24,
                line_length = 6,
                width = 62,
                height = 42,
                shift = util.by_pixel(24, 15),
                scale = 0.5
              }
            },
            east_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
              frame_count = 24,
              line_length = 6,
              width = 34,
              height = 18,
              shift = util.by_pixel(0, 22),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-east.png",
                frame_count = 24,
                line_length = 6,
                width = 68,
                height = 36,
                shift = util.by_pixel(0, 22),
                scale = 0.5
              }
            },
            south_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
              frame_count = 24,
              line_length = 6,
              width = 32,
              height = 18,
              shift = util.by_pixel(0, 18),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-south.png",
                frame_count = 24,
                line_length = 6,
                width = 60,
                height = 40,
                shift = util.by_pixel(1, 17),
                scale = 0.5
              }
            },
            west_animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
              frame_count = 24,
              line_length = 6,
              width = 36,
              height = 16,
              shift = util.by_pixel(-10, 14),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-west.png",
                frame_count = 24,
                line_length = 6,
                width = 68,
                height = 28,
                shift = util.by_pixel(-9, 15),
                scale = 0.5
              }
            }
          },
          {
            apply_recipe_tint = "tertiary",
            fadeout = true,
            constant_speed = true,
            north_position = util.by_pixel_hr(-30, -161),
            east_position = util.by_pixel_hr(29, -150),
            south_position = util.by_pixel_hr(12, -134),
            west_position = util.by_pixel_hr(-32, -130),
            render_layer = "wires",
            animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
              frame_count = 47,
              line_length = 16,
              width = 46,
              height = 94,
              animation_speed = 0.5,
              shift = util.by_pixel(-2, -40),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-outer.png",
                frame_count = 47,
                line_length = 16,
                width = 90,
                height = 188,
                animation_speed = 0.5,
                shift = util.by_pixel(-2, -40),
                scale = 0.5
              }
            }
          },
          {
            apply_recipe_tint = "quaternary",
            fadeout = true,
            constant_speed = true,
            north_position = util.by_pixel_hr(-30, -161),
            east_position = util.by_pixel_hr(29, -150),
            south_position = util.by_pixel_hr(12, -134),
            west_position = util.by_pixel_hr(-32, -130),
            render_layer = "wires",
            animation =
            {
              filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
              frame_count = 47,
              line_length = 16,
              width = 20,
              height = 42,
              animation_speed = 0.5,
              shift = util.by_pixel(0, -14),
              hr_version =
              {
                filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-inner.png",
                frame_count = 47,
                line_length = 16,
                width = 40,
                height = 84,
                animation_speed = 0.5,
                shift = util.by_pixel(0, -14),
                scale = 0.5
              }
            }
          }
        }


casting_machine.name = "wlw-casting-machine"
casting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/casting-machine.png"
casting_machine.minable = {mining_time = 0.1, result = "wlw-casting-machine"}
casting_machine.max_health = 500 -- chemical plant default is 300. Casting machines are beefier :).
casting_machine.corpse = "wlw-casting-machine-remnants"
casting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/hr-casting-machine.png"
casting_machine.crafting_categories = {"wlw-casting"}
casting_machine.crafting_speed = 1
casting_machine.animation = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/casting-machine.png",
        width = 108,
        height = 148,
        frame_count = 24,
        line_length = 12,
        shift = util.by_pixel(1, -9),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/casting-machine/hr-casting-machine.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
          }
      },
      {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
        width = 154,
        height = 112,
        repeat_count = 24,
        frame_count = 1,
        shift = util.by_pixel(28, 6),
        draw_as_shadow = true,
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
          width = 312,
          height = 222,
          repeat_count = 24,
          frame_count = 1,
          shift = util.by_pixel(27, 6),
          draw_as_shadow = true,
          scale = 0.5
          }
      }
    }})
    casting_machine.working_visualisations =
    {
        {
          apply_recipe_tint = "primary",
          north_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 24,
            shift = util.by_pixel(24, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-north.png",
              frame_count = 24,
              line_length = 6,
              width = 66,
              height = 44,
              shift = util.by_pixel(23, 15),
              scale = 0.5
            }
          },
          east_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
            frame_count = 24,
            line_length = 6,
            width = 36,
            height = 18,
            shift = util.by_pixel(0, 22),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-east.png",
              frame_count = 24,
              line_length = 6,
              width = 70,
              height = 36,
              shift = util.by_pixel(0, 22),
              scale = 0.5
            }
          },
          south_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
            frame_count = 24,
            line_length = 6,
            width = 34,
            height = 24,
            shift = util.by_pixel(0, 16),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-south.png",
              frame_count = 24,
              line_length = 6,
              width = 66,
              height = 42,
              shift = util.by_pixel(0, 17),
              scale = 0.5
            }
          },
          west_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
            frame_count = 24,
            line_length = 6,
            width = 38,
            height = 20,
            shift = util.by_pixel(-10, 12),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-west.png",
              frame_count = 24,
              line_length = 6,
              width = 74,
              height = 36,
              shift = util.by_pixel(-10, 13),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "secondary",
          north_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 22,
            shift = util.by_pixel(24, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-north.png",
              frame_count = 24,
              line_length = 6,
              width = 62,
              height = 42,
              shift = util.by_pixel(24, 15),
              scale = 0.5
            }
          },
          east_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
            frame_count = 24,
            line_length = 6,
            width = 34,
            height = 18,
            shift = util.by_pixel(0, 22),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-east.png",
              frame_count = 24,
              line_length = 6,
              width = 68,
              height = 36,
              shift = util.by_pixel(0, 22),
              scale = 0.5
            }
          },
          south_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 18,
            shift = util.by_pixel(0, 18),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-south.png",
              frame_count = 24,
              line_length = 6,
              width = 60,
              height = 40,
              shift = util.by_pixel(1, 17),
              scale = 0.5
            }
          },
          west_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
            frame_count = 24,
            line_length = 6,
            width = 36,
            height = 16,
            shift = util.by_pixel(-10, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-west.png",
              frame_count = 24,
              line_length = 6,
              width = 68,
              height = 28,
              shift = util.by_pixel(-9, 15),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "tertiary",
          fadeout = true,
          constant_speed = true,
          north_position = util.by_pixel_hr(-30, -161),
          east_position = util.by_pixel_hr(29, -150),
          south_position = util.by_pixel_hr(12, -134),
          west_position = util.by_pixel_hr(-32, -130),
          render_layer = "wires",
          animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
            frame_count = 47,
            line_length = 16,
            width = 46,
            height = 94,
            animation_speed = 0.5,
            shift = util.by_pixel(-2, -40),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-outer.png",
              frame_count = 47,
              line_length = 16,
              width = 90,
              height = 188,
              animation_speed = 0.5,
              shift = util.by_pixel(-2, -40),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "quaternary",
          fadeout = true,
          constant_speed = true,
          north_position = util.by_pixel_hr(-30, -161),
          east_position = util.by_pixel_hr(29, -150),
          south_position = util.by_pixel_hr(12, -134),
          west_position = util.by_pixel_hr(-32, -130),
          render_layer = "wires",
          animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
            frame_count = 47,
            line_length = 16,
            width = 20,
            height = 42,
            animation_speed = 0.5,
            shift = util.by_pixel(0, -14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-inner.png",
              frame_count = 47,
              line_length = 16,
              width = 40,
              height = 84,
              animation_speed = 0.5,
              shift = util.by_pixel(0, -14),
              scale = 0.5
            }
          }
        }
      }

melting_machine.name = "wlw-melting-machine"
melting_machine.icon = "__WhatLiesWithinGraphics__/graphics/icons/melting-machine.png"
melting_machine.minable = {mining_time = 0.1, result = "wlw-melting-machine"}
melting_machine.max_health = 500 -- chemical plant default is 300. Casting machines are beefier :).
melting_machine.corpse = "wlw-melting-machine-remnants"
melting_machine.animation.filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/hr-melting-machine.png"
melting_machine.crafting_categories = {"wlw-melting"}
melting_machine.crafting_speed = 1
melting_machine.animation = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/melting-machine.png",
        width = 108,
        height = 148,
        frame_count = 24,
        line_length = 12,
        shift = util.by_pixel(1, -9),
        hr_version =
        {
          filename = "__WhatLiesWithinGraphics__/graphics/entity/melting-machine/hr-melting-machine.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
          }
      },
      {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
        width = 154,
        height = 112,
        repeat_count = 24,
        frame_count = 1,
        shift = util.by_pixel(28, 6),
        draw_as_shadow = true,
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
          width = 312,
          height = 222,
          repeat_count = 24,
          frame_count = 1,
          shift = util.by_pixel(27, 6),
          draw_as_shadow = true,
          scale = 0.5
          }
      }
    }})
    melting_machine.working_visualisations =
    {
        {
          apply_recipe_tint = "primary",
          north_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 24,
            shift = util.by_pixel(24, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-north.png",
              frame_count = 24,
              line_length = 6,
              width = 66,
              height = 44,
              shift = util.by_pixel(23, 15),
              scale = 0.5
            }
          },
          east_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
            frame_count = 24,
            line_length = 6,
            width = 36,
            height = 18,
            shift = util.by_pixel(0, 22),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-east.png",
              frame_count = 24,
              line_length = 6,
              width = 70,
              height = 36,
              shift = util.by_pixel(0, 22),
              scale = 0.5
            }
          },
          south_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
            frame_count = 24,
            line_length = 6,
            width = 34,
            height = 24,
            shift = util.by_pixel(0, 16),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-south.png",
              frame_count = 24,
              line_length = 6,
              width = 66,
              height = 42,
              shift = util.by_pixel(0, 17),
              scale = 0.5
            }
          },
          west_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
            frame_count = 24,
            line_length = 6,
            width = 38,
            height = 20,
            shift = util.by_pixel(-10, 12),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-west.png",
              frame_count = 24,
              line_length = 6,
              width = 74,
              height = 36,
              shift = util.by_pixel(-10, 13),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "secondary",
          north_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 22,
            shift = util.by_pixel(24, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-north.png",
              frame_count = 24,
              line_length = 6,
              width = 62,
              height = 42,
              shift = util.by_pixel(24, 15),
              scale = 0.5
            }
          },
          east_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
            frame_count = 24,
            line_length = 6,
            width = 34,
            height = 18,
            shift = util.by_pixel(0, 22),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-east.png",
              frame_count = 24,
              line_length = 6,
              width = 68,
              height = 36,
              shift = util.by_pixel(0, 22),
              scale = 0.5
            }
          },
          south_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
            frame_count = 24,
            line_length = 6,
            width = 32,
            height = 18,
            shift = util.by_pixel(0, 18),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-south.png",
              frame_count = 24,
              line_length = 6,
              width = 60,
              height = 40,
              shift = util.by_pixel(1, 17),
              scale = 0.5
            }
          },
          west_animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
            frame_count = 24,
            line_length = 6,
            width = 36,
            height = 16,
            shift = util.by_pixel(-10, 14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-west.png",
              frame_count = 24,
              line_length = 6,
              width = 68,
              height = 28,
              shift = util.by_pixel(-9, 15),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "tertiary",
          fadeout = true,
          constant_speed = true,
          north_position = util.by_pixel_hr(-30, -161),
          east_position = util.by_pixel_hr(29, -150),
          south_position = util.by_pixel_hr(12, -134),
          west_position = util.by_pixel_hr(-32, -130),
          render_layer = "wires",
          animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
            frame_count = 47,
            line_length = 16,
            width = 46,
            height = 94,
            animation_speed = 0.5,
            shift = util.by_pixel(-2, -40),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-outer.png",
              frame_count = 47,
              line_length = 16,
              width = 90,
              height = 188,
              animation_speed = 0.5,
              shift = util.by_pixel(-2, -40),
              scale = 0.5
            }
          }
        },
        {
          apply_recipe_tint = "quaternary",
          fadeout = true,
          constant_speed = true,
          north_position = util.by_pixel_hr(-30, -161),
          east_position = util.by_pixel_hr(29, -150),
          south_position = util.by_pixel_hr(12, -134),
          west_position = util.by_pixel_hr(-32, -130),
          render_layer = "wires",
          animation =
          {
            filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
            frame_count = 47,
            line_length = 16,
            width = 20,
            height = 42,
            animation_speed = 0.5,
            shift = util.by_pixel(0, -14),
            hr_version =
            {
              filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-inner.png",
              frame_count = 47,
              line_length = 16,
              width = 40,
              height = 84,
              animation_speed = 0.5,
              shift = util.by_pixel(0, -14),
              scale = 0.5
            }
          }
        }
      }

butchering_machine_1.name = "wlw-butchering-machine-1"
butchering_machine_1.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-1.png"
butchering_machine_1.minable = {mining_time = 0.1, result = "wlw-butchering-machine-1"}
butchering_machine_1.max_health = 300
butchering_machine_1.next_upgrade = "wlw-butchering-machine-2"
butchering_machine_1.fast_replaceable_group = "wlw-butchering-machines"
butchering_machine_1.corpse = "wlw-butchering-machine-1-remnants"
butchering_machine_1.crafting_categories = {"wlw-butchery"}
butchering_machine_1.crafting_speed = 0.5
butchering_machine_1.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/biter-death-2.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
butchering_machine_1.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/butchering-machine-1.png",
      priority="high",
      width = 108,
      height = 114,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, 2),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/hr-butchering-machine-1.png",
        priority="high",
        width = 214,
        height = 226,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, 2),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/butchering-machine-1-shadow.png",
      priority="high",
      width = 95,
      height = 83,
      frame_count = 1,
      line_length = 1,
      repeat_count = 32,
      draw_as_shadow = true,
      shift = util.by_pixel(8.5, 5.5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-1/hr-butchering-machine-1-shadow.png",
        priority="high",
        width = 190,
        height = 165,
        frame_count = 1,
        line_length = 1,
        repeat_count = 32,
        draw_as_shadow = true,
        shift = util.by_pixel(8.5, 5),
        scale = 0.5
      }
    }
  }
}

butchering_machine_2.name = "wlw-butchering-machine-2"
butchering_machine_2.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-2.png"
butchering_machine_2.minable = {mining_time = 0.1, result = "wlw-butchering-machine-2"}
butchering_machine_2.max_health = 300
butchering_machine_2.next_upgrade = "wlw-butchering-machine-3"
butchering_machine_2.fast_replaceable_group = "wlw-butchering-machines"
butchering_machine_2.corpse = "wlw-butchering-machine-2-remnants"
butchering_machine_2.crafting_categories = {"wlw-butchery", "wlw-butchery-with-fluid"}
butchering_machine_2.crafting_speed = 0.75
butchering_machine_2.fluid_boxes =
{
  {
    production_type = "input",
    pipe_picture = butcheringmachine2pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
    secondary_draw_orders = { north = -1 }
  },
  {
    production_type = "output",
    pipe_picture = butcheringmachine2pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = true
}
butchering_machine_2.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/biter-death-1.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
butchering_machine_2.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2.png",
      priority = "high",
      width = 108,
      height = 110,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, 4),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2.png",
        priority = "high",
        width = 214,
        height = 218,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, 4),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/butchering-machine-2-shadow.png",
      priority = "high",
      width = 98,
      height = 82,
      frame_count = 32,
      line_length = 8,
      draw_as_shadow = true,
      shift = util.by_pixel(12, 5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-2/hr-butchering-machine-2-shadow.png",
        priority = "high",
        width = 196,
        height = 163,
        frame_count = 32,
        line_length = 8,
        draw_as_shadow = true,
        shift = util.by_pixel(12, 4.75),
        scale = 0.5
      }
    }
  }
}

butchering_machine_3.name = "wlw-butchering-machine-3"
butchering_machine_3.icon = "__WhatLiesWithinGraphics__/graphics/icons/butchering-machine-3.png"
butchering_machine_3.minable = {mining_time = 0.1, result = "wlw-butchering-machine-3"}
butchering_machine_3.max_health = 300
butchering_machine_3.fast_replaceable_group = "wlw-butchering-machines"
butchering_machine_3.corpse = "wlw-butchering-machine-3-remnants"
butchering_machine_3.crafting_categories = {"wlw-butchery", "wlw-butchery-with-fluid"}
butchering_machine_3.crafting_speed = 1
butchering_machine_3.fluid_boxes =
{
  {
    production_type = "input",
    pipe_picture = butcheringmachine3pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
    secondary_draw_orders = { north = -1 }
  },
  {
    production_type = "output",
    pipe_picture = butcheringmachine3pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = true
}
butchering_machine_3.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/biter-death-4.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
butchering_machine_3.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3.png",
      priority = "high",
      width = 108,
      height = 119,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, -0.5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3.png",
        priority = "high",
        width = 214,
        height = 237,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, -0.75),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/butchering-machine-3-shadow.png",
      priority = "high",
      width = 130,
      height = 82,
      frame_count = 32,
      line_length = 8,
      draw_as_shadow = true,
      shift = util.by_pixel(28, 4),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-shadow.png",
        priority = "high",
        width = 260,
        height = 162,
        frame_count = 32,
        line_length = 8,
        draw_as_shadow = true,
        shift = util.by_pixel(28, 4),
        scale = 0.5
      }
    }
  }
}

husbandry_machine_1.name = "wlw-husbandry-machine-1"
husbandry_machine_1.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-1.png"
husbandry_machine_1.minable = {mining_time = 0.1, result = "wlw-husbandry-machine-1"}
husbandry_machine_1.max_health = 300
husbandry_machine_1.next_upgrade = "wlw-husbandry-machine-2"
husbandry_machine_1.fast_replaceable_group = "wlw-husbandry-machines"
husbandry_machine_1.corpse = "wlw-husbandry-machine-1-remnants"
husbandry_machine_1.crafting_categories = {"wlw-husbandry", "wlw-husbandry-with-fluid"}
husbandry_machine_1.crafting_speed = 0.5
husbandry_machine_1.fluid_boxes =
{
  {
    production_type = "input",
    pipe_picture = husbandrymachine1pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
    secondary_draw_orders = { north = -1 }
  },
  {
    production_type = "output",
    pipe_picture = husbandrymachine1pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = true
}
husbandry_machine_1.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/spawner.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
husbandry_machine_1.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1.png",
      priority="high",
      width = 108,
      height = 114,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, 2),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1.png",
        priority="high",
        width = 214,
        height = 226,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, 2),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/husbandry-machine-1-shadow.png",
      priority="high",
      width = 95,
      height = 83,
      frame_count = 1,
      line_length = 1,
      repeat_count = 32,
      draw_as_shadow = true,
      shift = util.by_pixel(8.5, 5.5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-1/hr-husbandry-machine-1-shadow.png",
        priority="high",
        width = 190,
        height = 165,
        frame_count = 1,
        line_length = 1,
        repeat_count = 32,
        draw_as_shadow = true,
        shift = util.by_pixel(8.5, 5),
        scale = 0.5
      }
    }
  }
}

husbandry_machine_2.name = "wlw-husbandry-machine-2"
husbandry_machine_2.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-2.png"
husbandry_machine_2.minable = {mining_time = 0.1, result = "wlw-husbandry-machine-2"}
husbandry_machine_2.max_health = 300
husbandry_machine_2.next_upgrade = "wlw-husbandry-machine-3"
husbandry_machine_2.fast_replaceable_group = "wlw-husbandry-machines"
husbandry_machine_2.corpse = "wlw-husbandry-machine-2-remnants"
husbandry_machine_2.crafting_categories = {"wlw-husbandry", "wlw-husbandry-with-fluid"}
husbandry_machine_2.crafting_speed = 0.75
husbandry_machine_2.fluid_boxes =
{
  {
    production_type = "input",
    pipe_picture = husbandrymachine2pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
    secondary_draw_orders = { north = -1 }
  },
  {
    production_type = "output",
    pipe_picture = husbandrymachine2pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = true
}
husbandry_machine_2.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/spawner.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
husbandry_machine_2.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-/husbandry-machine-2.png",
      priority = "high",
      width = 108,
      height = 110,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, 4),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2.png",
        priority = "high",
        width = 214,
        height = 218,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, 4),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/husbandry-machine-2-shadow.png",
      priority = "high",
      width = 98,
      height = 82,
      frame_count = 32,
      line_length = 8,
      draw_as_shadow = true,
      shift = util.by_pixel(12, 5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-2/hr-husbandry-machine-2-shadow.png",
        priority = "high",
        width = 196,
        height = 163,
        frame_count = 32,
        line_length = 8,
        draw_as_shadow = true,
        shift = util.by_pixel(12, 4.75),
        scale = 0.5
      }
    }
  }
}

husbandry_machine_3.name = "wlw-husbandry-machine-3"
husbandry_machine_3.icon = "__WhatLiesWithinGraphics__/graphics/icons/husbandry-machine-3.png"
husbandry_machine_3.minable = {mining_time = 0.1, result = "wlw-husbandry-machine-3"}
husbandry_machine_3.max_health = 300
husbandry_machine_3.fast_replaceable_group = "wlw-husbandry-machines"
husbandry_machine_3.corpse = "wlw-husbandry-machine-3-remnants"
husbandry_machine_3.crafting_categories = {"wlw-husbandry", "wlw-husbandry-with-fluid"}
husbandry_machine_3.crafting_speed = 1
husbandry_machine_3.fluid_boxes =
{
  {
    production_type = "input",
    pipe_picture = husbandrymachine3pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = -1,
    pipe_connections = {{ type="input", position = {0, -2} }},
    secondary_draw_orders = { north = -1 }
  },
  {
    production_type = "output",
    pipe_picture = husbandrymachine3pipepictures(),
    pipe_covers = pipecoverspictures(),
    base_area = 10,
    base_level = 1,
    pipe_connections = {{ type="output", position = {0, 2} }},
    secondary_draw_orders = { north = -1 }
  },
  off_when_no_fluid_recipe = true
}
husbandry_machine_3.working_sound =
{
  sound =
  {
    {
      filename = "__base__/sound/creatures/spawner-spitter.ogg",
      volume = 0.5
    }
  },
  audible_distance_modifier = 0.5,
  fade_in_ticks = 4,
  fade_out_ticks = 20
}
husbandry_machine_3.animation =
{
  layers =
  {
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3.png",
      priority = "high",
      width = 108,
      height = 119,
      frame_count = 32,
      line_length = 8,
      shift = util.by_pixel(0, -0.5),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/hr-husbandry-machine-3.png",
        priority = "high",
        width = 214,
        height = 237,
        frame_count = 32,
        line_length = 8,
        shift = util.by_pixel(0, -0.75),
        scale = 0.5
      }
    },
    {
      filename = "__WhatLiesWithinGraphics__/graphics/entity/husbandry-machine-3/husbandry-machine-3-shadow.png",
      priority = "high",
      width = 130,
      height = 82,
      frame_count = 32,
      line_length = 8,
      draw_as_shadow = true,
      shift = util.by_pixel(28, 4),
      hr_version =
      {
        filename = "__WhatLiesWithinGraphics__/graphics/entity/butchering-machine-3/hr-butchering-machine-3-shadow.png",
        priority = "high",
        width = 260,
        height = 162,
        frame_count = 32,
        line_length = 8,
        draw_as_shadow = true,
        shift = util.by_pixel(28, 4),
        scale = 0.5
      }
    }
  }
}

data:extend({alloying_machine, butchering_machine_1, butchering_machine_2, butchering_machine_3, casting_machine, husbandry_machine_1, husbandry_machine_2,
  husbandry_machine_3, melting_machine})