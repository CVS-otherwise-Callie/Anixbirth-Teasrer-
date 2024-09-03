local mod = FHAC
local game = Game()
local rng = RNG()
local room = Game():GetRoom()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Floater.Var then
        mod:FloaterAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
    end
end, mod.Monsters.Floater.ID)

        --thx fiend folio
function mod:FloaterAI(npc, sprite, d, r)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (targetpos - npc.Position):GetAngleDegrees()
    local targetvelocity = Vector.Zero
    local othertargetvelocity = Vector.Zero
        
    if not d.init then
        d.realboost = rng:RandomInt(15, 35)/10
        npc.StateFrame = 50
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        d.dashper = 120 -- change this to however bad you want it to be! I like the 100 range, personally.
        d.state = "chase"
        npc.SpriteOffset = Vector(0,-10 - d.realboost)
        d.accelerateaway = 0
        d.boost = rng:RandomInt(15, 35)/10
        d.init = true
    else
        d.boost = rng:RandomInt(15, 35)/8
        d.oldanim = d.diranim
        npc.StateFrame = npc.StateFrame + 1
    end

    d.oldanim = d.diranim

    if mod:isScare(npc) then
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

        if target.Position.X < npc.Position.X then
            sprite.FlipX = true
            else
            sprite.FlipX = false
        end
    else
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

        if target.Position.X < npc.Position.X then
            sprite.FlipX = false
            else
            sprite.FlipX = true
        end
    end

    if d.state == "dashout" then
        d.moveval = Vector.Zero

        if (enemydir > 135 and enemydir < 180) or (enemydir > 0 and enemydir < 45) then
            d.moveval = Vector(0, -1 * d.accelerateaway/10)
        end
        if (enemydir > -180 and enemydir < -135) or (enemydir < 0 and enemydir > -45) then
            d.moveval = Vector(0, d.accelerateaway/10)
        end
        if (enemydir < -90 and enemydir > -135) or (enemydir > 90 and enemydir < 135) then
            d.moveval = Vector(-1 * d.accelerateaway/10, 0)
        end
        if (enemydir < -45 and enemydir > -90) or (enemydir > 45 and enemydir < 90) then
            d.moveval = Vector(d.accelerateaway/10, 0)
        end

        if not mod:isScare(npc) then
            othertargetvelocity = (targetpos + d.moveval - npc.Position):Resized(d.boost*1.5)
        else
            othertargetvelocity = (targetpos:Rotated(180) + d.moveval - npc.Position):Resized(d.boost*1.5) 
        end
    end

    if npc.StateFrame > 10 then
        d.state = "chase"
    end

    if d.state == "chase" then
        d.moveval = Vector.Zero
        if (enemydir > 135 and enemydir < 180) or (enemydir > 0 and enemydir < 45) then
            d.moveval = d.moveval + Vector(0, -1 * d.accelerateaway)
        end
        if (enemydir > -180 and enemydir < -135) or (enemydir < 0 and enemydir > -45) then
            d.moveval = d.moveval + Vector(0, d.accelerateaway)
        end
        if (enemydir < -90 and enemydir > -135) or (enemydir > 90 and enemydir < 135) then
            d.moveval = d.moveval + Vector(-1 * d.accelerateaway, 0)
        end
        if (enemydir < -45 and enemydir > -90) or (enemydir > 45 and enemydir < 90) then
            d.moveval = d.moveval + Vector(d.accelerateaway, 0)
        end
        targetvelocity = (targetpos + d.moveval - npc.Position):Resized(d.boost)
        if d.accelerateaway > 0 then
            d.accelerateaway = d.accelerateaway - d.accelerateaway/20
        end

    end

    if mod:isScare(npc) or d.state == "dashout" then
        npc.Velocity = mod:Lerp(npc.Velocity, othertargetvelocity, d.boost/5)
    else
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.boost/5)
    end

    if d.animinit == false or not d.oldanim == d.diranim then
        d.animinit = true
        sprite:Play(d.diranim, true)
    end

        --Other bullshit
    if sprite:IsFinished() then
        d.boost = d.realboost
        local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
        creep.Scale = creep.Scale * 0.7
        creep:SetTimeout(creep.Timeout - 45)
        creep:Update()
        d.animinit = false
    end
end

function mod.FloaterTearUpdate(tear)
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        local d = v:GetData()
        if v.Type == Isaac.GetEntityTypeByName("Floater") and v.Variant == Isaac.GetEntityVariantByName("Floater") and v.SubType == Isaac.GetEntitySubTypeByName("Floater") then
            local target = v:ToNPC():GetPlayerTarget()
            if math.abs(((target.Position - tear.Position):GetAngleDegrees() - (target.Position - v.Position):GetAngleDegrees())) < 20 and tear.Position:Distance(v.Position) < 100 and not tear:IsDead() and d.state ~= "avoid" then
                if v:ToNPC().StateFrame > 50 then
                    v:ToNPC().StateFrame = 0
                    d.state = "dashout"
                end
                d.accelerateaway = d.dashper
            end
        end
    end
end