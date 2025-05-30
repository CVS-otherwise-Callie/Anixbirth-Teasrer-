local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Hangeslip.Var then
        mod:HangesAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Hangeslip.ID)

function mod:HangesAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 7
    if not d.init then
        sprite:SetOverlayFrame("HangeHeadDown", 1)
        d.init = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > 1 and not npc.Parent then
        if npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub then
            mod:HangeslipAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 1 then
            mod:HangejumpAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 2 then
            mod:HangethrowAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 3 then
            mod:HangekickAI(npc, npc:GetSprite(), npc:GetData())
        end
    elseif npc.StateFrame > 1 and npc.Parent then
        d.movable = true
        npc.SpriteOffset = Vector(0,-54) + npc.Parent.SpriteOffset
        npc.DepthOffset = 5
        sprite:RemoveOverlay()
        mod:HangedriedAI(npc, npc:GetSprite(), npc:GetData())
    end
end

function mod:HangedriedAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local screenpos = room:WorldToScreenPosition(npc.Position)

    sprite:SetFrame("HangeRopeBehind", 0)
    sprite:Render(screenpos)

    sprite:SetFrame("HangeRopeFace", 0)
    sprite:Render(screenpos)

    sprite:SetFrame("HangeRopeInFront", 0)
    sprite:Render(screenpos)

end

function mod:HangeslipAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 7
    if not d.init then
        d.init = true
        d.state = "reveal"
    end

    if d.state == "reveal" then
        npc.Velocity = npc.Velocity * 0.8
        mod:spriteOverlayPlay(sprite, "HangeslipReveal")
        if sprite:IsOverlayFinished() then
            d.state = "chase"
        end
    end

    if d.state == "chase" then
        if mod:isScare(npc) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
        elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
        else
            path:FindGridPath(playerpos, 0.8, 1, true)
        end

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end
    end
end

function mod:HangejumpAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.init = true
    end

    mod:spriteOverlayPlay(sprite, "HangejumpReveal")
    print("JUUUUMP")
end

function mod:HangethrowAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.init = true
    end

    mod:spriteOverlayPlay(sprite, "HangethrowReveal")
    print("THROOOOW")
end

function mod:HangekickAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.init = true
    end

    mod:spriteOverlayPlay(sprite, "HangekickReveal")
    print("KIIIIICK")
end