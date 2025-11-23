local mod = FHAC
local game = Game()
local rng = RNG()

function mod:HuoAI(npc, sprite, d)

    local animPre = ""

    if not d.init then

        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, npc.Position, true)
        
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    

end

