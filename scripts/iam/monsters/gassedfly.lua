local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.GassedFly.Var then
        mod:GassedFlyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.GassedFly.ID)

function mod:GassedFlyAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil) + Vector(10, 0):Rotated(rng:RandomInt(0, 360))
    if not d.init then
        npc.StateFrame = 21
        d.moveit = 0
        d.wobb = 0
        d.funnyasslerp = 0.06
        d.coolaccel = 0.5
        d.fartmultiplier = 0.5
        d.max = 2.5
        sprite:Play("Fly")
        if rng:RandomInt(1, 3) == 3 or npc:IsChampion() then
            d.funnyasslerp = 0.02
            d.max = 1
            d.fartmultiplier = 2
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/gassedfly/gassedfly", 0)
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > 20 then
        d.newpos = target.Position
        npc.StateFrame = 0
    end

    if d.coolaccel and d.coolaccel < d.max then
        d.coolaccel = 0.5
        d.coolaccel = d.coolaccel + 0.1
    end

    if d.moveit >= 360 then d.moveit = 0 else d.moveit = d.moveit + 0.07 end
    d.wobb = d.wobb + math.pi/math.random(3,12)

    local vel = mod:GetCirc((5) + math.sin(d.wobb), d.moveit)

    if mod:isScare(npc) then
        local targetvelocity = (Vector(d.newpos.X - vel.X, d.newpos.Y - vel.Y) - npc.Position):Resized(-15)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.funnyasslerp)
    else
        local targetvelocity = (Vector(d.newpos.X - vel.X, d.newpos.Y - vel.Y) - npc.Position):Resized(15)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.funnyasslerp)
    end
    npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.funnyasslerp)
    if npc:CollidesWithGrid() then
        d.coolaccel = 1
    end
    mod:CatheryPathFinding(npc, target.Position, {
        Speed = d.coolaccel,
        Accel = d.funnyasslerp,
        GiveUp = true
    })
    if rng:RandomInt(1, 2) == 2 then
        d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.04, 0.05)
    else
        d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.01, 0.02)
    end

    if target.Position.X < npc.Position.X then --future me pls don't fuck this up
		sprite.FlipX = true
	else
		sprite.FlipX = false
	end

end

function mod.GassedFlyDeath(ent)
    if ent.Type == 161 and ent.Variant == mod.Monsters.GassedFly.Var then
        local npc = ent:ToNPC()
        game:ButterBeanFart(npc.Position, 100, npc, true, false)
        local cloud = Isaac.Spawn(1000, 141, 1, npc.Position, npc.Velocity:Resized(3), npc):ToEffect()
        cloud:SetTimeout(cloud.Timeout * 1000)
        cloud.LifeSpan = cloud.LifeSpan * 1000
        cloud.Timeout = cloud.Timeout * 1000
    end
end

