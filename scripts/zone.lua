local Zone = {}

-- holds all the functions and data needed for zone creation.

-- if we ever find a Zone named "wlw-nothing", then our zone creation failed.
Zone.name = "wlw-nothing"
-- solar panels never work underground
Zone.solar_multiplier = 0
-- geothermal generators do though :) this value should only be in the range [0,1]
Zone.geothermal_multiplier = 0
-- day = [0.75,0.25] sunset = [0.25,0.45] night = [0.45,0.55] sunrise = [0.55,0.75]
-- any daytime value during night is fully dark
Zone.daytime = 0.5
-- this will make night pitch black assuming the default min_brightness value, need a function to do it later because that could've been changed by a mod.
Zone.min_brightness = 0.15 -- this is the vanilla value for Nauvis
Zone.brightness_visual_weights = {1 / 0.85, 1 / 0.85, 1 / 0.85} -- this is 1 / (1 - min_brightness)
-- never show clouds underground.
Zone.show_clouds = false
-- table to hold the MapGenSettings for this surface.
Zone.MapGenSettings = {}
-- variables for each MapGenSetting, less typing :)
Zone.terrain_segmentation = Zone.MapGenSettings.terrain_segmentation
Zone.water = Zone.MapGenSettings.water
Zone.autoplace_controls = Zone.MapGenSettings.autoplace_controls
Zone.default_enable_all_autoplace_controls = Zone.MapGenSettings.default_enable_all_autoplace_controls
Zone.autoplace_settings = Zone.MapGenSettings.autoplace_settings
Zone.cliff_settings = Zone.MapGenSettings.cliff_settings
Zone.seed = Zone.MapGenSettings.seed
Zone.width = Zone.MapGenSettings.width
Zone.height = Zone.MapGenSettings.height
Zone.starting_area = Zone.MapGenSettings.starting_area
Zone.starting_points = Zone.MapGenSettings.starting_points
Zone.peaceful_mode = Zone.MapGenSettings.peaceful_mode
Zone.property_expression_names = Zone.MapGenSettings.property_expression_names
-- boolean to make sure we don't make new underground layers off an underground layer
Zone.is_underground_layer = false

function Zone.get_default()
    return Zone.from_surface_index(1)
end

function Zone.get_top_surface_name(surface)
    local surface_name = surface.name
    local index = string.find(surface_name, " underground %- layer ")

    if index ~= nil then
        return string.sub(surface_name, 1, index-1)
    else
        return surface_name
    end
end

function Zone.from_name(name)
    return global.zones_by_name[name]
end

function Zone.from_surface_index(surface_index)
    return global.zones_by_surface_index[surface_index]
end

function Zone.remove_by_surface_index(surface_index)
    local surface = game.surfaces[surface_index]
    if surface then
        global.zones_by_name[surface.name] = nil
        global.zones_by_surface_index[surface_index] = nil
    end
end

function Zone.remove_by_name(name)
    local surface = game.surfaces[name]
    if surface then
        global.zones_by_name[name] = nil
        global.zones_by_surface_index[surface.index] = nil
    end
end

function Zone.clamp(number, min, max)
    if min then
        if number < min then
            return min
        end
    else
        min = 0
        if number < min then
            return min
        end
    end
    
    if max then
        if number > max then
            return max
        end
    else
        max = 1
        if number > max then
            return max
        end
    end
    return number
end

function Zone.create_default()
    Zone.create_from_surface_index(1)
end

function Zone.rebuild_global_surface_lists()
    global.zones_by_surface_index = {}
    global.zones_by_name = {}
    for _ , surface in pairs(game.surfaces) do
        Zone.create_from_surface_index(surface.index)
    end
end

function Zone.fix_autoplace_controls_for_surface_index(index)
    -- fix the autoplace controls for the surface with the given index.
    local surface = game.surfaces[index]
    if surface then
        local map_gen_settings = surface.map_gen_settings
        local autoplace_controls = map_gen_settings.autoplace_controls
        if autoplace_controls then
            -- if space exploration is enabled, make sure this is a solid surface.
            if global.space_exploration_enabled then
                if (map_gen_settings.width < 2000000 and map_gen_settings.height < 2000000) or string.find(surface.name, "nauvis") then
                    -- this surface isn't infinite or is associated with nauvis, so it's solid.
                    if Zone.from_name(surface.name).is_underground_layer then
                        -- this is an underground layer. autoplace controls should be good already but if they aren't for some reason...
                        -- fix them
                    else
                        -- this isn't an underground layer
                        -- we have to make this check because space exploration deletes nauvis' autoplace_controls maybe
                        if map_gen_settings.autoplace_controls then
                            map_gen_settings.autoplace_controls["wlw-gold-ore"] = {frequency = 0, size = 0, richness = 0}
                            map_gen_settings.autoplace_controls["wlw-lead-ore"] = {frequency = 0, size = 0, richness = 0}
                            map_gen_settings.autoplace_controls["wlw-platinum-ore"] = {frequency = 0, size = 0, richness = 0}
                            map_gen_settings.autoplace_controls["wlw-silver-ore"] = {frequency = 0, size = 0, richness = 0}
                            if map_gen_settings.autoplace_controls["wlw-tin-ore"] then
                                -- tin is already being autoplaced, ignore it.
                            else
                                -- tin isn't being autoplaced, so give it default values.
                                map_gen_settings.autoplace_controls["wlw-tin-ore"] = {frequency = 1, size = 1, richness = 1}
                            end
                        end
                        surface.map_gen_settings = map_gen_settings
                    end
                else
                    -- this surface is infinite, so it's not solid.
                    map_gen_settings.autoplace_controls["wlw-gold-ore"] = {frequency = math.random()/10, size = math.random()/10, richness = math.random()/10}
                    map_gen_settings.autoplace_controls["wlw-lead-ore"] = {frequency = math.random()/10, size = math.random()/10, richness = math.random()/10}
                    map_gen_settings.autoplace_controls["wlw-platinum-ore"] = {frequency = math.random()/10, size = math.random()/10, richness = math.random()/10}
                    map_gen_settings.autoplace_controls["wlw-silver-ore"] = {frequency = math.random()/10, size = math.random()/10, richness = math.random()/10}
                    map_gen_settings.autoplace_controls["wlw-tin-ore"] = {frequency = math.random()/10, size = math.random()/10, richness = math.random()/10}
                    surface.map_gen_settings = map_gen_settings
                end
            else
                -- check if this is an underground layer that we made.
                if Zone.from_surface_index(surface.index).is_underground_layer then
                    -- it is an underground layer, so the settings should be right.
                    -- if they aren't we can fix them here.
                else
                    -- This surface not an underground layer.
                    map_gen_settings.autoplace_controls["wlw-gold-ore"] = {frequency = 0, size = 0, richness = 0}
                    map_gen_settings.autoplace_controls["wlw-lead-ore"] = {frequency = 0, size = 0, richness = 0}
                    map_gen_settings.autoplace_controls["wlw-platinum-ore"] = {frequency = 0, size = 0, richness = 0}
                    map_gen_settings.autoplace_controls["wlw-silver-ore"] = {frequency = 0, size = 0, richness = 0}
                    if map_gen_settings.autoplace_controls["wlw-tin-ore"] then
                        -- tin is already being autoplaced, ignore it.
                    else
                        -- tin isn't being autoplaced, so give it default values.
                        map_gen_settings.autoplace_controls["wlw-tin-ore"] = {frequency = 1, size = 1, richness = 1}
                    end
                    surface.map_gen_settings = map_gen_settings
                end
            end
            Zone.delete_misplaced_autoplace_entities_for_surface_index(surface.index)
        
            -- doing this is very resource intense. maybe don't do it haha
            -- surface.regenerate_entity()
        else
            -- some mods add surfaces without autoplace controls (factorissimo for example), these surfaces should be ignored.
            return
        end
    else
        log("Tried to fix autoplace controls for a given surface index, but no surface with that index exists! Index: " .. index)
    end
end

function Zone.fix_all_surfaces_autoplace_controls()
    for _ , surface in pairs(game.surfaces) do
        Zone.fix_autoplace_controls_for_surface_index(surface.index)
    end
end

function Zone.delete_misplaced_autoplace_entities_for_surface_index(surface_index)
    local surface = game.surfaces[surface_index]
    local should_remove_entities = false
    local entities_to_remove = {}
    -- we have to make this check because space exploration removes nauvis' autoplace_controls maybe
    if surface.map_gen_settings.autoplace_controls then
        for name , autoplace_control in pairs(surface.map_gen_settings.autoplace_controls) do
            if autoplace_control.frequency == 0 then
                -- frequency == 0 means never placed.
                table.insert(entities_to_remove, name)
                should_remove_entities = true
            else
            end
        end
    end
    local placed_entities = surface.find_entities_filtered({name = entities_to_remove})
    -- possible to not find any so check.
    if should_remove_entities then
        for _, entity in pairs(placed_entities) do
            entity.destroy()
        end
    end
end

function Zone.delete_misplaced_autoplace_entities_all_surfaces()
    for _ , surface in pairs(game.surfaces) do
        Zone.delete_misplaced_autoplace_entities_for_surface_index(surface.index)
    end
end

function Zone.create_underground_layer_given_top_surface_name(top_surface_name, underground_layer)
    -- this is where we create new surfaces given which layer of the underground our surface should be on.
    -- then we call create_from_surface_index to turn them into Zones
    -- see https://lua-api.factorio.com/latest/Concepts.html#MapGenSize for more info.
    -- every resource can spawn within the first 10 layers, although they may be tiny.
    -- frequencies are capped at 2x starting value or 200% if they have no starting value.
    -- richnesses are capped at 5x starting value or  500% if they have no starting value.
    -- sizes are capped at 2x starting value or 200% if they have no starting value. sizes mirror frequency scaling in every layer.
    -- copper - frequency + 0.1 til layer 3, -0.1 after. richness + 0.3 til layer 3, - 0.3 after
    -- iron - frequency + 0.1 til layer 5, -0.2 after. richness + 0.3 til layer 5, - 0.3 after
    -- coal - frequency unchanged til layer 5, -0.2 after. richness + 0.3 til layer 5, - 0.3 after
    -- stone - frequency + 0.1 til layer 2, -0.3 after. richness + 0.3 til layer 2, - 0.3 after
    -- uranium - frequency + 0.1 til layer 9, -0.05 after. richness + 0.3 til layer 9, -0.05 after
    -- oil - frequency + 0.1 til layer 4, -0.2 after. richness + 0.5 til layer 4, -0.1 after
    -- tin - frequency + 0.2 til layer 3, -0.2 after. richness + 0.3 til layer 3, -0.5 after
    -- silver - starts at layer 1 at 0.5 each, frequency + 0.1 til layer 12, -0.2 after. richness + 0.3 til layer 12, - 0.2 after
    -- lead - starts at layer 2 at 0.2 each, frequency + 0.2 til layer 30, + 0.05 after. richness + 0.1 per layer til layer 30, + 0.05 after
    -- gold - starts at layer 6 at 0.4 each, frequency + 0.1 per layer. richness + 0.05 per layer
    -- platinum - starts at layer 10 at 0.4 each, frequency + 0.05 per layer. richness + 0.02 per layer.
    -- any other ore (modded ores) get 0.05 for every layer for every setting.
    local TopSurface = game.get_surface(top_surface_name)
    local map_gen_settings = TopSurface.map_gen_settings
    local name = top_surface_name .. " underground - layer " .. underground_layer

    -- make sure this name is unique, if not then increment it by 1 and try again.
    if game.surfaces[name] then
        Zone.create_underground_layer_given_top_surface_name(top_surface_name, underground_layer + 1)
        -- then return, we do NOT want to keep creating this layer monkaS
        return
    end

    -- create the surface and then adjust the map gen settings for it, delete things that should be there, and regenerate entities.
    if map_gen_settings then
        game.create_surface(name, map_gen_settings)
    else
        game.create_surface(name)
    end

    local surface = game.surfaces[name]
    map_gen_settings = surface.map_gen_settings

    -- map_gen_settings can be nil at this point, so set them to what the player chose when they started the game if we have that info.
    -- otherwise make a new one with everything defaulted to 0.5
    if not map_gen_settings then
        if global.chosen_map_settings then
            map_gen_settings = global.chosen_map_settings
        else
            -- we should never get here. chosen_map_settings should always be set to game.default_map_gen_settings
            -- if for some reason it isn't, then set it and use that.
            global.chosen_map_settings = game.default_map_gen_settings
            map_gen_settings = game.default_map_gen_settings
        end
    end

    -- we need to do this check because space exploration can get rid of map_gen_settings some times.
    if map_gen_settings then
        -- set the seed to random number between 0 and 2 billion
        map_gen_settings.seed = math.random() * 2000000000
        -- set the starting area to none. maybe change this in the future who knows.
        map_gen_settings.starting_area = "none"
        -- water goes 0.7 at layer 1, 0.4 at layer 2, 0.1 at layer 3, then no more water.
        map_gen_settings.water = Zone.clamp(1 - (0.3 * underground_layer))
        -- no cliffs underground for now.
        map_gen_settings.cliff_settings.richness = 0

        if map_gen_settings.autoplace_controls then
            -- adjust existing autoplace controls accordingly and clamp them at the end.
            for name, old_autoplace_control in pairs(map_gen_settings.autoplace_controls) do
    
                local old_frequency = old_autoplace_control.frequency
                local old_richness = old_autoplace_control.richness
                local old_size = old_autoplace_control.size

                -- if these stay 0, then we'll clamp between 0 and 0 every time. Not good :)
                if old_frequency == 0 then
                    old_frequency = 1
                end

                -- if these stay 0, then we'll clamp between 0 and 0 every time. Not good :)
                if old_richness == 0 then
                    old_richness = 1
                end

                -- if these stay 0, then we'll clamp between 0 and 0 every time. Not good :)
                if old_size == 0 then
                    old_size = 1
                end

                local autoplace_control = {}
                if name == "copper-ore" then
                    if underground_layer <= 3 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (3 * 0.1)) - ((underground_layer - 3) * 0.1)
                        autoplace_control.richness = (old_richness + (3 * 0.3)) - ((underground_layer - 3) * 0.3)
                        autoplace_control.size = (old_size + (3 * 0.1)) - ((underground_layer - 3) * 0.1)
                    end
                elseif name == "iron-ore" then
                    if underground_layer <= 5 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (5 * 0.1)) - ((underground_layer - 5) * 0.2)
                        autoplace_control.richness = (old_richness + (5 * 0.3)) - ((underground_layer - 5) * 0.3)
                        autoplace_control.size = (old_size + (5 * 0.1)) - ((underground_layer - 5) * 0.2)
                    end
                elseif name == "coal" then
                    if underground_layer <= 5 then
                        autoplace_control.frequency = old_frequency
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size
                    else
                        -- correct
                        autoplace_control.frequency = old_frequency - (underground_layer * 0.2)
                        autoplace_control.richness = (old_richness + (5 * 0.3)) - ((underground_layer - 5) * 0.3)
                        -- correct
                        autoplace_control.size = old_size - (underground_layer * 0.2)
                    end
                elseif name == "stone" then
                    if underground_layer <= 2 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (2 * 0.1)) - ((underground_layer - 2) * 0.3)
                        autoplace_control.richness = (old_richness + (2 * 0.3)) - ((underground_layer - 2) * 0.3)
                        autoplace_control.size = (old_size + (2 * 0.1)) - ((underground_layer - 2) * 0.3)
                    end
                elseif name == "uranium-ore" then
                    if underground_layer <= 9 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (9 * 0.1)) - ((underground_layer - 9) * 0.05)
                        autoplace_control.richness = (old_richness + (9 * 0.3)) - ((underground_layer - 9) * 0.05)
                        autoplace_control.size = (old_size + (9 * 0.1)) - ((underground_layer - 9) * 0.05)
                    end
                elseif name == "crude-oil" then
                    if underground_layer <= 4 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (4 * 0.1)) - ((underground_layer - 4) * 0.2)
                        autoplace_control.richness = (old_richness + (4 * 0.3)) - ((underground_layer - 4) * 0.1)
                        autoplace_control.size = (old_size + (4 * 0.1)) - ((underground_layer - 4) * 0.2)
                    end
                elseif name == "wlw-tin-ore" then
                    if underground_layer <= 3 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.2)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.2)
                    else
                        autoplace_control.frequency = (old_frequency + (3 * 0.2)) - ((underground_layer - 3) * 0.2)
                        autoplace_control.richness = (old_richness + (3 * 0.3)) - ((underground_layer - 3) * 0.5)
                        autoplace_control.size = (old_size + (3 * 0.2)) - ((underground_layer - 3) * 0.2)
                    end
                elseif name == "wlw-silver-ore" then
                    if underground_layer <= 12 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.1)
                        autoplace_control.richness = old_richness + (underground_layer * 0.3)
                        autoplace_control.size = old_size + (underground_layer * 0.1)
                    else
                        autoplace_control.frequency = (old_frequency + (12 * 0.1)) - ((underground_layer - 12) * 0.2)
                        autoplace_control.richness = (old_richness + (12 * 0.3)) - ((underground_layer - 12) * 0.2)
                        autoplace_control.size = (old_size + (12 * 0.1)) - ((underground_layer - 12) * 0.2)
                    end
                elseif name == "wlw-lead-ore" then
                    if underground_layer < 2 then
                        autoplace_control.frequency = 0
                        autoplace_control.richness = 0
                        autoplace_control.size = 0
                    elseif underground_layer <= 30 then
                        autoplace_control.frequency = old_frequency + (underground_layer * 0.2)
                        autoplace_control.richness = old_richness + (underground_layer * 0.1)
                        autoplace_control.size = old_size + (underground_layer * 0.2)
                    else
                        autoplace_control.frequency = (old_frequency + (30 * 0.2)) + ((underground_layer - 30) * 0.05)
                        autoplace_control.richness = (old_richness + (30 * 0.1)) + ((underground_layer - 30) * 0.05)
                        autoplace_control.size = (old_size + (30 * 0.2)) + ((underground_layer - 30) * 0.05)
                    end
                elseif name == "wlw-gold-ore" then
                    if underground_layer < 6 then
                        autoplace_control.frequency = 0
                        autoplace_control.richness = 0
                        autoplace_control.size = 0
                    else
                        autoplace_control.frequency = old_frequency + ((underground_layer - 6) * 0.1)
                        autoplace_control.richness = old_richness + ((underground_layer - 6) * 0.05)
                        autoplace_control.size = old_size + ((underground_layer - 6) * 0.1)
                    end
                elseif name == "wlw-platinum-ore" then
                    if underground_layer < 10 then
                        autoplace_control.frequency = 0
                        autoplace_control.richness = 0
                        autoplace_control.size = 0
                    else
                        autoplace_control.frequency = old_frequency + ((underground_layer - 10) * 0.05)
                        autoplace_control.richness = old_richness + ((underground_layer - 10) * 0.02)
                        autoplace_control.size = old_size + ((underground_layer - 10) * 0.05)
                    end
                elseif name == "trees" then
                    -- no trees underground what is this magic land?!
                    autoplace_control.frequency = 0
                    autoplace_control.richness = 0
                    autoplace_control.size = 0
                elseif name == "enemy-base" then
                    -- bases increase by 50% in each category, they'll max out quickly and are on every layer.
                    autoplace_control.frequency = old_frequency + (underground_layer * 0.5)
                    autoplace_control.richness = old_richness + (underground_layer * 0.5)
                    autoplace_control.size = old_size + (underground_layer * 0.5)
                else
                    autoplace_control.frequency = old_frequency + (underground_layer * 0.05)
                    autoplace_control.richness = old_richness + (underground_layer * 0.05)
                    autoplace_control.size = old_size + (underground_layer * 0.05)
                end
                
                -- clamp the values to be acceptable. except enemy bases, which grow quite large >:)
                if name ~= "enemy-base" then
                    autoplace_control.frequency = Zone.clamp(autoplace_control.frequency, 0, 2)
                    autoplace_control.richness = Zone.clamp(autoplace_control.richness, 0, 5)
                    autoplace_control.size = Zone.clamp(autoplace_control.size, 0, 2)
                else
                    -- clamp enemy bases to 1200%, 2 x max vanilla setting
                    autoplace_control.frequency = Zone.clamp(autoplace_control.frequency, 0, 12)
                    autoplace_control.richness = Zone.clamp(autoplace_control.richness, 0, 12)
                    autoplace_control.size = Zone.clamp(autoplace_control.size, 0, 12)
                end

                -- and add them to our autoplace controls
                map_gen_settings.autoplace_controls[name] = autoplace_control
            end

            -- all autoplace controls are set
            surface.map_gen_settings = map_gen_settings

            -- force generate 1 chunk radius around 0,0 on this surface.
            surface.request_to_generate_chunks({x = 0 , y = 0}, 1)
            surface.force_generate_chunk_requests()

            -- delete the starting lake that every surface seems to get.
            local water_tiles = surface.find_tiles_filtered{name = global.water_tile_names}
            local dirt_tiles = {}
            if water_tiles then
                for _ , tile in pairs(water_tiles) do
                    local new_tile = {position = tile.position, name = "dirt-1"}
                    table.insert(dirt_tiles, new_tile)
                end
            end
            surface.set_tiles(dirt_tiles)

            -- now we regenerate and create from surface index.
            surface.regenerate_entity()
            Zone.create_from_surface_index(surface.index)
        else
            -- in space exploration nauvis has no autoplace controls so we need to make them.
            -- other mods may make surfaces without these as well, so handle them.
            -- defaults are 50%
            -- values get clamped at the end.
            map_gen_settings.autoplace_controls = {}
            -- this should be every resource in the game.
            for name, prototype in pairs(game.get_filtered_entity_prototypes({filter = "type", type = "resource"})) do
                -- if the game autoplaces this resource then autoplace will be not nil
                if prototype.autoplace then
                    -- make sure this resources autoplace control (they can be the same) isn't already in our table.
                    if not map_gen_settings.autoplace_controls[prototype.autoplace.control] then
                        -- it isn't in our table, so add it to our table.
                        local autoplace_control = {}
                        if name == "copper-ore" then
                            if underground_layer <= 3 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 0.8 - ((underground_layer - 3) * 0.1)
                                autoplace_control.richness = 1.4 - ((underground_layer - 3) * 0.3)
                                autoplace_control.size = 0.8 - ((underground_layer - 3) * 0.1)
                            end
                        elseif name == "iron-ore" then
                            if underground_layer <= 5 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 1 - ((underground_layer - 5) * 0.2)
                                autoplace_control.richness = 2 - ((underground_layer - 5) * 0.3)
                                autoplace_control.size = 1 - ((underground_layer - 5) * 0.2)
                            end
                        elseif name == "coal" then
                            if underground_layer <= 5 then
                                autoplace_control.frequency = 0.5
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5
                            else
                                autoplace_control.frequency = 0.5 - ((underground_layer - 5) * 0.2)
                                autoplace_control.richness = 2 - ((underground_layer - 5) * 0.3)
                                autoplace_control.size = 0.5 - ((underground_layer - 5) * 0.2)
                            end
                        elseif name == "stone" then
                            if underground_layer <= 2 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 0.7 - ((underground_layer - 2) * 0.3)
                                autoplace_control.richness = 1.1 - ((underground_layer - 2) * 0.3)
                                autoplace_control.size = 0.7 - ((underground_layer - 2) * 0.3)
                            end
                        elseif name == "uranium-ore" then
                            if underground_layer <= 9 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 1.4 - ((underground_layer - 9) * 0.05)
                                autoplace_control.richness = 3.2 - ((underground_layer - 9) * 0.05)
                                autoplace_control.size = 1.4 - ((underground_layer - 9) * 0.05)
                            end
                        elseif name == "crude-oil" then
                            if underground_layer <= 4 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 0.9 - ((underground_layer - 4) * 0.2)
                                autoplace_control.richness = 1.7 - ((underground_layer - 4) * 0.1)
                                autoplace_control.size = 0.9 - ((underground_layer - 4) * 0.2)
                            end
                        elseif name == "wlw-tin-ore" then
                            if underground_layer <= 3 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.2)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.2)
                            else
                                autoplace_control.frequency = 1.1 - ((underground_layer - 3) * 0.2)
                                autoplace_control.richness = 1.4 - ((underground_layer - 3) * 0.5)
                                autoplace_control.size = 1.1 - ((underground_layer - 3) * 0.2)
                            end
                        elseif name == "wlw-silver-ore" then
                            if underground_layer <= 12 then
                                autoplace_control.frequency = 0.5 + (underground_layer * 0.1)
                                autoplace_control.richness = 0.5 + (underground_layer * 0.3)
                                autoplace_control.size = 0.5 + (underground_layer * 0.1)
                            else
                                autoplace_control.frequency = 1.7 - ((underground_layer - 12) * 0.2)
                                autoplace_control.richness = 4.1 - ((underground_layer - 12) * 0.2)
                                autoplace_control.size = 1.7 - ((underground_layer - 12) * 0.2)
                            end
                        elseif name == "wlw-lead-ore" then
                            if underground_layer < 2 then
                                autoplace_control.frequency = 0
                                autoplace_control.richness = 0
                                autoplace_control.size = 0
                            elseif underground_layer <= 30 then
                                autoplace_control.frequency = 0.2 + ((underground_layer - 2) * 0.2)
                                autoplace_control.richness = 0.2 + ((underground_layer - 2) * 0.1)
                                autoplace_control.size = 0.2 + ((underground_layer - 2) * 0.2)
                            else
                                autoplace_control.frequency = 2 + ((underground_layer - 30) * 0.05)
                                autoplace_control.richness = 3.2 + ((underground_layer - 30) * 0.05)
                                autoplace_control.size = 2 + ((underground_layer - 30) * 0.05)
                            end
                        elseif name == "wlw-gold-ore" then
                            if underground_layer < 6 then
                                autoplace_control.frequency = 0
                                autoplace_control.richness = 0
                                autoplace_control.size = 0
                            else
                                autoplace_control.frequency = 0.4 + ((underground_layer - 6) * 0.1)
                                autoplace_control.richness = 0.4 + ((underground_layer - 6) * 0.05)
                                autoplace_control.size = 0.4 + ((underground_layer - 6) * 0.1)
                            end
                        elseif name == "wlw-platinum-ore" then
                            if underground_layer < 10 then
                                autoplace_control.frequency = 0
                                autoplace_control.richness = 0
                                autoplace_control.size = 0
                            else
                                autoplace_control.frequency = 0.4 + ((underground_layer - 10) * 0.05)
                                autoplace_control.richness = 0.4 + ((underground_layer - 10) * 0.02)
                                autoplace_control.size = 0.4 + ((underground_layer - 10) * 0.05)
                            end
                        elseif name == "trees" then
                            -- no trees underground what is this magic land?!
                            autoplace_control.frequency = 0
                            autoplace_control.richness = 0
                            autoplace_control.size = 0
                        elseif name == "enemy-base" then
                            -- bases increase by 50% in each category, they'll max out quickly and are on every layer.
                            autoplace_control.frequency = old_frequency + (underground_layer * 0.5)
                            autoplace_control.richness = old_richness + (underground_layer * 0.5)
                            autoplace_control.size = old_size + (underground_layer * 0.5)
                        else
                            -- any other ore (modded ores) start at 0.5 and get 0.05 for every layer for every setting.
                            -- they're still capped at 2x or 200% frequency, 5x or 500% richness, and 2x or 200% size
                            autoplace_control.frequency = 0.5 + (underground_layer * 0.05)
                            autoplace_control.richness = 0.5 + (underground_layer * 0.05)
                            autoplace_control.size = 0.5 + (underground_layer * 0.05)
                        end
                        
                        -- clamp the values to be acceptable. except enemy bases, which grow quite large >:)
                        if name ~= "enemy-base" then
                            autoplace_control.frequency = Zone.clamp(autoplace_control.frequency, 0, 2)
                            autoplace_control.richness = Zone.clamp(autoplace_control.richness, 0, 5)
                            autoplace_control.size = Zone.clamp(autoplace_control.size, 0, 2)
                        else
                            -- clamp enemy bases to 600%, max vanilla setting
                            autoplace_control.frequency = Zone.clamp(autoplace_control.frequency, 0, 6)
                            autoplace_control.richness = Zone.clamp(autoplace_control.richness, 0, 6)
                            autoplace_control.size = Zone.clamp(autoplace_control.size, 0, 6)
                        end

                        -- and add them to our autoplace controls
                        map_gen_settings.autoplace_controls[name] = autoplace_control
                    else
                        -- it was already in our table, so do nothing.
                    end
                else
                    -- this resource shouldn't be autoplaced. do nothing.
                end
            end

            -- all autoplace controls are set
            surface.map_gen_settings = map_gen_settings

            -- force generate 3x3 chunks around 0,0 on this surface.
            surface.request_to_generate_chunks({x = 0 , y = 0}, 3)
            surface.force_generate_chunk_requests()

            -- delete the starting lake that every surface seems to get.
            local water_tiles = surface.find_tiles_filtered{name = global.water_tile_names}
            local dirt_tiles = {}
            if water_tiles then
                for _ , tile in pairs(water_tiles) do
                    local new_tile = {position = tile.position, name = "dirt-1"}
                    table.insert(dirt_tiles, new_tile)
                end
            end
            surface.set_tiles(dirt_tiles)

            -- now we regenerate and create from surface index.
            surface.regenerate_entity()
            Zone.create_from_surface_index(surface.index)
        end
    end

    -- we need to force set dusk and evening times in case we're on a planet with a different day cycle.
    surface.morning = 0.55
    surface.dawn = 0.75
    surface.dusk = 0.25
    surface.evening = 0.45

    -- set the daytime for the surface, we don't want to go past 0.45 (midnight)
    surface.daytime = math.min(0.45, 0.3 + (underground_layer * 0.03))
    surface.freeze_daytime = true
    surface.show_clouds = false
    surface.brightness_visual_weights = {1/0.85, 1/0.85, 1/0.85}

    -- solar panels don't work underground
    surface.solar_power_multiplier = 0
end

function Zone.create_from_surface_index(surface_index)
    -- this is where we create zones from existing surfaces. not used to create new surfaces.
    -- we'll use this for any zone that's created by the game or another mod so we have copies of them in our
    -- zone lists.
    local Surface = game.get_surface(surface_index)
    local MapGenSettings = Surface.map_gen_settings
    local newZone = {}
    if global.space_exploration_enabled then
        -- space exploration marks its zones as either solid or not solid, we only want to make underground layers for
        -- solid zones.
        -- as far as I can tell, we can't use a remote interface to access the global table of space exploration to check a zone's is_solid attribute
        -- but it seems that only solid zones have a width and height < 2000000 so for now lets try that :)
        -- and also nauvis + nauvis underground layers, which are infinite but should be treated as solid.
        if (MapGenSettings.width < 2000000 and MapGenSettings.height < 2000000) or string.find(Surface.name, "nauvis") then
            -- this surface is solid, so track it
            -- variables for each MapGenSetting, less typing :)
            newZone.terrain_segmentation = MapGenSettings.terrain_segmentation
            newZone.water = MapGenSettings.water
            newZone.autoplace_controls = MapGenSettings.autoplace_controls
            newZone.default_enable_all_autoplace_controls = MapGenSettings.default_enable_all_autoplace_controls
            newZone.autoplace_settings = MapGenSettings.autoplace_settings
            newZone.cliff_settings = MapGenSettings.cliff_settings
            newZone.seed = MapGenSettings.seed
            newZone.width = MapGenSettings.width
            newZone.height = MapGenSettings.height
            newZone.starting_area = MapGenSettings.starting_area
            newZone.starting_points = MapGenSettings.starting_points
            newZone.peaceful_mode = MapGenSettings.peaceful_mode
            newZone.property_expression_names = MapGenSettings.property_expression_names
            -- this will give us the index where the string was found or nil so if it isn't nil we found it.
            local underground_layer_in_name = string.find(Surface.name, "underground %- layer")
            if underground_layer_in_name then
                newZone.is_underground_layer = true
                local start, stop = string.find(Surface.name, "%d+")
                local layer_number = tonumber(string.sub(Surface.name, start, stop))
                newZone.geothermal_multiplier = math.min(0.2 * layer_number, 10)
            else
                newZone.is_underground_layer = false
                newZone.geothermal_multiplier = 0
            end
            newZone.daytime = Surface.daytime
            newZone.freeze_daytime = Surface.freeze_daytime
            newZone.solar_multiplier = Surface.solar_power_multiplier
            newZone.peaceful_mode = Surface.peaceful_mode
            newZone.name = Surface.name
            newZone.index = Surface.index
            newZone.surface = Surface
            -- store the autoplace settings that space exploration defined for this surface, to use them underground.
            newZone.richnesses = {}
            newZone.sizes = {}
            newZone.frequencies = {}
            -- we need to make sure this exists because space exploration may delete the autoplace controls for nauvis.
            if MapGenSettings.autoplace_controls then
                for name, autoplace_control in pairs(MapGenSettings.autoplace_controls) do
                    newZone.richnesses[name] = autoplace_control.richness
                    newZone.sizes[name] = autoplace_control.size
                    newZone.frequencies[name] = autoplace_control.frequency
                end
            end
            Surface.map_gen_settings = MapGenSettings
        else
            -- this surface is not solid, so don't track it.
            log("Space exploration enabled and non-solid surface was passed. It will not be tracked. Name: " .. Surface.name)
            Zone.fix_autoplace_controls_for_surface_index(Surface.index)
            return
        end
    else
        -- space exploration isn't enabled, so we'll just track every surface and make underground layers for them.
        -- variables for each MapGenSetting, less typing :)
        newZone.terrain_segmentation = MapGenSettings.terrain_segmentation
        newZone.water = MapGenSettings.water
        newZone.autoplace_controls = MapGenSettings.autoplace_controls
        newZone.default_enable_all_autoplace_controls = MapGenSettings.default_enable_all_autoplace_controls
        newZone.autoplace_settings = MapGenSettings.autoplace_settings
        newZone.cliff_settings = MapGenSettings.cliff_settings
        newZone.seed = MapGenSettings.seed
        newZone.width = MapGenSettings.width
        newZone.height = MapGenSettings.height
        newZone.starting_area = MapGenSettings.starting_area
        newZone.starting_points = MapGenSettings.starting_points
        newZone.peaceful_mode = MapGenSettings.peaceful_mode
        newZone.property_expression_names = MapGenSettings.property_expression_names
        -- this will give us the index where the string was found or nil so if it isn't nil we found it.
        local underground_layer_in_name = string.find(Surface.name, "underground %- layer")
        if underground_layer_in_name then
            newZone.is_underground_layer = true
            local start, stop = string.find(Surface.name, "%d+")
            local layer_number = tonumber(string.sub(Surface.name, start, stop))
            -- geothermal capped at 1000%
            newZone.geothermal_multiplier = math.min(0.2 * layer_number, 10)
        else
            newZone.is_underground_layer = false
            newZone.geothermal_multiplier = 0
        end
        newZone.solar_multiplier = Surface.solar_power_multiplier
        newZone.daytime = Surface.daytime
        newZone.peaceful_mode = Surface.peaceful_mode
        newZone.name = Surface.name
        newZone.index = Surface.index
        newZone.surface = Surface
        -- store the autoplace settings that were defined for this surface, to use them underground.
        newZone.richnesses = {}
        newZone.sizes = {}
        newZone.frequencies = {}
        if MapGenSettings.autoplace_controls then
            for name, autoplace_control in pairs(MapGenSettings.autoplace_controls) do
                newZone.richnesses[name] = autoplace_control.richness
                newZone.sizes[name] = autoplace_control.size
                newZone.frequencies[name] = autoplace_control.frequency
            end
        end
        Surface.map_gen_settings = MapGenSettings
    end

    global.zones_by_surface_index[newZone.index] = newZone
    global.zones_by_name[newZone.name] = newZone

    Zone.fix_autoplace_controls_for_surface_index(newZone.index)
end

return Zone
