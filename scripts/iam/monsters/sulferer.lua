local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    isBurned = false,
    shootWaitTime = 50,
    state = "gaperwalk"
}

function mod:SulfererAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "gaperwalk" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end

        if npc.Velocity:Length() > 0.1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkHori", 0)
        end
    elseif d.state == "angrywalk" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end

        if npc.Velocity:Length() > 0.1 then
            npc:AnimWalkFrame("WalkHoriMad","WalkVertMad",0)
        else
            sprite:SetFrame("WalkHoriMad", 0)
        end

        if npc.StateFrame > d.shootWaitTime then
            d.state = "angryshoot"
        end
    elseif d.state == "angryshoot" then
        npc:MultiplyFriction(0.5)
        mod:spritePlay(sprite, "Shoot")
    end

    if sprite:IsEventTriggered("shoot") then
        Isaac.Spawn(EntityType.ENTITY_PROJECTILE, mod.Projectiles.EmberProjectile, 0, npc.Position, (targetpos - npc.Position):Resized(10), npc)
    end

    if sprite:IsFinished("Burn") then
        npc.StateFrame = 0
        d.isBurned = true
        d.state = "angrywalk"
    elseif sprite:IsFinished("Shoot") then
        npc.StateFrame = 0
        d.state = "angrywalk"
    end

end

function mod:SulfererTakeDamage(npc, damage, flag, source)
    if npc:GetSprite():IsPlaying("Burn") then
        return false
    elseif (npc.HitPoints - damage <= 0) and not npc:GetData().isBurned then
        npc:GetData().state = nil
        mod:spritePlay(npc:GetSprite(), "Burn")
        return false
    end
end

