local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Burntlet.Var then
        mod:BurntletAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Burntlet.ID)

function mod:BurntletAI(npc, sprite, d)

    local path = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        d.state = "follow"
        d.randOff = math.random(0, 20)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "follow" then

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        elseif Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) then
            local targetvelocity = (targetpos - npc.Position):Resized(3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        else
            path:FindGridPath(targetpos, 0.4, 1, true)
        end

        if npc.StateFrame > 50 + d.randOff and npc.Position:Distance(targetpos) <= 100 then
            d.state = "attacl"
        end

        mod:spritePlay(sprite, "Idle")
    elseif d.state == "attacl" then
        mod:spritePlay(sprite, "Attack")

        npc:MultiplyFriction(0.4)

        if sprite:IsFinished("Attack") then
            d.state = "follow"
            npc.StateFrame = 0
        end
    end

    if sprite:IsEventTriggered("Flames1") then
        for i = 1, 4 do
            local fire = Isaac.Spawn(1000, mod.Effects.FireProjectile.Var, 0, npc.Position + Vector(2, 0):Rotated(90*i), Vector(15, 0):Rotated(90*i), nil)
            fire:GetData().turn = 30
            fire:GetData().timer = 100
        end
    elseif sprite:IsEventTriggered("Flames2") then
        for i = 1, 4 do
            local fire = Isaac.Spawn(1000, mod.Effects.FireProjectile.Var, 0, npc.Position + Vector(2, 0):Rotated((90*i)), Vector(15, 0):Rotated((90*i) + 20), nil)
            fire:GetData().turn = -30
            fire:GetData().timer = 100
        end
    end

end

