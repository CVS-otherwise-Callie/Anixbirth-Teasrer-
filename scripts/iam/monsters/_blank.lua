local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {

}

function mod:BlankAI(npc, sprite, d)

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    end

end

