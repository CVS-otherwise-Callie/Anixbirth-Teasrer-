local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    state = "findrain",
    fullness = 30,
    rainSource = nil,
    waitOffset = math.random(-15, 20)
}

local function FindRainGridSource(npc)
    local grid
    local dist = 99999
    local tab = Isaac.FindByType(1000, EffectVariant.RAIN_DROP)
    for _, ent in ipairs(tab) do
        if ent.Position:Distance(npc.Position) < dist then
            dist = ent.Position:Distance(npc.Position)
            grid = ent
        end
    end
    if #tab > 0 then
        return grid
    else
        return nil
    end
end

local function CheckRainNearby(pos, rad)
    for k, v in ipairs(Isaac.FindByType(1000, EffectVariant.RAIN_DROP)) do
        if v.Position:Distance(pos) < rad then
            return true
        end
    end
    return false
end

function mod:StoneJohnnyAI(npc, sprite, d)

    local room = Game():GetRoom()
    local path = npc.Pathfinder
    local target = npc:ToNPC():GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    
    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end

        if #Isaac.FindByType(1000, EffectVariant.RAIN_DROP) == 0 then
            Isaac.Spawn(1000, mod.Effects.RainGridEffect.Var, 0, room:GetClampedPosition(npc.Position + Vector(math.random(-100, 100), math.random(-100, 100)), 15)+ (Vector(10, 0)):Rotated((target.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20)), Vector.Zero, npc)
        end

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    -- fullness --

    d.fullness = math.min(d.fullness, 100)
    local animFullness = "Full" .. tostring(math.ceil(d.fullness/20))
    local direc = mod:GetMoveString(npc.Velocity, false, false)

    if direc == "Up" then
        animFullness = ""
    end

    if d.state ~= "atRain" then
        mod:spriteOverlayPlay(sprite, "Head" .. direc .. animFullness)
    end


    if d.state == "findrain" then
        if not d.rainSource or (not d.rainSource:Exists() or d.rainSource:IsDead()) then
            d.rainSource = FindRainGridSource(npc)
        end

        d.finishedTransition = false

        if not d.rainSource then
            d.state = nil
            return
        end

        if mod:isScare(npc) then
            local targetvelocity = (d.rainSource.Position - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,d.rainSource.Position,0,1,false,false) then
            if not d.rainSource or (not d.rainSource:Exists() or d.rainSource:IsDead()) then
                return
            end
            local targetvelocity = (d.rainSource.Position - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(d.rainSource.Position, 0.6, 1, true)
        end
    
        if npc.Position:Distance(d.rainSource.Position) < 15 then
            d.state = "atRain"
        end
    elseif d.state == "atRain" then

        npc:MultiplyFriction(0.5)

        if not d.finishedTransition then
            mod:spriteOverlayPlay(sprite, "UnderRainFillUpTransition" .. tostring(math.ceil(d.fullness/20)))
        else
            if not CheckRainNearby(npc.Position, 100) then
                d.state = "findrain"
            end

            if d.fullness > 70 + d.waitOffset then
                mod:spriteOverlayPlay(sprite, "UnderRainFillDownTransition" .. tostring(math.ceil(d.fullness/20)))
            else
                mod:spriteOverlayPlay(sprite, "UnderRainFillUp" .. tostring(math.ceil(d.fullness/20)))
                d.fullness = d.fullness + math.random(1, 2)/2
            end
        end
    elseif d.state == "chase" then

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 0.6, 1, true)
        end

        if d.fullness < 30 and d.waitOffset > -50 then
            d.state = "findrain"
        end
    else
        npc:MultiplyFriction(0.5)

        local g = FindRainGridSource(npc)
        if g then
            d.rainSource = g
            d.state = "findrain"
        end
    end

    if sprite:IsOverlayFinished() and string.find(sprite:GetOverlayAnimation(), "UnderRainFillUpTransition") then
        d.finishedTransition = true
    elseif sprite:IsOverlayFinished() and string.find(sprite:GetOverlayAnimation(), "UnderRainFillDownTransition") then
        d.waitOffset = math.max(d.waitOffset - 10, -70)
        d.state = "chase"
    end

    if npc.Velocity:Length() > 0.1 then
        if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
            mod:spritePlay(sprite, "WalkVert")
        else
            if npc.Velocity.X > 0 then
                mod:spritePlay(sprite, "WalkRight")
            else
                mod:spritePlay(sprite, "WalkLeft")
            end
        end
    else
        sprite:SetFrame("WalkVert", 0)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.StoneJohnny.Var then
        local target = npc:ToNPC():GetPlayerTarget()
        local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

        if (npc:GetData().fullness - damage) < 0 then
            npc:Kill()
        end

        local amt = damage
        if damage > amt then
            amt = 10
        end
        for i = 1, math.random(math.ceil(amt)) do
            npc:GetData().fullness = npc:GetData().fullness - 2
            local realshot = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(5, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() + math.random(1, 5)*(i-0.7)*10), npc):ToProjectile()
            realshot.Height = -5
            realshot.FallingSpeed = -20
            realshot.FallingAccel = 1
            realshot:Update()
            realshot.Scale = math.random(30, 70)/100
            realshot:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
        end
        return false 
    end
end, mod.Monsters.StoneJohnny.ID )

