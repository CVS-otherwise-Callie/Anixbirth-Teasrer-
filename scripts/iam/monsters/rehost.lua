local mod = FHAC
local game = Game()
local rng = RNG()

function mod:RehostAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()


    local speed = 0

    if not d.init then

        if npc.SubType == 1 then
            d.state = "chase"
        else
            d.state = "spawned"

            if npc.SubType == 0 then
                npc.SubType = math.random(20, 50)
            end
        end

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "spawned" then

        if npc.StateFrame > npc.SubType then
            mod:spriteOverlayPlay(sprite, "HeadReComeoutSlow")
            if sprite:IsOverlayFinished() then
                npc.StateFrame = 30
                d.state = "chase"
            end
        else
            mod:spriteOverlayPlay(sprite, "HeadNoRe")
        end
    end

    if d.state == "chase" then

        speed = 3
        mod:spriteOverlayPlay(sprite, "HeadReIdle")

    elseif d.state == "shoot" then

        speed = 2
        mod:spriteOverlayPlay(sprite, "HeadReShoot")

    end

    if npc.StateFrame > 80 and d.state == "chase" then
        d.state = "shoot"
    end

    if not (d.state == "spawned") then
        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            if sprite:GetOverlayAnimation() == "Head" then sprite:SetOverlayFrame("Head", 19) end
            sprite:SetFrame("WalkHori", 0)
        end
    else
        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkHori", 0)
        end
        speed = 1.5
    end

    if mod:isScare(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(speed * -1.2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
    elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
        local targetvelocity = (targetpos - npc.Position):Resized(speed * 1.2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
    else
        path:FindGridPath(targetpos, speed * 0.2, 1, true)
    end

    if sprite:IsOverlayPlaying("HeadReShoot") and sprite:GetOverlayFrame() == 10 then
        npc:PlaySound(SoundEffect.SOUND_WHIP, 1, 2, false, 1.5)
        npc:PlaySound(SoundEffect.SOUND_WORM_SPIT, 1, 2, false, 1.3)
        local realshot = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(10, 0):Rotated(((targetpos + target.Velocity) - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        realshot.Scale = 0.8
        if room:GetBackdropType() == BackdropType.DROSS then
            realshot.Color = Color(0.4, 0.3, 0.08, 1, 0, 0, 0)
        elseif not (room:GetBackdropType() == BackdropType.DOWNPOUR) then
            realshot.Color = Color(0.9, 0.3, 0.08, 1, 0, 0, 0)
        end
        realshot.Height = -50
        realshot:AddProjectileFlags(ProjectileFlags.BURST)
    end

    if sprite:IsOverlayFinished("HeadReShoot") then
        d.state = "chase"
        npc.StateFrame = 0
    end

    if sprite:IsOverlayPlaying ("HeadReComeoutSlow") and sprite:GetOverlayFrame() == 39 then
        game:SpawnParticles ( npc.Position, 7, 3, 4, Color.Default, 10, 0 )
        game:SpawnParticles ( npc.Position, 5, 5, 5, Color.Default, 10, 0 )
        npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 2, false, 1.5)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt , flag, source)
    if npc.Type == mod.Monsters.Rehost.ID and npc.Variant == mod.Monsters.Rehost.Var then
        if not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, flag) and npc:GetData().state == "spawned" then
            npc:TakeDamage(amt*0.4 , flag | DamageFlag.DAMAGE_CLONES, source, 0)
            return false
        end
    end
end)