local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    state = "wander",
    shootCooldown = 20,
    wanderTimer = 50,
    oldTargPos = nil
}

local function GetClosestHotPotato(position)
    local hotpotato
    local dist = 9999999

    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == mod.Monsters.HotPotato.ID and v.Variant == mod.Monsters.HotPotato.Var then
            if v.Position:Distance(position) < dist then
                dist = v.Position:Distance(position)
                hotpotato = v
            end
        end
    end
    return hotpotato
end

local function GetClosestAxisPosToPos(position, targetPosition)
    local room = game:GetRoom()
    local closest
    local closestpos = 9999999999
    for i = 1, 4 do
        local hitWall = false
        local num = 0
        while not hitWall do
            num = num + 1
            local pos = position + Vector(5*num, 0):Rotated(i*90)
            --DebugRenderer.Get():Circle(pos, 10)

            if pos:Distance(targetPosition) < closestpos then
                closestpos = pos:Distance(targetPosition)
                closest = pos
            end

            if room:GetGridCollisionAtPos(pos) ~= 0 then
                hitWall = true
            end
        end
    end
    return closest
end

function mod:FurnaceAI(npc, sprite, d)

    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()

    if GetClosestHotPotato(npc.Position) then
        target = GetClosestHotPotato(npc.Position)
    end

    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "wander" then
        if npc.StateFrame > d.wanderTimer then
            d.state = "chase"
        else
            if mod:isCharm(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
                else
                    path:FindGridPath(targetpos, 0.85, 1, true)
                end
            elseif mod:isScare(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                else
                    path:FindGridPath(targetpos, -0.85, 1, true)
                end
            else
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:MoveRandomly(false)
            end
            npc:MultiplyFriction(0.65+(0.016))

            mod:spritePlay(sprite, "Walk" .. mod:GetMoveString(npc.Velocity, false, false))
        end
    elseif d.state == "chase" then
        local pos = GetClosestAxisPosToPos(targetpos, npc.Position)
        
        if mod:isScare(npc) then
            local targetvelocity = (pos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,pos,0,1,false,false) then
            local targetvelocity = (pos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(pos, 1.3, 1, true)
        end

        mod:spritePlay(sprite, "Walk" .. mod:GetMoveString(npc.Velocity, false, false))

        if math.abs(npc.Position.X - targetpos.X) < 20 or math.abs(npc.Position.Y - targetpos.Y) < 20 then
            d.state = "shoot"
            d.oldTargPos = targetpos
        end
    elseif d.state == "shoot" then
        npc:MultiplyFriction(0.5)
        local dir
    	if math.abs(target.Position.X - npc.Position.X) >= math.abs(target.Position.Y - npc.Position.Y)*1.2 then
            if (target.Position.X - npc.Position.X) > 0 then
                dir = "Right"
            else
                dir = "Left"
            end
        else
            if (target.Position.Y - npc.Position.Y) > 0 then
                dir = "Down"
            else
                dir = "Up"
            end
        end
        mod:spritePlay(sprite, "Shoot" .. dir)
    end

    if sprite:IsEventTriggered("shoot") then
        for i = 1, 3 do
            mod:ShootFire(npc.Position, (targetpos - npc.Position):Resized(4 + (i*5)), {scale = 1.3 - (i*0.2), timer = 150 - (i*3), hp = 2, radius = 22 - i})
        end
    end

    if string.find(sprite:GetAnimation(), "Shoot") and sprite:IsFinished() then
        npc.StateFrame = 0
        d.state = "wander"
    end

end

