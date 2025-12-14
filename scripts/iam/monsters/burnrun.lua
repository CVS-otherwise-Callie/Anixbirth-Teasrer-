local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Burnrun.Var then
        mod:BurnrunAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Burnrun.ID)

function mod:BurnrunAI(npc, sprite, d)

    local path = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    local function GetNearestTarget(initseedblacklist)
        local far = 9999
        local ent
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if (v.Position:Distance(npc.Position) < far and v:IsActiveEnemy() and v:IsVulnerableEnemy() and v.InitSeed ~= npc.InitSeed) and (not initseedblacklist or (initseedblacklist and initseedblacklist~=v.InitSeed)) then
                far = v.Position:Distance(npc.Position)
                ent = v
            end
        end
        return ent
    end

    if not d.init then
        d.target = GetNearestTarget()
        d.CoolDown = npc.StateFrame + math.random(50, 70) - 6
        d.wait = math.random(20, 40) - 6
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if not d.target or not d.target:Exists() or d.target:IsDead() then
        d.target = GetNearestTarget()
        npc.StateFrame = 0
    end

    if d.target then

        if npc.StateFrame < 50 then
            if npc.StateFrame <= d.CoolDown then
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
            end
            if npc.StateFrame > d.CoolDown+d.wait then
                d.CoolDown = npc.StateFrame + math.random(50, 70) - 6
                d.wait = math.random(20, 40) - 6
            end
            npc:MultiplyFriction(0.85)
        else
            local newpos = d.target.Position

            if mod:isScare(npc) then
                local targetvelocity = (newpos - npc.Position):Resized(-8)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            elseif Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) then
                local targetvelocity = (newpos - npc.Position):Resized(8)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(newpos, 0.4, 1, true)
            end

            if npc.Position:Distance(d.target.Position) < 45 then
                d.target = GetNearestTarget(d.target.InitSeed)
                npc.StateFrame = 0
            end
        end
    end

    if npc.Velocity.X > 0 then
        sprite.FlipX = false
    else
        sprite.FlipX = true
    end

    mod:spritePlay(sprite, "Run")

end

