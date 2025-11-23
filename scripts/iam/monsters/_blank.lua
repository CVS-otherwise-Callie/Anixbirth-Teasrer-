local mod = FHAC
local game = Game()
local rng = RNG()

function mod:BlankAI(npc, sprite, d)

    if not d.init then
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

end

