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
    end

    if d.coolaccel and d.coolaccel < d.max then
        d.coolaccel = 0.5
        d.coolaccel = d.coolaccel + 0.1
    end

    if mod:isScare(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(-15)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.funnyasslerp)
    else
        local targetvelocity = (targetpos - npc.Position):Resized(15)
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
        local sprite = ent:GetSprite()
        game:ButterBeanFart(npc.Position, 100, npc, true, false)
        local cloud = Isaac.Spawn(1000, 141, 1, npc.Position, npc.Velocity:Resized(3), npc):ToEffect()
        cloud:SetTimeout(cloud.Timeout * 1000)
        cloud.LifeSpan = cloud.LifeSpan * 1000
        cloud.Timeout = cloud.Timeout * 1000
    end
end

