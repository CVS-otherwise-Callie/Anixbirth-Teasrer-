local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Sho.Var then
        mod:ShoAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Sho.ID)

function mod:ShoAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()


    if not d.init then
        d.coolaccel = 0
        d.lerpnonsense = 0
        d.state = "scared"
        d.init = true
    end

    if d.state == "scared" then

        mod:spritePlay(sprite, "idle")

        npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
        path:MoveRandomly(false)
        npc:MultiplyFriction(0.65+(0.016))
        if npc.Parent then
            if npc.Parent:IsDead() then
                d.state = "angry"
            end
        end
    end

    if d.state == "angry" then

        mod:spritePlay(sprite, "angry")

        if d.coolaccel and d.coolaccel < 5 then
            d.coolaccel = d.coolaccel + 0.1
        end
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        end
        npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
        if npc:CollidesWithGrid() then
            d.coolaccel = 1
        end
        mod:CatheryPathFinding(npc, target.Position, {
            Speed = d.coolaccel,
            Accel = d.lerpnonsense,
            GiveUp = true
        })
        if rng:RandomInt(1, 2) == 2 then
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
        else
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
        end
    else
        d.coolaccel = 1
    end

end

