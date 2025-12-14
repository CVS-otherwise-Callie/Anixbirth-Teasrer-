local mod = FHAC
local game = Game()
local rng = RNG()

function mod:ScattcomAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.state = "idle"
        d.init = true
        d.icanMove = false
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")

        npc.Velocity = Vector.Zero
        if npc.StateFrame > 20 then
            d.state = "hop"
        end
    elseif d.state == "hop" then
        mod:spritePlay(sprite, "Hop")
    end

    if sprite:IsEventTriggered("air") then
        d.icanMove = true
    elseif sprite:IsEventTriggered("land") then
        d.icanMove = false
    end

    if sprite:IsFinished("Hop") then
        d.state = "idle"
        npc.StateFrame = 0
    end

    if d.icanMove and d.targetvelocity then
        if mod:isScare(npc) then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end
    else
        if mod:isScare(npc) then
            d.targetvelocity = (targetpos - npc.Position):Resized(-7)
        else
            d.targetvelocity = (targetpos - npc.Position):Resized(7)
        end
        npc:MultiplyFriction(0.9)
    end

end

function mod.ScattcomDEATHOHNOAI(npc)
    local sprite = npc:GetSprite()
    local d = npc:GetData()

    if npc.Type == mod.Monsters.Scattcom.ID and npc.Variant == mod.Monsters.Scattcom.Var then
        Isaac.Spawn(4, mod.Bombs.ScattcomBomb.Var, 0, npc.Position, npc.Velocity, npc)
    end
end

