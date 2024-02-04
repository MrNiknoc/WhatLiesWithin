-- This is where we create the prototypes for our custom units.
-- as of v0.0.33 it's only used to add enraged units.

-- add exploding versions of each unit. when the unit dies it explodes :)
local explodingUnits = {}
for name, prototype in pairs(data.raw.unit) do
    local explodingUnit = table.deepcopy(data.raw["unit"][name])
    local nameWords = {}
    for word in string.gmatch(explodingUnit.name, "%a+") do
        table.insert(nameWords, word)
    end
    explodingUnit.name = "wlw-exploding-" .. string.gsub(explodingUnit.name, "wlw%-", "")
    explodingUnit.localised_name = "Exploding"
    for _, word in pairs(nameWords) do
        word = string.lower(word)
        if word ~= "wlw" then
            explodingUnit.localised_name = explodingUnit.localised_name .. " " .. word
        end
    end

    -- exploding units should be half as fast so we can run away from them easier.
    if explodingUnit.movement_speed then
        explodingUnit.movement_speed = explodingUnit.movement_speed / 2
    end

    -- They should also have 0 resistance to explosions to promote chain reactions.
    if explodingUnit.resistances then
        for i, resistance in pairs(explodingUnit.resistances) do
            if resistance.type == "explosion" then
                resistance.decrease = 0
                resistance.percent = 0
                break
            end
        end
    end

    -- tint all the run animation layers
    if explodingUnit.run_animation then
        if explodingUnit.run_animation.layers then
            for _, layer in pairs(explodingUnit.run_animation.layers) do
                local tint = {r=0.5, b=0.5, g=0.5, a=1}
                layer.tint = tint
                if layer.hr_version then
                    layer.hr_version.tint = tint
                end
            end
        end
    end
    -- tint all the attack animation layers
    if explodingUnit.attack_parameters then
        if explodingUnit.attack_parameters.animation then
            if explodingUnit.attack_parameters.animation.layers then
                for _, layer in pairs(explodingUnit.attack_parameters.animation.layers) do
                    local tint = {r=0.5, b=0.5, g=0.5, a=1}
                    layer.tint = tint
                    if layer.hr_version then
                        layer.hr_version.tint = tint
                    end
                end
            end
        end
    end
    explodingUnit.order = explodingUnit.name
    table.insert(explodingUnits, explodingUnit)
end
data:extend(explodingUnits)