local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SootAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        sprite:PlayOverlay("Eyes")
        d.state = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
        path:MoveRandomly(false)
        npc:MultiplyFriction(0.65+(0.016))

        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame > math.random(15, 20) then
            if math.random(0, 2) > 1 then
                d.newpos = targetpos
            else
                d.newpos = mod:freeGrid(npc, false, 300, 200) or mod:freeHole(npc, false, 300, 0)
            end
            d.rot = (targetpos - npc.Position):GetAngleDegrees()
            mod:spritePlay(sprite, "Move")
            d.state = nil
        end
    end

    npc:MultiplyFriction(0.9)

    if d.state == "move" then
        --sprite.Rotation = d.rot
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.9)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.9)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end
        d.state = nil
    end

    if sprite:IsEventTriggered("Move") then
        d.state = "move"
    end

    if sprite:IsFinished("Move") then
        d.state = "idle"
        npc.StateFrame = 0
    end

end

