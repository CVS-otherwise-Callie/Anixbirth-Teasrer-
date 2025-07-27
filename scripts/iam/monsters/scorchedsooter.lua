local mod = FHAC
local game = Game()
local rng = RNG()

local scorsooStats = {
    randomIdle = math.random(1, 5),
    realboost = math.random(5, 15)/10,
    floateroffset = math.random(-5, 10),
    dashper = 120, -- change this to however bad you want it to be! I like the 100 range, personally.
    state = "chase",
    accelerateaway = 0,
    boost = math.random(5, 10)/10
}

local function FindClosestTear(npc)
    local dist = 999999999
    local tr
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == 2 then
            if ent.Position:Distance(npc.Position) < dist then
                tr = ent
                dist = ent.Position:Distance(npc.Position)
            end
        end
    end
    return tr
end

function mod:ScorchedSooterAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()

    if FindClosestTear(npc) ~= nil then
        d.tearTarg = FindClosestTear(npc)
        d.accelerateaway = 300
    else
        d.tearTarg = nil
        d.accelerateaway = 0   
    end

    if not d.init then
        for name, stat in pairs(scorsooStats) do
            d[name] = d[name] or stat
        end
        npc.StateFrame = 50
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        d.init = true
    else

        npc.StateFrame = npc.StateFrame + 1
    end

    if target.Position.X < npc.Position.X then --future me pls don't fuck this up
        sprite.FlipX = false
    else
        sprite.FlipX = true
    end

    if sprite:IsFinished("Idle") or sprite:IsFinished("Idle2") then
        if d.randomIdle == 1 then
            mod:spritePlay(sprite, "Idle2")
            d.randomIdle = 2
        else
            mod:spritePlay(sprite, "Idle")
            d.randomIdle = math.random(1, 5)
        end
    end

    if npc.StateFrame > 5 + d.floateroffset then --this adds a scent of organicness lmao
        d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
        d.floateroffset = math.random(-5, 10)
        npc.StateFrame = 0
    end

    d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (d.targetpos - npc.Position):GetAngleDegrees()
    local targetvelocity = Vector.Zero
    local othertargetvelocity = Vector.Zero

    if d.tearTarg or mod:isScare(npc) then
        d.moveval = Vector.Zero

        local v = d.tearTarg.Velocity:GetAngleDegrees()

        if ((enemydir > 135 and enemydir < 180) or (enemydir > 0 and enemydir < 45)) and ((v > -180 and v < -135) or (v < 0 and v > -45)) then
            d.moveval = Vector(0, -1 * d.accelerateaway)
        elseif ((enemydir > -180 and enemydir < -135) or (enemydir < 0 and enemydir > -45)) and ((v > 135 and v < 180) or (v > 0 and v < 45)) then
            d.moveval = Vector(0, d.accelerateaway)
        elseif ((enemydir < -90 and enemydir > -135) or (enemydir > 90 and enemydir < 135)) and ((v < -45 and v > -90) or (v > 45 and v < 90)) then
            d.moveval = Vector(1 * d.accelerateaway, 0)
        elseif ((enemydir < -45 and enemydir > -90) or (enemydir > 45 and enemydir < 90)) and ((v < -90 and v > -135) or (v > 90 and v < 135)) then
            d.moveval = Vector(-1*d.accelerateaway, 0)
        end

        if not mod:isScare(npc) then
            othertargetvelocity = (d.targetpos + d.moveval - npc.Position):Resized(d.boost*3)
        else
            othertargetvelocity = (d.targetpos:Rotated(180) + d.moveval - npc.Position):Resized(d.boost*3) 
        end

    else
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


    if mod:isScare(npc) or d.tearTarg then
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

