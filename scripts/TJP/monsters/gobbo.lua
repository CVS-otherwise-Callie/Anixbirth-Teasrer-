local mod = FHAC
local game = Game()
local rng = RNG()


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Gobbo.Var then
        mod:GobboAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Gobbo.ID)

function mod:GobboAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()
    print(npc.EntityCollisionClass)
    print(npc.GridCollisionClass)
    if not d.init then
        d.state = "chase"

        local sho = Isaac.Spawn(161, 27, 0, npc.Position, npc.Velocity, npc):ToNPC()
        sho.Parent = npc
        d.init = true
    end
    
    if d.state == "chase" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        else
            path:FindGridPath(targetpos, 0.7, 1, true)
        end
    end

    if npc.Velocity:Length() > 1.3 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0.)
    else
        if sprite:GetOverlayAnimation() == "Head" then sprite:SetOverlayFrame("Head", 19) end
        sprite:SetFrame("WalkHori", 0)
    end

    sprite:PlayOverlay("Head", false)

    if sprite:IsOverlayFinished("Head") then
        sprite:SetOverlayFrame("Head", 19) --whatever the last frame of the animation is
    end

    sprite:Update()
end

