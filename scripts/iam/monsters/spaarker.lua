local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SpaarkerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        d.shootoffset = math.random(1, 25)
        d.init = true
    end

    npc.StateFrame = npc.StateFrame + 1

    path:MoveRandomly(false)
    npc:MultiplyFriction(0.65+(0.016))
    npc.Velocity = mod:Lerp(npc.Velocity, (targetpos - npc.Position):Resized(1), 0.1)

    if npc.StateFrame > (10 + d.shootoffset)*1.5 and not mod:isScareOrConfuse(npc) then
        mod:spritePlay(sprite, "Shoot")
    else
        mod:spritePlay(sprite, "Idle")
    end

    if sprite:IsEventTriggered("Shoot") then
        npc:PlaySound(SoundEffect.SOUND_PESTILENCE_MAGGOT_SHOOT2, 1, 2, false, 2)
        mod:ShootFire(npc.Position, (targetpos - npc.Position):Resized(15):Rotated(math.random(-10, 10)), {scale = 1, timer = 150, radius = 20})
    end

    if sprite:IsFinished("Shoot") then
        npc.StateFrame = 0
        d.shootoffset = math.random(1, 25)
    end

    if target.Position.X < npc.Position.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flags, guy)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Spaarker.Var and flags == flags | DamageFlag.DAMAGE_FIRE then
        return false
    end
end)
