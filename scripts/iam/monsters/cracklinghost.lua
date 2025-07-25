local mod = FHAC
local game = Game()
local sfx = SFXManager()

local cracklingHostStats = {
    wait = 20,
    state = "waiting",
    fireHp = 20
}

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.CracklingHost.Var then
        mod:CracklingHostAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.CracklingHost.ID)

function mod:CracklingHostAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        for name, stat in pairs(cracklingHostStats) do
            d[name] = d[name] or stat
        end
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.fireHp > 0 then
        if npc.StateFrame > d.wait and not mod:isScaredOrConfuse(npc)  then
            d.wait = math.random(20, 30)
            mod:spritePlay(sprite, "ShootFire")
        else
            mod:spritePlay(sprite, "IdleFire")
        end
    else
        if npc.StateFrame > 70 then
            mod:spritePlay(sprite, "Ignite")
            d.fireHp = 20
        else
            if npc.StateFrame > d.wait and not mod:isScaredOrConfuse(npc) then
                d.wait = npc.StateFrame + math.random(15, 25)
                mod:spritePlay(sprite, "ShootBare")
            else
                mod:spritePlay(sprite, "IdleBare")
            end
        end
    end

    if sprite:IsEventTriggered("shoot") then
        if d.fireHp > 0 then
            FHAC:ShootFire(npc.Position, (targetpos - npc.Position):Resized(15), {scale = 1.1, timer = 150, hp = 2, radius = 19})
        else
            local projectile = Isaac.Spawn(9, mod.Projectiles.EmberProjectile.Var, 0, npc.Position, (targetpos - npc.Position):Resized(10), npc)
        end
    end

    if sprite:IsFinished("ShootFire") or sprite:IsFinished("ShootBare") then
        npc.StateFrame = 0
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.CracklingHost.Var then
        local d = npc:GetData()

        if d.fireHp > 0 then
            d.fireHp = d.fireHp - damage
            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 2, 1, false, 1)
            return false
        elseif npc:GetSprite():IsPlaying("Ignite") then
            return false
        end
    end
end, mod.Monsters.CracklingHost.ID)

