-- in v0.0.51023 I added the steel casting recipes to the wlw-casting technology, they had be missed previously.
-- This means that when migrating to this version players who have already researched wlw-casting will need those recipes unlocked retroactively.
-- This can be done using force.reset_technology_effects()

for index, force in pairs(game.forces) do
    force.reset_technology_effects()
end