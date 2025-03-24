local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Woodhead.Var then
        mod:WoodheadAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Woodhead.ID)

function mod:WoodheadAI(npc, sprite, d)

    if not d.init then
        sprite:PlayOverlay("Head")
        d.init = true
    end

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local path = npc.Pathfinder
    local teartab = {}

    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == 2 then
            table.insert(teartab, v)
        end
    end

    local closesttear
    local initdis = 10^10
    for k, v in ipairs(teartab) do
        local dis = npc.Position:Distance(v.Position)
        if dis < initdis then
            closesttear = v
        end
    end

    if closesttear then
        path:EvadeTarget(closesttear.Position)
    end


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
    npc:MultiplyFriction(0.8)

    path:EvadeTarget(targetpos)


    if npc.Velocity:Length() > 0.2 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
        sprite:PlayOverlay("Head")
    else
        sprite:SetFrame("WalkHori", 0)
    end

end

