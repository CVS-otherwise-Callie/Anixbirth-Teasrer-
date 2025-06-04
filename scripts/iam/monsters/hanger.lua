local mod = FHAC
local game = Game()
local rng = RNG()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Hanger.Var then
        mod:HangerAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
    end
end, mod.Monsters.Hanger.ID)
        --thx fiend folio
function mod:HangerAI(npc, sprite, d, r)

    local params = ProjectileParams()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local boostPos = d.oldietarg or targetpos

    if not d.init then
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        npc.SpriteOffset = Vector(0,-10)
        d.boost = math.random(5, 10)/10
        d.init = true
    else
        d.boost = math.random(8, 13)/8
        npc.StateFrame = npc.StateFrame + 1
    end

    local enemydir = (targetpos - npc.Position):GetAngleDegrees()

    if enemydir > -90 and enemydir < -67.5 then
        d.diranim = "North"
    elseif enemydir > -67.5 and enemydir < -45 then
        d.diranim = "NorthWest"
    elseif enemydir > -45 and enemydir < -22.5 then
        d.diranim = "NorthWest2"
    elseif enemydir > -22.5 and enemydir < 22.5 then
        d.diranim = "West"
    elseif enemydir > 22.5 and enemydir < 45 then
        d.diranim = "SouthWest2"
    elseif enemydir > 45 and enemydir < 67.5 then
        d.diranim = "SouthWest"
    elseif enemydir > 67.5 and enemydir < 112.5 then
        d.diranim = "South"
    elseif enemydir > 112.5 and enemydir < 135 then
        d.diranim = "SouthWest"
    elseif enemydir > 135 and enemydir < 157.5 then
        d.diranim = "SouthWest2"
    elseif enemydir > 157.5 and enemydir < 181 then
        d.diranim = "West"
    elseif enemydir > -180 and enemydir < -157.7 then
        d.diranim = "West"
    elseif enemydir > -157.5 and enemydir < -135 then
        d.diranim = "NorthWest2"
    elseif enemydir > -135 and enemydir < -90 then
        d.diranim = "NorthWest"
    else
        d.diranim = "North"
    end

    if d.animinit == false or d.diranim ~= d.oldanim then
        d.animinit = true
        sprite:Play(d.diranim, true)
    end

    if npc.Position:Distance(boostPos) < 100 and d.state ~= "shooooot" then
        d.state = "shooooot"
        npc.StateFrame = 0
    end

    if (npc.Position:Distance(boostPos) > 140 or npc.StateFrame > 20) and d.state == "shooooot" then
        d.state = nil
    end

    if mod:isScare(npc) then
        if target.Position.X < npc.Position.X then
            sprite.FlipX = true
            else
            sprite.FlipX = false
        end
    else
        if target.Position.X < npc.Position.X then
            sprite.FlipX = false
            else
            sprite.FlipX = true
        end
    end

    if d.state == "shooooot" then

        d.oldietarg = d.oldietarg or targetpos

        params.BulletFlags = params.BulletFlags | ProjectileFlags.NO_WALL_COLLIDE

        params.Color = Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)

        params.FallingAccelModifier = -0.1

        params.Scale = 0.5

        if npc.StateFrame%2 == 0 then
            npc:FireProjectiles(npc.Position + (d.oldietarg - npc.Position):Resized(1), (d.oldietarg - npc.Position):Resized(10), 0, params)
        end
   
        npc.Velocity = mod:Lerp(npc.Velocity, (d.oldietarg - npc.Position):Resized(d.boost*-4), d.boost/1.5)
    else
        d.oldietarg = nil
        if mod:isScare(npc) or d.state == "dashout" then
            local targetvelocity = (targetpos - npc.Position):Resized(d.boost*-3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.boost/5)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(d.boost*3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.boost/5)
        end
    end
end

function mod.FloaterTearUpdate(tear)
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        local d = v:GetData()
        if v.Type == Isaac.GetEntityTypeByName("Floater") and v.Variant == Isaac.GetEntityVariantByName("Floater") and v.SubType == 0 then
            local target = v:ToNPC():GetPlayerTarget()
            if math.abs(((target.Position - tear.Position):GetAngleDegrees() - (target.Position - v.Position):GetAngleDegrees())) < 40 and tear.Position:Distance(v.Position) < 100 and not tear:IsDead() and d.state ~= "dashout" then
                d.tearTarg = tear
                d.accelerateaway = d.dashper
            end
        end
    end
end