local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    state = "hide"
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

local function CheckForExtraLilFlash(fire)
    local posents = Isaac.FindInRadius(fire.Position, 10, EntityPartition.ENEMY)
    for i = 1, #posents do
        local entity = posents[i]
        if entity.Type == 161 and entity.Variant == mod.Monsters.LilFlash.Var then
            return true
        end
    end
    return false
end

local function CheckFireBoundaries(fire)
    local room = game:GetRoom()
    for i = 1, 4 do
        local grid = room:GetGridEntityFromPos((fire.Position + Vector(10, 0):Rotated((i-1)*90)))
        if grid or not grid then
            return true
        end
    end
    return false
end

local function getLocalFire(lilflash)
    for _, npc in ipairs(Isaac.GetRoomEntities()) do

        -- -to check if the fire is freaking out- im going to fix this AFTER animating

        if npc.Type == 33 then

            if not CheckForExtraLilFlash(npc) and npc:ToNPC().State == 8 and CheckFireBoundaries(npc) then
                npc:GetData().isInhabitedByLilFlash = lilflash
                return npc
            end
        end
    end
    return false
end

function mod:LilFlashAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
	local path = npc.Pathfinder
    local params = ProjectileParams()

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        npc.DepthOffset = 1000
        npc.SplatColor = mod.Color.FireJuicy
        npc.GridCollisionClass = 5
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "hide" then

        d.fire = d.fire or getLocalFire(npc)

        d.transferInit = false

        mod:MakeInvulnerable(npc)

        if not d.fire then

            d.state = "scared"

            local position = mod:freeGrid(npc, false, 300, 0)

            npc.Position = npc.Position + Vector(10, 0):Rotated((npc.Position - position):GetAngleDegrees())

            mod:spritePlay(sprite, "ScaredAppear")
        else
            if not d.fire or d.fire:ToNPC().State == 3 then
                d.fire:GetData().isInhabitedByLilFlash = nil
                local fire = getLocalFire(npc)
                if not fire then
                    mod:spritePlay(sprite, "NoBodyShocked")
                else
                    d.fire = fire
                    d.state = "transfer"
                end
            else
                if not d.hasAppearFire and (sprite:IsFinished("FireBodyDisappear") or sprite:IsFinished("TransferDisappear")) then
                    mod:spritePlay(sprite, "FireAppear")
                else
                    if npc.StateFrame > 20 then
                        mod:spritePlay(sprite, "NoBodyShoot")
                    else
                        mod:spritePlay(sprite, "NoBodyIdle")
                    end
                end

                npc.Position = d.fire.Position
            end
        end
    elseif d.state == "scared" then

        mod:MakeVulnerable(npc)

        if targetpos:Distance(npc.Position) < 100 or (FindClosestTear(npc) and FindClosestTear(npc).Position:Distance(npc.Position) < 100) then

            mod:spritePlay(sprite, "ScaredBody")

            local point = npc.Position + Vector(50, 0):Rotated((npc.Position - targetpos):GetAngleDegrees())

            if mod:isScareOrConfuse(npc) then
                local targetvelocity = (point - npc.Position):Resized(-7)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.7)
            else
                local targetvelocity = (point - npc.Position):Resized(7)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.7)
            end

        else

            mod:spritePlay(sprite, "NormalBody")

            if npc.FrameCount % 2 == 0 then
                path:MoveRandomly(false)
            end
            npc.Velocity = npc.Velocity:Resized(4)
            npc.Friction = 0.6

        end

        local fire = getLocalFire(npc)

        if fire then
            d.fire = fire
            d.state = "hide"
            
            mod:spritePlay(sprite, "FireBodyDisappear")
        end
    else

        mod:MakeVulnerable(npc)
        npc.GridCollisionClass = 5

        d.hasAppearFire = false

        if (math.abs(mod:GetTrueAngle((targetpos - npc.Position):GetAngleDegrees())) - math.abs(mod:GetTrueAngle((d.fire.Position - npc.Position):GetAngleDegrees()))) > 50 then
            d.pastFirstPos = true
        end

        if d.pastFirstPos then
            local targ = d.fire
            local targetvelocity = (targ.Position - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.7)
        else
            local targ = (targetpos + Vector(50, 0):Rotated((npc.Position - d.fire.Position):GetAngleDegrees() + 90))
            local targetvelocity = (targ - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.7)

            if npc.Position:Distance(targ) < 20 then
                d.pastFirstPos = true
            end
        end

        if not d.transferInit then
            mod:spritePlay(sprite, "TransfeAppear")
        elseif npc.Position:Distance(d.fire.Position) < 10 then
            mod:spritePlay(sprite, "TransferDisappear")
            print("cool")
        else
            mod:spritePlay(sprite, "Transfer")
        end
    end

    if sprite:IsFinished("Appear") then
        d.state = "hide"
        mod:spritePlay(sprite, "FireBodyDisappear")
    elseif sprite:IsFinished("NoBodyShocked") then
        d.fire = nil
    elseif sprite:IsFinished("NoBodyShoot") then
        npc.StateFrame = 0
    elseif sprite:IsFinished("FireAppear") then
        d.hasAppearFire = true
    elseif sprite:IsFinished("TransfeAppear") then
        d.transferInit = true
    elseif sprite:IsFinished("TransferDisappear") then
        d.state = "hide"
    end

    if sprite:IsEventTriggered("shoot") then
        npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(7), 0, params)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flags, guy)
    if npc.Type == 161 and npc.Variant == mod.Monsters.LilFlash.Var and flags == flags | DamageFlag.DAMAGE_FIRE then
        return false
    end
end)
