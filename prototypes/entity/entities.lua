-- by far the easiest way to do this will be to deepcopy an existing entity and change it.
-- if you ABSOLUTELY MUST make a custom entity (and I mean ABSOLUTELY MUST because it's going to be a huge pain)
-- then look in __base__/prototypes/entity/entities.lua for code to take from.

-- make copies at the top of this file, and change properties later on. Keep alphabetized for sanity :)
-- remember you only have to do properties that differ from the thing you're copying, of course. E.g. icon_size and icon_mipmaps are usually going to be the same.
-- don't forget to include your new entity in the data:extend() at the end of the file :)
local alloying_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
local casting_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
local melting_machine = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])

-- most properties can be adjusted as simply as machine.property = whatever, but animations have proven difficult.
-- look in __base__/prototypes/entity/entities.lua to see how they use this function to create their animations
-- or you can just copy how you did it with the casting machine the first time. Hopefully it's the same. :D

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

data:extend({alloying_machine, casting_machine, melting_machine})