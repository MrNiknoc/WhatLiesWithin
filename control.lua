-- if space exploration is enabled, we need to check for surface type when generating underground layers
-- because we don't want to generate underground layers on an asteroid for example.
-- if a different mod is generating surfaces we're just going to assume that they're "planet-like" and make underground layers for them
-- until we decide to add compatibility for said mods.

-- keep this here to store a local reference to LUA's global function next, this is faster according to stack exchange :)
local next = next

local Underground = require("scripts/underground")
local Zone = require("scripts/zone")

-- define local functions that will be used later (GUI stuff mostly?)
local function add_blacklisted_surface(surface_name)
    table.insert(global.underground_blacklisted_surfaces, surface_name)
end

local function build_travel_interface(player)
    -- get the player global
    local player_global = global.players[player.index]

    -- get the screen that the player sees, make a new frame on it to hold our gui, give it a size, and force it to auto center.
    local screen_element = player.gui.screen
    local travel_frame = screen_element.add{type="frame", name="wlw_travel_frame", caption={"wlw-gui.travel-frame"}}
    --travel_frame.style.size = {300, 500}
    travel_frame.auto_center = true
    player.opened = travel_frame

    -- add sub frame to our frame, to make it inlaid and lighter. then add a flow to that frame to hold our gui elements.
    local content_frame = travel_frame.add{type="frame", name="wlw_travel_content_frame", direction="vertical", style="wlw-content-frame"}
    local labels_flow = content_frame.add{type="flow", name="wlw_travel_labels_flow", direction="horizontal", style="wlw-controls-flow"}
    local controls_flow = content_frame.add{type="flow", name="wlw_travel_controls_flow", direction="horizontal", style="wlw-controls-flow"}

    labels_flow.add{type="label", name="wlw_travel_current_location_label", caption="Current Location: [color=0,1,0]" .. player.surface.name .. "[/color]"}

    -- create a table of localized strings of every top level surface, we'll add the sub surfaces once a top surface has been chosen.
    local top_level_surfaces = {}
    local nauvis_sub_surfaces = {}
    table.insert(nauvis_sub_surfaces, {"wlw-gui.surface-name", "nauvis"})
    for name,zone in pairs(global.zones_by_name) do
        if string.find(name, "nauvis underground %- layer") then
            table.insert(nauvis_sub_surfaces, {"wlw-gui.surface-name", name})
        elseif string.find(name, "underground %- layer") then
            -- do nothing, this is an underground layer that isn't for nauvis so it shouldn't be in either dropdown yet.
            -- when the top level dropdown selection is changed this layer will be added to the sub level dropdown.
            -- we need this check here to filter these layers out otherwise they'd be added to top level which they certainly are not.
        elseif string.find(name, "aai%-signals") then
            -- also do nothing, the player shouldn't see the aai signals surface.
        else
            table.insert(top_level_surfaces, {"wlw-gui.surface-name", name})
        end
    end

    -- add our gui elements to the flow. by default nauvis is selected and its sub surfaces are shown.
    controls_flow.add{type="drop-down", name="wlw_travel_top_level_dropdown", items=top_level_surfaces, selected_index=1}
    controls_flow.add{type="drop-down", name="wlw_travel_sub_level_dropdown", items=nauvis_sub_surfaces, selected_index=1}
    controls_flow.add{type="button", name="wlw_travel_travel_button", caption={"wlw-gui.travel"}}
end

local function command_friendly_biters_to_follow_players()
    -- iterate every surface and command friendly biters on each of them
    for _, surface in pairs(game.surfaces) do

        -- if there are no characters on this surface, skip it.
        local surface_characters = surface.find_entities_filtered{type = "character"}
        if next(surface_characters) == nil then goto surface_continue end
        local friendly_biters = surface.find_entities_filtered{type = "unit", force = "player"}
        if next(friendly_biters) ~= nil then
            -- command each friendly biter
            for _, biter in pairs(friendly_biters) do
                -- if the biter already has a command that isn't wander, skip it.
                if biter.has_command() then
                    if biter.command.type ~= defines.command.wander then
                        -- this biter is commanded and not wandering, skip it.
                        goto continue
                    end
                end
                local close_enemies = surface.find_entities_filtered{position = biter.position, radius = 50, force = "enemy", type = {"unit", "unit-spawner", "turret"}}
                if next(close_enemies) ~= nil then
                    biter.set_command({type = defines.command.attack, target = close_enemies[math.random(#close_enemies)]})
                    goto continue
                end
                local close_characters = surface.find_entities_filtered{type = "character", force = biter.force, position = biter.position, radius = 12}
                if next(close_characters) ~= nil then
                    -- there is a character kinda close, so skip this biter.
                    goto continue
                end
                local characters = surface.find_entities_filtered{type = "character", force = biter.force}
                if next(characters) ~= nil then
                    biter.set_command({type = defines.command.go_to_location, destination_entity = characters[math.random(#characters)], radius = 5})
                else
                    -- there are no characters on this surface so skip this biter
                    goto continue
                end
                ::continue::
            end
        end

        ::surface_continue::
    end
end

local function get_blacklisted_surfaces()
    return global.underground_blacklisted_surfaces
end

local function get_companion_elevators(entity)
    -- This function will return the companion elevators of the elevator that's passed into the function.
    -- This is so that when we deconstruct/destroy one piece of the elevator all of the other pieces will be deconstructed/destroyed as well.
    -- We'll do this by taking the position and surface name of the passed elevator and checking every other surface with a similar name
    -- for elevators at the same position with the same link_id.

    local entity_position = entity.position
    local entity_surface = entity.surface
    local entity_name = entity.name
    local entity_link_id = entity.link_id
    local companions = {}

    -- first figure out the top level surface name.
    local top_surface_name = Zone.get_top_surface_name(entity_surface)
    local top_surface_underground_directory = top_surface_name .. " underground %- layer "
    local top_surface = game.surfaces[top_surface_name]

    -- check the top surface and any surface that contains top_surface_name .. " underground - layer "
    for _, surface in pairs(game.surfaces) do
        local surface_name = surface.name

        if (surface_name == top_surface_name or string.find(surface_name, top_surface_underground_directory)) and surface_name ~= entity_surface.name then
            -- This is either the top surface or in the correct underground directory so we should check it.
            local companion = surface.find_entity(entity_name, entity_position)

            if companion then
                -- There is an item elevator here but it might not have the same link id so check
                if companion.link_id == entity_link_id then
                    table.insert(companions, companion)
                end
            end
        end
    end

    if companions then
        return companions
    else
        return nil
    end

end

local function get_unused_link_id(entity_force_index)

    if next(global.last_used_link_id_by_force_index) ~= nil then
        -- table is not empty
        if global.last_used_link_id_by_force_index[entity_force_index] == nil then
            global.last_used_link_id_by_force_index[entity_force_index] = 1
        end
        -- If we get to 2 billion (we won't) then return nil so we can throw an error.
        if global.last_used_link_id_by_force_index[entity_force_index] >= 2000000000 then
            global.last_used_link_id_by_force_index[entity_force_index] = 2000000000
            return nil
        else
            local next_link_id = global.last_used_link_id_by_force_index[entity_force_index] + 1

            if game.forces[entity_force_index].get_linked_inventory("wlw-item-elevator", global.last_used_link_id_by_force_index[entity_force_index]) == nil then
                return global.last_used_link_id_by_force_index[entity_force_index]
            end

            while game.forces[entity_force_index].get_linked_inventory("wlw-item-elevator", next_link_id) ~= nil and next_link_id < 2000000000 do
                next_link_id = next_link_id + 1
            end

            global.last_used_link_id_by_force_index[entity_force_index] = next_link_id
            
            if next_link_id == 2000000000 then
                return nil
            else
                return next_link_id
            end
        end
    else
        -- table is empty
        global.last_used_link_id_by_force_index[entity_force_index] = 1
        return 1
    end
end

local function remove_blacklisted_surface(surface_name)
    for index, value in ipairs(global.underground_blacklisted_surfaces) do
        if value == surface_name then
            table.remove(global.underground_blacklisted_surfaces, index)
        end
    end
end

local function render_destination_text_on_elevators()

    -- TODO: Change this function to pull from a cached table of item elevators, rather than searching every surface for them.
    -- TODO: Big performance gains to be had there. This does work though.

    -- First clear everything that we're already rendering. NOTE if we end up rendering more than just these texts, we'll want to only clear them and not everything rendered.
    rendering.clear("WhatLiesWithin")

    for _, surface in pairs(game.surfaces) do
        local elevators = surface.find_entities_filtered{
            name = "wlw-item-elevator"
        }

        if next(elevators) ~= nil then
            for _, elevator in pairs(elevators) do
                local companions = get_companion_elevators(elevator)

                if next(companions) ~= nil then
                    local companion_surface_name = companions[1].surface.name
                    local destination_text = 'Idk man'
                    if string.find(companion_surface_name, "underground %- layer") then
                        destination_text = string.sub(companion_surface_name, string.find(companion_surface_name, "underground %- layer") + 14, string.len(companion_surface_name))
                    else
                        destination_text = companion_surface_name
                    end

                    rendering.draw_text{
                        text = destination_text,
                        surface = elevator.surface,
                        target = elevator,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }
                end
            end
        end
    end
end

local function toggle_travel_interface(player)
    local main_frame = player.gui.screen.wlw_travel_frame

    if main_frame == nil then
        build_travel_interface(player)
    else
        main_frame.destroy()
    end
end

-- define our event functions (functions that are called by registered events)

function OnInit(event)
    -- When creating a new game, script.on_init() will be called on each mod that has a control.lua file.
    -- When loading a save game and the mod did not exist in that save game script.on_init() is called.

    -- global table stuff goes here
    global.space_exploration_enabled = global.space_exploration_enabled or script.active_mods["space-exploration"]
    global.players = global.players or {}

    global.zones_by_surface_index = global.zones_by_surface_index or {}
    global.zones_by_name = global.zones_by_name or {}

    -- This table will hold any surfaces that mods have explicitly told us not to create underground surfaces for.
    global.underground_blacklisted_surfaces = global.underground_blacklisted_surfaces or {}

    -- Currently this table is key = force value = int of last used link_id.
    -- TODO: Link ids are per force AND per prototype, so this table should really be force -> prototype -> link id.
    -- TODO: We only need to do this once we've implemented multiple item elevator prototypes.
    global.last_used_link_id_by_force_index = global.last_used_link_id_by_force_index or {}

    -- save the map settings the player chose then change nauvis to not spawn the ores we want underground.
    global.chosen_map_settings = global.chosen_map_settings or game.default_map_gen_settings

    -- create a list of all tile prototypes with water in their name.
    global.water_tile_names = {}
    for name, prototype in pairs(game.tile_prototypes) do
        if string.find(name, "water") then
            table.insert(global.water_tile_names, name)
        end
    end

    -- create an array of atmospheric messages (flavor text)
    global.atmosphere_messages = {"You feel an intense urge to venture further... [color=1,0,1]deeper...[/color]", "Your body and mind long for the darkness below...", "Thoughts of the underground cloud your mind...", "The [color=1,0,1]depths[/color] beckon...", "The light stings your eyes. They crave the [color=1,0,1]darkness...[/color]"}

    -- add our remote interfaces for blacklisting and whitelisting surfaces
    remote.add_interface("wlw-underground-layer-creation-blacklist", {
        add_surface = add_blacklisted_surface,
        get_surfaces = get_blacklisted_surfaces,
        remove_surface = remove_blacklisted_surface
    })

    -- make sure every Zone is created that should be.
    -- if there are zones already then check if each surface is in the zone list.
    Zone.rebuild_global_surface_lists()
end

function OnConfigurationChanged(event)
    -- game.print("Configuration changed!!")

    global.space_exploration_enabled = global.space_exploration_enabled or script.active_mods["space-exploration"]
    global.players = global.players or {}

    global.zones_by_surface_index = global.zones_by_surface_index or {}
    global.zones_by_name = global.zones_by_name or {}

    -- This table will hold any surfaces that mods have explicitly told us not to create underground surfaces for.
    global.underground_blacklisted_surfaces = global.underground_blacklisted_surfaces or {}

    -- Currently this table is key = force value = int of last used link_id.
    -- TODO: Link ids are per force AND per prototype, so this table should really be force -> prototype -> link id.
    -- TODO: We only need to do this once we've implemented multiple item elevator prototypes.
    global.last_used_link_id_by_force_index = global.last_used_link_id_by_force_index or {}

    -- save the map settings the player chose then change nauvis to not spawn the ores we want underground.
    global.chosen_map_settings = global.chosen_map_settings or game.default_map_gen_settings

    -- create a list of all tile prototypes with water in their name.
    global.water_tile_names = {}
    for name, prototype in pairs(game.tile_prototypes) do
        if string.find(name, "water") then
            table.insert(global.water_tile_names, name)
        end
    end

    -- create an array of atmospheric messages (flavor text)
    global.atmosphere_messages = {"You feel an intense urge to venture further... [color=1,0,1]deeper...[/color]", "Your body and mind long for the darkness below...", "Thoughts of the underground cloud your mind...", "The [color=1,0,1]depths[/color] beckon...", "The light stings your eyes. They crave the [color=1,0,1]darkness...[/color]"}

    -- make sure every Zone is created that should be.
    -- if there are zones already then check if each surface is in the zone list.
    Zone.rebuild_global_surface_lists()

    -- render destination texts for elevators
    render_destination_text_on_elevators()
end

function GuiClick(event)
    -- get the player who clicked
    local player = game.get_player(event.player_index)

    if not (player and player.valid) then
        return
    end

    if event.element.name == "wlw_travel_travel_button" then
        local surface = player.surface
        local player_surface_name = surface.name

        -- get the parent of the button, this is the frame that holds both dropdowns.
        local parent_frame = event.element.parent

        -- get the name of the surface that we want to travel to. it's index two in the table that's selected in the dropdown menu.
        if parent_frame.wlw_travel_sub_level_dropdown.selected_index < 1 then
            parent_frame.wlw_travel_sub_level_dropdown.selected_index = 1
        end

        local target_surface_name = parent_frame.wlw_travel_sub_level_dropdown.get_item(parent_frame.wlw_travel_sub_level_dropdown.selected_index)[2]

        -- make sure this is somewhere we should be able to travel to (only surfaces attached to current world)
        local current_top_level = nil

        -- we need to search for this string to see if we're already on an underground layer.
        local underground_string_index = string.find(player_surface_name, "underground %- layer")

        if underground_string_index == nil then
            -- the player is not on an underground layer, so we're going to assume they're on the top level.
            current_top_level = player_surface_name
        else
            -- the player is on an underground layer, so the top level name should be our current name minus everything starting from the space before underground - layer
            -- to the end of the string.
            current_top_level = string.sub(player_surface_name, 1, underground_string_index - 2)
        end

        -- if the player's current top level is in the target surface name, then we'll allow them to travel there.
        -- e.g. target surface = nauvis underground - layer 101 current top level = nauvis (they can travel)
        -- e.g. target surface = Frost underground - layer 30 current top level = nauvis (they can not travel)
        if string.find(target_surface_name, current_top_level) then
            -- first check if the player is on the surface that they're trying to travel to.
            if target_surface_name ~= player_surface_name then
                -- the target surface is a sub surface of the player's current world and should be traveled to.
                local target_surface = game.get_surface(target_surface_name)

                -- make sure there's an item elevator pair connecting these surfaces within 10 tiles of the player.

                -- first see if there are item elevators within 10 tiles
                local surface_item_elevators_in_range = surface.find_entities_filtered{
                    position = player.position,
                    radius = 10,
                    name = "wlw-item-elevator",
                    force = player.force
                }

                -- then iterate over all of them and if their companion elevator is on the target surface.
                -- if it is we can travel.
                if next(surface_item_elevators_in_range) ~= nil then

                    local pair_exists = false

                    for _, elevator in ipairs(surface_item_elevators_in_range) do
                        local companions = get_companion_elevators(elevator)
                        if next(companions) ~= nil then
                            for i=1, #companions do
                                if companions[i].surface == target_surface then
                                    pair_exists = true
                                    goto pair_check
                                end
                            end
                        end
                    end
                    ::pair_check::
                    if pair_exists then
                        -- we need to find a non colliding position for the player to teleport to
                        local non_colliding_position = target_surface.find_non_colliding_position("character", player.position, 1000, 1)

                        if non_colliding_position == nil then
                            -- there was not a non-colliding position within 1000 distance of the player's position.
                            -- prompt the player to move and try again.
                            player.print("[color=1,0,0]No valid position found. Move somewhere else and try again.[/color]")
                        else
                            -- we found a valid position so tell the player we're moving them there and move them.
                            player.print("You make your way to " .. target_surface_name .. ".")
                            player.teleport(non_colliding_position, target_surface)
                            local super_parent_frame = parent_frame.parent
                            super_parent_frame.wlw_travel_labels_flow.wlw_travel_current_location_label.caption = "Current Location: [color=0,1,0]" .. player_surface_name .. "[/color]"
                            toggle_travel_interface(player)
                        end
                    else
                        -- There was no such pair, so we tell the player to find one and return.
                        player.print("You're not close enough to an item elevator that goes there. Please find or place one and try again!")
                        return
                    end
                else
                    -- There was no such pair, so we tell the player to find one and return.
                    player.print("You're not close enough to an item elevator that goes there. Please find or place one and try again!")
                    return
                end
            else
                -- the player is already on the target surface, so travelling should be disabled.
                -- if we don't disable travelling, then the player can potentially abuse this to teleport across the surface they're already on.
                player.print("Traveling failed, you are already there.")
            end
        else
            -- tell the player that they can not travel between worlds, only sub surfaces of a single world.
            player.print("You'll need to find another way to travel to a different world.")
        end

    end
end

function OnBuiltEntity(event)
    local entity = event.created_entity

    if not (entity and entity.valid) then
        return
    end

    local name = entity.name
    local surface = entity.surface
    local player_index = event.player_index
    local player = game.get_player(event.player_index)
    local used_item = event.item

    if not (player and player.valid) then
        return
    end

    local player_character = player.character

    local entity_surface_name = surface.name

    if name == "wlw-item-elevator" then
        -- when we place an item elevator, we need to make the next underground layer if it doesn't already exist and place the companion elevator there.
        -- before we do that though we need to make sure that this surface isn't in our blacklist. If it is we shouldn't build it and we should tell the player
        -- that they can't place an item-elevator on this surface.
        for _, value in ipairs(global.underground_blacklisted_surfaces) do
            if value == surface.name then
                player.create_local_flying_text({text = {"error-message.wlw-surface-blacklisted"}, create_at_cursor = true})
                entity.destroy()
                player.insert{name = "wlw-item-elevator", count = 1}
                return
            end
        end

        -- we also need to give the item elevator a unique id, currently this function will allow for 2 billion unique links.
        local next_link_id = get_unused_link_id(entity.force.index)
        if next_link_id == nil then
            -- If we get here we have already used up all of the link_ids so don't allow the elevator to be built.
            player.create_local_flying_text({text = {"error-message.wlw-cant-place-item-elevator"}, create_at_cursor = true})
            entity.destroy()
            player.insert{name = "wlw-item-elevator", count = 1}
            return
        end

        -- check if the next layer already exists, at this point we know our next_link_id is valid so we don't need to check again.

        -- first check if we're on an underground layer
        if string.find(entity_surface_name, "underground %- layer") then
            -- we are on an underground layer, so we need to check the next underground layer.
            local _, underground_layer_index_end = string.find(entity_surface_name, "underground %- layer ")
            local top_surface_name = string.gsub(entity_surface_name, " underground %- layer %d+", "")
            local current_underground_layer_number = tonumber(string.sub(entity_surface_name, underground_layer_index_end + 1))
            local target_underground_layer_number = current_underground_layer_number + 1

            if global.zones_by_name[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)] then
                -- it exists, try to place the companion elevator there. If it fails then we can't place the elevator here.

                local target_surface = game.surfaces[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)]

                -- Make sure that the chunk we're trying to place the elevator in has been generated, otherwise a position will be unfindable.
                target_surface.request_to_generate_chunks(entity.position)
                target_surface.force_generate_chunk_requests()

                -- then try to place the companion elevator there. If it fails then we can't place the elevator here.
                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    player.create_local_flying_text({text = {"error-message.wlw-cant-place-item-elevator"}, create_at_cursor = true})
                    entity.destroy()
                    player.insert{name = "wlw-item-elevator", count = 1}
                    player.play_sound(
                        {
                            path = "utility/cannot_build"
                        }
                    )
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id

                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()

                    -- also render text on each elevator
                    local top_destination_text = 'Idk man'
                    local bottom_destination_text = 'Idk man'

                    if string.find(target_surface.name, "underground %- layer") then
                        top_destination_text = string.sub(target_surface.name, string.find(target_surface.name, "underground %- layer") + 14, string.len(target_surface.name))
                    else
                        top_destination_text = target_surface.name
                    end

                    if string.find(entity_surface_name, "underground %- layer") then
                        bottom_destination_text = string.sub(entity_surface_name, string.find(entity_surface_name, "underground %- layer") + 14, string.len(entity_surface_name))
                    else
                        bottom_destination_text = entity_surface_name
                    end

                    rendering.draw_text{
                        text = top_destination_text,
                        surface = entity.surface,
                        target = entity,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }

                    rendering.draw_text{
                        text = bottom_destination_text,
                        surface = target_surface,
                        target = companion_elevator,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }
                    return
                end
            else
                Zone.create_underground_layer_given_top_surface_name(top_surface_name, target_underground_layer_number)

                local target_surface = game.surfaces[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)]

                -- Make sure that the chunk we're trying to place the elevator in has been generated, otherwise a position will be unfindable.
                target_surface.request_to_generate_chunks(entity.position)
                target_surface.force_generate_chunk_requests()

                -- then try to place the companion elevator there. If it fails then we can't place the elevator here.
                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    player.create_local_flying_text({text = {"error-message.wlw-cant-place-item-elevator"}, create_at_cursor = true})
                    entity.destroy()
                    player.insert{name = "wlw-item-elevator", count = 1}
                    player.play_sound(
                        {
                            path = "utility/cannot_build"
                        }
                    )
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id
                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()

                    -- also render text on each elevator
                    local top_destination_text = 'Idk man'
                    local bottom_destination_text = 'Idk man'

                    if string.find(target_surface.name, "underground %- layer") then
                        top_destination_text = string.sub(target_surface.name, string.find(target_surface.name, "underground %- layer") + 14, string.len(target_surface.name))
                    else
                        top_destination_text = target_surface.name
                    end

                    if string.find(entity_surface_name, "underground %- layer") then
                        bottom_destination_text = string.sub(entity_surface_name, string.find(entity_surface_name, "underground %- layer") + 14, string.len(entity_surface_name))
                    else
                        bottom_destination_text = entity_surface_name
                    end

                    rendering.draw_text{
                        text = top_destination_text,
                        surface = entity.surface,
                        target = entity,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }

                    rendering.draw_text{
                        text = bottom_destination_text,
                        surface = target_surface,
                        target = companion_elevator,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }
                    return
                end
            end
        else
            -- we are not on an underground layer, so we need to check the first underground layer of this world.
            if global.zones_by_name[entity_surface_name .. " underground - layer 1"] then
                -- if we get here it exists already so try to place the companion elevator there. If it fails then we can't place the elevator here.

                local target_surface = game.surfaces[entity_surface_name .. " underground - layer 1"]

                -- Make sure that the chunk we're trying to place the elevator in has been generated, otherwise a position will be unfindable.
                target_surface.request_to_generate_chunks(entity.position)
                target_surface.force_generate_chunk_requests()

                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    player.create_local_flying_text({text = {"error-message.wlw-cant-place-item-elevator"}, create_at_cursor = true})
                    entity.destroy()
                    player.insert{name = "wlw-item-elevator", count = 1}
                    player.play_sound(
                        {
                            path = "utility/cannot_build"
                        }
                    )
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id

                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()

                    -- also render text on each elevator
                    local top_destination_text = 'Idk man'
                    local bottom_destination_text = 'Idk man'

                    if string.find(target_surface.name, "underground %- layer") then
                        top_destination_text = string.sub(target_surface.name, string.find(target_surface.name, "underground %- layer") + 14, string.len(target_surface.name))
                    else
                        top_destination_text = target_surface.name
                    end

                    if string.find(entity_surface_name, "underground %- layer") then
                        bottom_destination_text = string.sub(entity_surface_name, string.find(entity_surface_name, "underground %- layer") + 14, string.len(entity_surface_name))
                    else
                        bottom_destination_text = entity_surface_name
                    end

                    rendering.draw_text{
                        text = top_destination_text,
                        surface = entity.surface,
                        target = entity,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }

                    rendering.draw_text{
                        text = bottom_destination_text,
                        surface = target_surface,
                        target = companion_elevator,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }
                    return
                end
            else
                -- if we get here it doesn't exist, so make it and build the companion elevator there.
                Zone.create_underground_layer_given_top_surface_name(entity_surface_name, 1)

                local target_surface = game.surfaces[entity_surface_name .. " underground - layer 1"]

                -- Make sure that the chunk we're trying to place the elevator in has been generated, otherwise a position will be unfindable.
                target_surface.request_to_generate_chunks(entity.position)
                target_surface.force_generate_chunk_requests()

                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    player.create_local_flying_text({text = {"error-message.wlw-cant-place-item-elevator"}, create_at_cursor = true})
                    entity.destroy()
                    player.insert{name = "wlw-item-elevator", count = 1}
                    player.play_sound(
                        {
                            path = "utility/cannot_build"
                        }
                    )
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id
                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()

                    -- also render text on each elevator
                    local top_destination_text = 'Idk man'
                    local bottom_destination_text = 'Idk man'

                    if string.find(target_surface.name, "underground %- layer") then
                        top_destination_text = string.sub(target_surface.name, string.find(target_surface.name, "underground %- layer") + 14, string.len(target_surface.name))
                    else
                        top_destination_text = target_surface.name
                    end

                    if string.find(entity_surface_name, "underground %- layer") then
                        bottom_destination_text = string.sub(entity_surface_name, string.find(entity_surface_name, "underground %- layer") + 14, string.len(entity_surface_name))
                    else
                        bottom_destination_text = entity_surface_name
                    end

                    rendering.draw_text{
                        text = top_destination_text,
                        surface = entity.surface,
                        target = entity,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }

                    rendering.draw_text{
                        text = bottom_destination_text,
                        surface = target_surface,
                        target = companion_elevator,
                        target_offset = {-1.5, 1},
                        color = {1,1,1,1}, -- pure white
                        scale = 3,
                        forces = {},
                        players = {}
                    }
                    return
                end
            end
        end

        -- this is how you create the arbitrary next underground layer
        -- Zone.create_underground_layer_given_top_surface_name(string.gsub(entity_surface_name, " underground %- layer %d+", ""), 1)

    elseif string.match(name, "silo") then
        -- Disallow silos to be built underground
        if string.match(entity_surface_name, "underground") then
            -- We failed to build the entity here.
            player.create_local_flying_text({text = {"error-message.wlw-cant-place-rocket-silo"}, create_at_cursor = true})
            entity.destroy()
            player.insert{name = name, count = 1}
            player.play_sound(
                {
                    path = "utility/cannot_build"
                }
            )
        end

    elseif name == "small-biter" then
        if used_item then
            if used_item.name == "wlw-small-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "medium-biter" then
        if used_item then
            if used_item.name == "wlw-medium-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "big-biter" then
        if used_item then
            if used_item.name == "wlw-big-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "behemoth-biter" then
        if used_item then
            if used_item.name == "wlw-behemoth-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "small-spitter" then
        if used_item then
            if used_item.name == "wlw-small-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "medium-spitter" then
        if used_item then
            if used_item.name == "wlw-medium-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "big-spitter" then
        if used_item then
            if used_item.name == "wlw-big-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "behemoth-spitter" then
        if used_item then
            if used_item.name == "wlw-behemoth-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    end

    --local size = 5

    --for y=-size, size do
        --for x=-size, size do
            --player.surface.create_entity({name="wlw-lead-ore", amount=1000, position={player.position.x+x, player.position.y+y}})
        --end
    --end
end

function OnMinedEntity(event)
    local entity = event.entity

    if not (entity and entity.valid) then
        return
    end

    if entity.name == "wlw-item-elevator" then
        local inventory = entity.get_output_inventory()
        local companions = get_companion_elevators(entity)
        local entity_force_index = entity.force.index
        local entity_link_id = entity.link_id
        local entity_surface = entity.surface
        local entity_position = entity.position

        -- destroy the medium pole that got placed with this item elevator.
        local medium_pole = entity_surface.find_entities_filtered(
            {
                position = entity_position,
                name = "medium-electric-pole",
                radius = 2
            }
        )[1]

        if medium_pole and medium_pole.valid then
            medium_pole.destroy()
        end

        if inventory then
            for i = 1, #inventory do
                event.buffer.insert(inventory[i])
            end
            inventory.clear()
        end

        if companions then
            for i = 1, #companions do
                medium_pole = companions[i].surface.find_entities_filtered(
                    {
                        position = entity_position,
                        name = "medium-electric-pole"
                    }
                )[1]

                if medium_pole and medium_pole.valid then
                    medium_pole.destroy()
                end
                companions[i].destroy()
            end
        end

        global.last_used_link_id_by_force_index[entity_force_index] = entity_link_id - 1
    end
end

function OnRobotBuiltEntity(event)
    local entity = event.created_entity
    local robot = event.robot

    if not (entity and entity.valid) then
        return
    end

    if not (robot and robot.valid) then
        return
    end

    local name = entity.name
    local surface = entity.surface
    local entity_surface_name = surface.name
    local used_item = event.stack

    if name == "wlw-item-elevator" then
        -- when we place an item elevator, we need to make the next underground layer if it doesn't already exist and place the companion elevator there.
        -- before we do that though we need to make sure that this surface isn't in our blacklist. If it is we shouldn't build it and we should tell the player
        -- that they can't place an item-elevator on this surface.
        for _, value in ipairs(global.underground_blacklisted_surfaces) do
            if value == surface.name then
                entity.destroy()
                surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
                local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
                if dropped_item then
                    dropped_item[1].order_deconstruction(robot.force)
                end
                return
            end
        end

        -- we also need to give the item elevator a unique id, currently this function will allow for 2 billion unique links.
        local next_link_id = get_unused_link_id(entity.force.index)
        if next_link_id == nil then
            -- If we get here we have already used up all of the link_ids so don't allow the elevator to be built.
            entity.destroy()
            surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
            local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
            if dropped_item then
                dropped_item[1].order_deconstruction(robot.force)
            end
            return
        end

        -- check if the next layer already exists, at this point we know our next_link_id is valid so we don't need to check again.

        -- first check if we're on an underground layer
        if string.find(entity_surface_name, "underground %- layer") then
            -- we are on an underground layer, so we need to check the next underground layer.
            local _, underground_layer_index_end = string.find(entity_surface_name, "underground %- layer ")
            local top_surface_name = string.gsub(entity_surface_name, " underground %- layer %d+", "")
            local current_underground_layer_number = tonumber(string.sub(entity_surface_name, underground_layer_index_end + 1))
            local target_underground_layer_number = current_underground_layer_number + 1

            if global.zones_by_name[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)] then
                -- it exists, try to place the companion elevator there. If it fails then we can't place the elevator here.

                local target_surface = game.surfaces[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)]

                -- then try to place the companion elevator there. If it fails then we can't place the elevator here.
                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    entity.destroy()
                    surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
                    local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
                    if dropped_item then
                        dropped_item[1].order_deconstruction(robot.force)
                    end
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id

                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()
                    return
                end
            else
                Zone.create_underground_layer_given_top_surface_name(top_surface_name, target_underground_layer_number)

                local target_surface = game.surfaces[top_surface_name .. " underground - layer " .. tostring(target_underground_layer_number)]

                -- then try to place the companion elevator there. If it fails then we can't place the elevator here.
                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    entity.destroy()
                    surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
                    local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
                    if dropped_item then
                        dropped_item[1].order_deconstruction(robot.force)
                    end
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id
                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()
                    return
                end
            end
        else
            -- we are not on an underground layer, so we need to check the first underground layer of this world.
            if global.zones_by_name[entity_surface_name .. " underground - layer 1"] then
                -- if we get here it exists already so try to place the companion elevator there. If it fails then we can't place the elevator here.

                local target_surface = game.surfaces[entity_surface_name .. " underground - layer 1"]

                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    entity.destroy()
                    surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
                    local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
                    if dropped_item then
                        dropped_item[1].order_deconstruction(robot.force)
                    end
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id

                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()
                    return
                end
            else
                -- if we get here it doesn't exist, so make it and build the companion elevator there.
                Zone.create_underground_layer_given_top_surface_name(entity_surface_name, 1)

                local target_surface = game.surfaces[entity_surface_name .. " underground - layer 1"]

                if target_surface.find_non_colliding_position("wlw-item-elevator", entity.position, 0.01, 0.01) == nil then
                    -- We failed to build the entity here.
                    entity.destroy()
                    surface.spill_item_stack(robot.position, {name="wlw-item-elevator", count=1, enable_looted=true})
                    local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
                    if dropped_item then
                        dropped_item[1].order_deconstruction(robot.force)
                    end
                    return
                else
                    local companion_elevator = target_surface.create_entity(
                        {
                            name = "wlw-item-elevator",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    -- Create the poles to connect power between the surfaces.
                    local top_pole = surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = entity.position
                        }
                    )

                    local bottom_pole = target_surface.create_entity(
                        {
                            name = "medium-electric-pole",
                            force = entity.force,
                            position = companion_elevator.position
                        }
                    )

                    -- Connect the poles electricty as well as red and green cables.
                    top_pole.connect_neighbour(bottom_pole)
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.green,
                        target_entity = bottom_pole
                    })
                    top_pole.connect_neighbour({
                        wire = defines.wire_type.red,
                        target_entity = bottom_pole
                    })

                    -- Make both poles indestructible and not minable.
                    top_pole.destructible = false
                    top_pole.minable = false
                    bottom_pole.destructible = false
                    bottom_pole.minable = false

                    -- We succeeded in building the entity here so give it them both the correct link id and return.
                    entity.link_id = next_link_id
                    companion_elevator.link_id = next_link_id
                    -- also generate a radius of 3 chunks around the elevator (enables biter spawning, among other things)
                    target_surface.request_to_generate_chunks(companion_elevator.position, 3)
                    target_surface.force_generate_chunk_requests()
                    return
                end
            end
        end

        -- this is how you create the arbitrary next underground layer
        -- Zone.create_underground_layer_given_top_surface_name(string.gsub(entity_surface_name, " underground %- layer %d+", ""), 1)

    elseif string.match(name, "silo") then
        if string.match(entity_surface_name, "underground") then
            entity.destroy()
            surface.spill_item_stack(robot.position, {name=name, count=1, enable_looted=true})
            local dropped_item = surface.find_entities_filtered({type = "item-entity", position = robot.position, radius = 10})
            if dropped_item then
                dropped_item[1].order_deconstruction(robot.force)
            end
        end
    elseif name == "small-biter" then
        if used_item then
            if used_item.name == "wlw-small-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "medium-biter" then
        if used_item then
            if used_item.name == "wlw-medium-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "big-biter" then
        if used_item then
            if used_item.name == "wlw-big-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "behemoth-biter" then
        if used_item then
            if used_item.name == "wlw-behemoth-biter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "small-spitter" then
        if used_item then
            if used_item.name == "wlw-small-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "medium-spitter" then
        if used_item then
            if used_item.name == "wlw-medium-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "big-spitter" then
        if used_item then
            if used_item.name == "wlw-big-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    elseif name == "behemoth-spitter" then
        if used_item then
            if used_item.name == "wlw-behemoth-spitter-untamed" then
                entity.force = "enemy"
            end
        end
    end
end

function PlayerCreated(event)
    local player = game.get_player(event.player_index)

    if not (player and player.valid) then
        return
    end

    global.players[player.index] = { controls_active = true }
    if player and player.connected then
        if global.space_exploration_enabled then
            player.print("You are playing [color=0,1,1]What Lies Within[/color] with Space Exploration enabled. Compatibility is still a work in progress.")
        else
            player.print("Thank you for playing [color=0,1,1]What Lies Within[/color]. Join us on Discord: [color=0,1,0]https://discord.gg/q3tSrs3uRy[/color]")
        end
    end
end

function PlayerDied(event)
    local player = game.get_player(event.player_index)

    if not (player and player.valid) then
        return
    end

    player.print("You died. You will respawn on the surface.")
end

function PlayerRespawned(event)
    local player = game.get_player(event.player_index)

    if not (player and player.valid) then
        return
    end

    local top_surface = Zone.get_top_surface_name(player.surface)
    player.teleport(player.force.get_spawn_position(top_surface), top_surface)
end

function EntityDamaged(event)
    local entity = event.entity

    if not (entity and entity.valid) then
        return
    end

    local surface = entity.surface
    local position = entity.position
    local name = entity.name
    local final_health = event.final_health
    -- if this is an active unit being damaged
    if (entity.type == "unit" or entity.type == "turret") and entity.active then
        -- if it's an exploding enemy make smoke on it.
        if string.find(name, "exploding") then
            surface.create_trivial_smoke({name = "fire-smoke", position = {x = position.x, y = position.y - 1.5}, duration = 60})
        end
    end
end

function EntityDied(event)
    local entity = event.entity

    if not (entity and entity.valid) then
        return
    end

    local entity_surface = entity.surface
    local entity_position = entity.position
    local entity_name = entity.name

    -- if it is a unit and has exploding in its name
    if entity.type == "unit" and string.find(entity_name, "exploding") then
        -- if it's a small unit make a small explosion
        if string.find(entity_name, "small") then
            entity_surface.create_entity({name = "grenade", position = entity_position, target = entity_position, speed = 0})
        -- if it's a medium unit make a medium explosion
        elseif string.find(entity_name, "medium") then
            entity_surface.create_entity({name = "explosive-rocket", position = entity_position, target = entity_position, speed = 0})
        -- if it's a big unit make a big explosion
        elseif string.find(entity_name, "big") then
            -- do normal explosive rocket damage but look a lot bigger.
            entity_surface.create_entity({name = "explosive-rocket", position = entity_position, target = entity_position, speed = 0})
            entity_surface.create_entity({name = "massive-explosion", position = entity_position})
        -- if it's a behemoth unit make a behemoth explosion :)
        elseif string.find(entity_name, "behemoth") or string.find(entity_name, "leviathan") or string.find(entity_name, "mother") then
            entity_surface.create_entity({name = "atomic-rocket", position = entity_position, target = entity_position, speed = 0})
        -- if its name doesn't match any of those, but it did match exploding (modded units probably)
        -- then give it a default small explosion
        else
            entity_surface.create_entity({name = "grenade", position = entity_position, target = entity_position, speed = 0})
        end
    end

    -- otherwise if it's an item elevator destroy it and its companions.
    if entity_name == "wlw-item-elevator" then

        local inventory = entity.get_output_inventory()
        local entity_link_id = entity.link_id
        local entity_force_index = entity.force.index
        local companions = get_companion_elevators(entity)

        -- we subtract one here so that the next link id is the one that gets used.
        if global.last_used_link_id_by_force_index[entity_force_index] then
            global.last_used_link_id_by_force_index[entity_force_index] = entity_link_id - 1
        else
            global.last_used_link_id_by_force_index[entity_force_index] = 0
        end

        if inventory then
            inventory.clear()
        end

        -- destroy the medium pole that got placed with this item elevator.
        local medium_pole = entity_surface.find_entities_filtered(
            {
                position = entity_position,
                name = "medium-electric-pole"
            }
        )[1]

        if medium_pole and medium_pole.valid then
            medium_pole.destroy()
        end

        if companions then
            for i = 1, #companions do
                medium_pole = companions[i].surface.find_entities_filtered(
                    {
                        position = entity_position,
                        name = "medium-electric-pole"
                    }
                )[1]

                if medium_pole and medium_pole.valid then
                    medium_pole.destroy()
                end

                companions[i].die()
            end
        end
    end
end

function EntitySpawned(event)
    local entity = event.entity

    if not (entity and entity.valid) then
        return
    end

    local evolution = entity.force.evolution_factor
    local name = entity.name
    local surface = entity.surface
    local position = entity.position
    local direction = entity.direction
    local force = entity.force

    -- if it's a unit that spawned
    if entity.type == "unit" then
        -- and it isn't already exploding
        if not string.find(entity.name, "exploding") then
            -- first check if the exploding type of this entity was added in data stage.
            -- if a mod is added to a save that already has WLW enabled, we won't generate exploding types of the new units
            -- so before we replace a unit with its exploding type we need to make sure that actually exists.
            if game.entity_prototypes["wlw-exploding-" .. entity.name] then
                local chance = 0
                -- maximum 2% chance to be exploding, these guys work best in sparse numbers
                chance = evolution / (100 / 2) -- this denominator is the max % chance to spawn explodeys.
                local random = math.random()
                if random <= chance then
                    entity.destroy()
                    surface.create_entity({name = "wlw-exploding-" .. string.gsub(name, "wlw%-", ""), position = position, direction = direction, force = force})
                end
            end
        end
    end
end

function ChunkGenerated(event)
    local surface = event.surface
end

function SurfaceCreated(event)
    local surface_index = event.surface_index
    local surface = game.get_surface(surface_index)
    local underground_layer_in_name = string.find(surface.name, "underground %- layer")
    if underground_layer_in_name then
        -- don't create by surface index because we'll do that after we adjust everything.
        -- game.connected_players[1].teleport({x=0, y=0}, surface)
    else
        -- if it's not an underground layer then make a Zone out of it.
        Zone.create_from_surface_index(surface_index)
    end
    --game.connected_players[1].teleport({x = 0, y = 0}, surface.name)
    --game.connected_players[1].insert{name="stone-furnace", count = 1}
end

function SurfaceDeleted(event)
    Zone.rebuild_global_surface_lists()
end

function LuaShortcut(event)
    local player = game.get_player(event.player_index)
    local prototype_name = event.prototype_name

    if not (player and player.valid) then
        return
    end

    if not player.character then
        player.print("You can't be killed unless you have a body. Return to your body and try again.")
        return
    end

    if prototype_name == "wlw-travel" then
        toggle_travel_interface(player)
    elseif prototype_name == "wlw-respawn" then
        local top_surface = Zone.get_top_surface_name(player.surface)
        player.character.die()
        player.teleport(player.force.get_spawn_position(top_surface), top_surface)
    end
end

function GuiSelectionStateChanged(event)
    local player = game.get_player(event.player_index)

    if not (player and player.valid) then
        return
    end
    
    local parent_frame = event.element.parent
    if event.element.name == "wlw_travel_top_level_dropdown" then
        -- the player changed which top level they want, so update the sub surfaces for that top level.
        local sub_surfaces = {}
        local selected_item = event.element.get_item(event.element.selected_index)
        -- set the first sub surface to the top surface, so it shows up at the top of our list.
        table.insert(sub_surfaces, selected_item)

        -- then populate the rest of our list with sub surfaces.
        for name,zone in pairs(global.zones_by_name) do
            -- find all the underground layers for the selected surface.
            if string.find(name, selected_item[2] .. " underground %- layer") then
                table.insert(sub_surfaces, {"wlw-gui.surface-name", name})
            end
        end
        -- then update the sub surface dropdown
        parent_frame.wlw_travel_sub_level_dropdown.items=sub_surfaces
        parent_frame.wlw_travel_sub_level_dropdown.selected_index=1
    end
end

function keyboard_toggle_travel_interface(event)
    local player = game.get_player(event.player_index)
    toggle_travel_interface(player)
end

function OnTick(event)
    local nauvis = game.surfaces[1]

    if next(game.connected_players) ~= nil then
        -- first command friendly biters
        command_friendly_biters_to_follow_players()

        -- this range is inclusive, first number and last number are possible.
        -- right now the range goes up to 2.16m, which is the number of ticks in 10 hours. on average an atmosphere message should happen once every ten hours.
        -- these are meant to just be flavor.
        local atmosphere_message_random = math.random(1, 2146000)
        if atmosphere_message_random == 1 then
            -- send an atmosphere message to a random player.
            local target_player_index = math.random(1, #game.connected_players)
            local player = game.connected_players[target_player_index]
            if global.atmosphere_messages then
                local message_index = math.random(1, #global.atmosphere_messages)
                player.print(global.atmosphere_messages[message_index])
            else
                player.print("You feel an intense urge to venture further... [color=1,0,1]deeper...[/color]")
            end
        end
    end

    -- fix autoplace controls when other mods mess with them. right now we're strong arming, maybe play nicer in the future.
    if nauvis.map_gen_settings.autoplace_controls then
        local should_fix_incorrect_autoplaced = false
        if nauvis.map_gen_settings.autoplace_controls["wlw-gold-ore"].frequency > 0 then
            local map_gen_settings = nauvis.map_gen_settings
            log("Fixing wlw-gold-ore autoplace settings on nauvis on tick: " .. event.tick)
            map_gen_settings.autoplace_controls["wlw-gold-ore"] = {frequency = 0, size = 0, richness = 0}
            nauvis.map_gen_settings = map_gen_settings
            should_fix_incorrect_autoplaced = true
        end
        if nauvis.map_gen_settings.autoplace_controls["wlw-lead-ore"].frequency > 0 then
            local map_gen_settings = nauvis.map_gen_settings
            log("Fixing wlw-lead-ore autoplace settings on nauvis on tick: " .. event.tick)
            map_gen_settings.autoplace_controls["wlw-lead-ore"] = {frequency = 0, size = 0, richness = 0}
            nauvis.map_gen_settings = map_gen_settings
            should_fix_incorrect_autoplaced = true
        end
        if nauvis.map_gen_settings.autoplace_controls["wlw-platinum-ore"].frequency > 0 then
            local map_gen_settings = nauvis.map_gen_settings
            log("Fixing wlw-platinum-ore autoplace settings on nauvis on tick: " .. event.tick)
            map_gen_settings.autoplace_controls["wlw-platinum-ore"] = {frequency = 0, size = 0, richness = 0}
            nauvis.map_gen_settings = map_gen_settings
            should_fix_incorrect_autoplaced = true
        end
        if nauvis.map_gen_settings.autoplace_controls["wlw-silver-ore"].frequency > 0 then
            local map_gen_settings = nauvis.map_gen_settings
            log("Fixing wlw-silver-ore autoplace settings on nauvis on tick: " .. event.tick)
            map_gen_settings.autoplace_controls["wlw-silver-ore"] = {frequency = 0, size = 0, richness = 0}
            nauvis.map_gen_settings = map_gen_settings
            should_fix_incorrect_autoplaced = true
        end
        if should_fix_incorrect_autoplaced == true then
            Zone.delete_misplaced_autoplace_entities_for_surface_index(1)
        end
    end
end

function OnGuiClosed(event)
    if event.element and event.element.name == "wlw_travel_frame" then
        local player = game.get_player(event.player_index)
        toggle_travel_interface(player)
    end
end

-- register events to be listened to
script.on_init(OnInit)
script.on_configuration_changed(OnConfigurationChanged)
script.on_event(defines.events.on_tick, OnTick)
script.on_event(defines.events.on_gui_click, GuiClick)
script.on_event(defines.events.on_built_entity, OnBuiltEntity)
script.on_event(defines.events.on_robot_built_entity, OnRobotBuiltEntity)
script.on_event(defines.events.on_player_mined_entity, OnMinedEntity)
script.on_event(defines.events.on_robot_mined_entity, OnMinedEntity)
script.on_event(defines.events.script_raised_built, OnBuiltEntity)
script.on_event(defines.events.on_entity_damaged, EntityDamaged)
script.on_event(defines.events.on_entity_died, EntityDied)
script.on_event(defines.events.script_raised_destroy, EntityDied)
script.on_event(defines.events.on_entity_spawned, EntitySpawned)
script.on_event(defines.events.on_player_created, PlayerCreated)
script.on_event(defines.events.on_player_died, PlayerDied)
script.on_event(defines.events.on_player_respawned, PlayerRespawned)
script.on_event(defines.events.on_chunk_generated, ChunkGenerated)
script.on_event(defines.events.on_surface_created, SurfaceCreated)
script.on_event(defines.events.on_surface_deleted, SurfaceDeleted)
script.on_event(defines.events.on_lua_shortcut, LuaShortcut)
script.on_event(defines.events.on_gui_selection_state_changed, GuiSelectionStateChanged)
script.on_event(defines.events.on_gui_closed, OnGuiClosed)
script.on_event("wlw-toggle-travel-interface", keyboard_toggle_travel_interface)