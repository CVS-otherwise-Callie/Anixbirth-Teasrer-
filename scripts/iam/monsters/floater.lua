local mod = FHAC
local game = Game()
local rng = RNG()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Floater.Var then
        mod:FloaterAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
    end
end, mod.Monsters.Floater.ID)

function mod:FloaterMovementAI(npc, sprite, d)
        local target = npc:GetPlayerTarget()
    if npc.StateFrame > 5 + d.floateroffset then --this adds a scent of organicness lmao
        d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
        d.floateroffset = math.random(-5, 10)
        npc.StateFrame = 0
    end
    d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (d.targetpos - npc.Position):GetAngleDegrees()
    local targetvelocity = Vector.Zero
    local othertargetvelocity = Vector.Zero

    if d.tearTarg and not d.tearTarg:IsDead() then
        d.state = "dashout"
    elseif not d.tearTarg or d.tearTarg:IsDead() then
        d.state = "chase"
    end

    if d.state == "dashout" then
        d.moveval = Vector.Zero

        if (enemydir > 135 and enemydir < 180) or (enemydir > 0 and enemydir < 45) then
            d.moveval = Vector(0, -1 * d.accelerateaway)
        end
        if (enemydir > -180 and enemydir < -135) or (enemydir < 0 and enemydir > -45) then
            d.moveval = Vector(0, d.accelerateaway)
        end
        if (enemydir < -90 and enemydir > -135) or (enemydir > 90 and enemydir < 135) then
            d.moveval = Vector(-1 * d.accelerateaway, 0)
        end
        if (enemydir < -45 and enemydir > -90) or (enemydir > 45 and enemydir < 90) then
            d.moveval = Vector(d.accelerateaway, 0)
        end

        if not mod:isScare(npc) then
            othertargetvelocity = (d.targetpos + d.moveval - npc.Position):Resized(d.boost*3)
        else
            othertargetvelocity = (d.targetpos:Rotated(180) + d.moveval - npc.Position):Resized(d.boost*3) 
        end
    elseif d.state == "chase" then
        d.moveval = Vector.Zero
        if (enemydir > 135 and enemydir < 180) or (enemydir > 0 and enemydir < 45) then
            d.moveval = d.moveval + Vector(0, -1 * d.accelerateaway)
        end
        if (enemydir > -180 and enemydir < -135) or (enemydir < 0 and enemydir > -45) then
            d.moveval = d.moveval + Vector(0, d.accelerateaway)
        end
        if (enemydir < -90 and enemydir > -135) or (enemydir > 90 and enemydir < 135) then
            d.moveval = d.moveval + Vector(d.accelerateaway, 0)
        end
        if (enemydir < -45 and enemydir > -90) or (enemydir > 45 and enemydir < 90) then
            d.moveval = d.moveval + Vector(-1* d.accelerateaway, 0)
        end
        targetvelocity = (d.targetpos + d.moveval - npc.Position):Resized(d.boost*3)
        if d.accelerateaway > 0 then
            d.accelerateaway = d.accelerateaway - d.accelerateaway/20
        end
    end

    if mod:isScare(npc) or d.state == "dashout" then
        npc.Velocity = mod:Lerp(npc.Velocity, othertargetvelocity, d.boost/5)
    else
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.boost/5)
    end

    mod:CatheryPathFinding(npc, targetvelocity, {
        Speed = 10,
        Accel = 0.02,
        GiveUp = true
    })
end

function mod:FloaterSpriteAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()

    local enemydir = (target.Position - npc.Position):Rotated(90 + 11.25):GetAngleDegrees()

    local spritenumber = (math.floor((enemydir)/22.5))+9

    if sprite:GetFrame() == 16 then
        sprite:SetFrame(0)
    end

    sprite:SetAnimation("Angle"..spritenumber, false)
    sprite:SetFrame(sprite:GetFrame()+1)

            --Other bullshit
    if sprite:IsFinished() then
        d.boost = d.realboost
        d.animinit = false
    end
end

function mod:FloaterAI(npc, sprite, d, r)
    if not d.init then
        d.realboost = math.random(5, 15)/10
        d.floateroffset = math.random(-5, 10)
        npc.StateFrame = 50
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        d.dashper = 120 -- change this to however bad you want it to be! I like the 100 range, personally.
        d.state = "chase"
        d.accelerateaway = 0
        d.boost = math.random(5, 10)/10
        d.init = true
    else
        d.boost = math.random(8, 13)/8
        d.oldanim = d.diranim
        npc.StateFrame = npc.StateFrame + 1
    end

    mod:FloaterMovementAI(npc, sprite, d)

    mod:FloaterSpriteAI(npc, sprite, d)

    if sprite:GetFrame() == 1 then
        local creep
        if game:GetLevel():GetCurrentRoomDesc().Data.StageID == 27 then
            creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
            creep:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_waterpool.png") --hehe thanks ff
        elseif game:GetLevel():GetCurrentRoomDesc().Data.StageID == 28 then
            creep = Isaac.Spawn(1000, 56,  0, npc.Position, Vector(0, 0), npc):ToEffect()
        else
            creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
        end
        creep.Scale = creep.Scale * 0.7
        creep:SetTimeout(creep.Timeout - 70)
        creep:Update()
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