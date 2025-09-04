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

    if d.state == "findrain" then
        if not d.rainSource or (not d.rainSource:Exists() or d.rainSource:IsDead()) then
            d.rainSource = FindRainGridSource(npc)
        end

        if not d.rainSource then
            d.state = nil
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
            path:FindGridPath(d.rainSource.Position, 1.3, 1, true)
        end
    
        if npc.Position:Distance(d.rainSource.Position) < 15 then
            d.state = "atRain"
        end
    elseif d.state == "atRain" then

        if not CheckRainNearby(npc.Position, 100) then
            --print(CheckRainNearby(npc.Position, 100))
            d.state = "findrain"
        end

        if d.fullness > 70 + d.waitOffset then
            d.state = "chase"
        end

        npc:MultiplyFriction(0.5)

        mod:spritePlay(sprite, "UnderRain")
        d.fullness = d.fullness + math.random(1, 2)/2
    elseif d.state == "chase" then

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end

        if d.fullness < 30 then
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

    if not sprite:IsPlaying("UnderRain") and d.state == "atRain" then
        if npc.Velocity:Length() > 0.3 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkHori", 0)
        end
    end

end

function mod:StoneJohnnyGetHurt(npc, damage, flag, source)

    local target = npc:ToNPC():GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    local amt = damage
    if damage > amt then
        amt = 10
    end
    for i = 1, math.random(amt) do
        local realshot = Isaac.Spawn(9, 1, 0, npc.Position, Vector(8, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() + math.random(1, 5)*(i-0.7)*10), npc):ToProjectile()
        realshot.FallingAccel = 0.01
        realshot.FallingSpeed = 0.1
        realshot:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
    end
end

