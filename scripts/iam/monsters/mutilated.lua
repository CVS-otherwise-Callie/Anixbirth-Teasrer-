local mod = FHAC
local game = Game()
local rng = RNG()

function mod:MutilatedAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        --d.state = "lockedup"
        d.state = "freerun"
        d.init = true
    end

    if d.state == "freerun" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end

        npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
    end

    sprite:PlayOverlay("Head")

end

