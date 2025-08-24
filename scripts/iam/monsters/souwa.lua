-- UNFINISHED. USE REPENTOGON NULL ANIMATIONS!!!


local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    chosenRock = nil,
    state = "appear",
    rockHP = 0,
    rockSprites = {filepath = "", spritesheet = "", anim = "", frame = 0},
    rockAnim = nil,
    isPlayingRockOver = false,
    rockRaiseCap = 32,
    moveAng = 0,
    rockSpriteOffset = 0
}
 
--thanks meep
local function angleDiff(a, b)
    local diff = (b - a + 180) % 360 - 180
    return diff
end

local function lerpAngle(a, b, t)
    local diff = angleDiff(a, b)
    return a + diff * t
end

local function angleToVector(angle)
    return math.cos(angle), math.sin(angle)
end
--done thanking meep

local rockHPs = {
    [GridEntityType.GRID_ROCK] = 20,
    [GridEntityType.GRID_ROCKT] = 23,
    [GridEntityType.GRID_ROCK_BOMB] = 18,
    [GridEntityType.GRID_ROCK_ALT] = 20,
    [GridEntityType.GRID_LOCK] = 30,
    [GridEntityType.GRID_ROCK_SS] = 26,
    [GridEntityType.GRID_ROCK_SPIKED] = 20,
    [GridEntityType.GRID_ROCK_ALT2] = 21,
    [GridEntityType.GRID_ROCK_GOLD] = 15
}

local function FindSuitableRock(path, rng)
    local rockTab = {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_BOMB, 
    GridEntityType.GRID_ROCK_ALT, GridEntityType.GRID_LOCK, GridEntityType.GRID_ROCK_SS,
    GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2, GridEntityType.GRID_ROCK_GOLD}
    local choseTab = {}
    local room = game:GetRoom()

	for i = 0, room:GetGridSize() do
        local grid = room:GetGridEntity(i)

        if grid and mod:CheckTableContents(rockTab, room:GetGridEntity(i):GetType()) 
         and grid.CollisionClass ~= 0 then
            table.insert(choseTab, grid)
        end
    end

    local answer

    if #choseTab == 0 then
        return "none"
    end

    if rng then
        answer = choseTab[rng:RandomInt(1, #choseTab)]
    else
        answer = choseTab[math.random(1, #choseTab)]
    end

    return answer

end

function mod:SouwaAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()
    rng:SetSeed(npc.InitSeed, 32)

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        npc.GridCollisionClass = 0
        d.chosenRock = FindSuitableRock(path, rng)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.SpawnerEntity and (npc.SpawnerEntity.Type == mod.Bosses.Chris.ID and npc.SpawnerEntity.Variant == mod.Bosses.Chris.Var) then
        d.state = "chaseLikeGhost"
    end

    if d.state == "appear" then
        npc.EntityCollisionClass = 0
    elseif d.state == "findrock" then

        d.rockSpriteOffset = 0

        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        if not d.chosenRock or d.chosenRock.CollisionClass == 0 then
            d.chosenRock = FindSuitableRock(path, rng)
        end

        if d.chosenRock == "none" then
            d.state = "wander"
            npc.Velocity = Vector.Zero
            return
        end

        d.rockBreakinit = false

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        local dirVec = (d.chosenRock.Position - npc.Position):Normalized()
        local targetAngle = math.deg(math.atan(dirVec.Y, dirVec.X))

        local ang = mod:Lerp(d.moveAng, targetAngle, 0.05)

        targetpos = mod:confusePos(npc, d.chosenRock.Position, 5, nil, nil)

        if npc.Position:Distance(d.chosenRock.Position) < 30 and not sprite:IsPlaying("EnterRock") then
            local ro = d.chosenRock
            local s = ro:GetSprite()
            d.rockHP = rockHPs[ro:GetType()]
            d.rockSprites.filepath = s:GetFilename()
            d.rockSprites.anim = s:GetAnimation()
            d.rockSprites.spritesheet = s:GetLayer(0):GetSpritesheetPath()
            d.rockSprites.frame = s:GetFrame()

            mod:spritePlay(sprite, "EnterRock")

            npc:MultiplyFriction(0.8)
        else
            if mod:isScareOrConfuse(npc) then
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
            else
                d.moveAng = lerpAngle(d.moveAng, targetAngle + 90, 0.5)
                local vx, vy = angleToVector(math.rad(d.moveAng - 90))
                npc.Velocity = mod:Lerp(npc.Velocity, Vector(vx, vy) * Vector(7, 7), 0.07)
            end
        end

        if npc.Velocity:Length() < 1 then
            mod:spritePlay(sprite, "Idle")
        else
            mod:spritePlay(sprite, "Move" .. mod:GetMoveString(npc.Velocity, true))
        end
    elseif d.state == "rockchase" then

        npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        end

    elseif d.state == "rockbreakOut" then

        d.isPlayingRockOver = false

        if not d.rockBreakinit then
            d.rockAnim = nil
            local grid = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_GRID, 0, npc.Position, Vector.Zero, npc)
            local gsprite = grid:GetSprite()

            gsprite:Load(d.rockSprites.filepath, true)
            gsprite:ReplaceSpritesheet(0, d.rockSprites.spritesheet)
            gsprite:LoadGraphics()            
            gsprite:Play(d.rockSprites.anim)
            gsprite:SetFrame(d.rockSprites.frame)

            npc:MultiplyFriction(0.7)

            mod:spritePlay(sprite, "Shock")

            npc.StateFrame = 0
            d.rockBreakinit = true
        end

        if npc.StateFrame > 20 then
            mod:spritePlay(sprite, "HeadShake")
            npc:MultiplyFriction(0.5)
        end

    elseif d.state == "wander" then
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

        local chosenRock = FindSuitableRock(path, rng)
        if chosenRock then
            d.chosenRock = chosenRock
        end
    end

    if d.isPlayingRockOver and d.chosenRock and d.chosenRock ~= "none" then
        d.chosenRock:Destroy()
    end

    if sprite:IsFinished("Appear") or sprite:IsFinished("HeadShake") then
        d.state = "findrock"
    elseif sprite:IsFinished("EnterRock") then
        mod:spritePlay(sprite, "RockUp")
        d.chosenRock:Destroy()
    elseif sprite:IsFinished("RockUp") then
        mod:spritePlay(sprite, "RockChase")
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type ~= 161 or npc.Variant ~= mod.Monsters.Souwa.Var then return end
    local d = npc:GetData()

    print(d.rockHP, d.state, npc.HitPoints)

    if d.rockHP > 0 then
        d.rockHP = d.rockHP - damage
        return false
    elseif d.state == "rockchase" then
        d.state = "rockbreakOut"
        return false
    end
end)

