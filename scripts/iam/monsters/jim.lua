local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Jim.Var then
        mod:JimAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Jim.ID)

function mod:JimAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.state = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if mod:isScareOrConfuse(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(-3)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
    else
        local targetvelocity = (targetpos - npc.Position):Resized(3)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
    end

    if d.state == "idle" then

        mod:spritePlay(sprite, "Idle")

        if npc.StateFrame > 20 then
            d.state = "attack"
        end
    end

    if d.state == "attack" then
        mod:spritePlay(sprite, "Attack")
    end

    if sprite:IsEventTriggered("Shoot") then
        npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT)
        for i = 1, 4 do
            local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, 0, npc.Position, Vector(5, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() -40+ (20*i)):Resized(10), npc)
        end
    end

    if sprite:IsFinished("Attack") then
        d.state = "idle"
        npc.StateFrame = 0
    end

end

