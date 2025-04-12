local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Trilo.Var then
        mod:TriloAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Trilo.ID)

function mod:TriloAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local num = 7
    local path = npc.Pathfinder
    local params = ProjectileParams()

    if not d.init then
        d.heatLevel = 1
        d.state = "Chase"
        sprite:SetOverlayAnimation("Head" .. d.heatLevel)
        d.init = true
    end

    if d.state == "Chase" then

        if sprite:IsOverlayFinished("Head"  .. d.heatLevel) then
            sprite:PlayOverlay("Head"  .. d.heatLevel, true)
        end

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-3 - d.heatLevel)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        elseif path:HasPathToPos(targetpos) then
            local targetvelocity = (targetpos - npc.Position):Resized(3 + d.heatLevel)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        else
            path:FindGridPath(targetpos, 0.7, 1, true)
        end
    elseif d.state == "Blowup" then
        npc:MultiplyFriction(0.8)
        sprite:PlayOverlay("HeadTransition".. (d.heatLevel-1))
    end

    if sprite:IsOverlayFinished("HeadTransition".. (d.heatLevel-1)) then
        d.state = "Chase"
    end

    if npc.Velocity:Length() > 0.5 then
        npc:AnimWalkFrame("WalkHori"  .. d.heatLevel,"WalkVert"  .. d.heatLevel,0)
    else
        sprite:SetFrame("WalkHori"  .. d.heatLevel, 0)
    end

    if sprite:IsOverlayPlaying("HeadTransition4") and sprite:GetOverlayFrame() == 17 then
        Isaac.Explode(npc.Position, npc, 10)
        npc:Kill()
    end

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function (_, npc)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Trilo.Var and npc:IsDead() then
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 161 and v.Variant == mod.Monsters.Trilo.Var and not v:IsDead() then
                v:GetData().heatLevel = v:GetData().heatLevel + 1
                v:GetData().state = "Blowup"
            end
        end
    end
end)

