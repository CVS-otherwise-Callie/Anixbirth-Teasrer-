local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.ReHost.Var then
        mod:ReHostAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.ReHost.ID)

function mod:ReHostAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 0

    if not d.init then
        

        d.state = "chase"

        npc.StateFrame = 30

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "chase" then

        speed = 3
        mod:spriteOverlayPlay(sprite, "HeadReIdle")

    elseif d.state == "shoot" then

        speed = 2
        mod:spriteOverlayPlay(sprite, "HeadReShoot")

    end

    if npc.StateFrame > 80 then
        d.state = "shoot"
    end

    if mod:isScare(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(speed * -1.2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
    elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
        local targetvelocity = (targetpos - npc.Position):Resized(speed * 1.2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
    else
        path:FindGridPath(targetpos, 0.7, 1, true)
    end

    if npc.Velocity:Length() > 1 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
    else
        if sprite:GetOverlayAnimation() == "Head" then sprite:SetOverlayFrame("Head", 19) end
        sprite:SetFrame("WalkHori", 0)
    end

    if sprite:IsOverlayPlaying("HeadReShoot") and sprite:GetOverlayFrame() == 10 then
        npc:PlaySound(SoundEffect.SOUND_WHIP, 1, 2, false, 1.5)
        npc:PlaySound(SoundEffect.SOUND_WORM_SPIT, 1, 2, false, 1.3)
        local realshot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated(((targetpos + target.Velocity) - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        realshot.Scale = 0.8
        realshot.Color = Color(0.9, 0.3, 0.08, 1, 0, 0, 0)
        realshot:AddProjectileFlags(ProjectileFlags.BURST)
    end

    if sprite:IsOverlayFinished("HeadReShoot") then
        d.state = "chase"
        npc.StateFrame = 0
    end

end