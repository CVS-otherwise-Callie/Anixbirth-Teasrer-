local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Hangeslip.Var then
        mod:HangesAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Hangeslip.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == 0 and npc:GetData().Dried then
        mod:HangedriedRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Hangeslip.ID)

local function FindDried(npc)
    local ta = {}
    local dried = Isaac.GetRoomEntities() --since dried are unlisted entities
    for k, v in ipairs(dried) do
        if v.Type == mod.Monsters.Dried.ID and v.Variant == mod.Monsters.Dried.Var and not (v.Parent and v.Parent.Variant == mod.Monsters.Hangeslip.Var and v.Parent ~= npc) then
            table.insert(ta, v)
        end
    end
    if #ta ==0 then
        return nil
    else
        return ta[math.random(#ta)]
    end
end

function mod:HangesAI(npc, sprite, d)

    if not d.oginit then
        sprite:SetOverlayFrame("HangeHeadDown", 1)

        d.Dried = FindDried(npc)

        d.oginit = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.Dried then
        d.Dried.Parent = npc
    end

    
    if d.Dried then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        d.movable = true
        npc.SpriteOffset = Vector(0,-54) + d.Dried.SpriteOffset
        sprite:RemoveOverlay()
        npc.Position = d.Dried.Position
        mod:HangedriedAI(npc, npc:GetSprite(), npc:GetData())
    elseif npc.StateFrame > 1 and not d.Dried then
        if npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub then
            mod:HangeslipAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 1 then
            mod:HangejumpAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 2 then
            mod:HangethrowAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType == mod.Monsters.Hangeslip.Sub + 3 then
            mod:HangekickAI(npc, npc:GetSprite(), npc:GetData())
        end
    end
end

function mod:HangedriedAI(npc, sprite, d)

    if not d.init then
        d.backDriedBody = d.backDriedBody or Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BlankEffect.Var, 0, npc.Position, npc.Velocity, nil)
        d.backDriedBody.SpriteOffset = Vector(0,-54) + d.Dried.SpriteOffset
        d.backDriedBody.DepthOffset = -50

        d.BackDriedFace = d.BackDriedFace or Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BlankEffect.Var, 0, npc.Position, npc.Velocity, nil)
        d.BackDriedFace.SpriteOffset = Vector(0,-54) + d.Dried.SpriteOffset
        d.BackDriedFace.DepthOffset = -50
    end

    if d.backDriedBody then
        d.backDriedBody.Position = npc.Position
    end
    if d.BackDriedFace then
        d.BackDriedFace.Position = npc.Position
    end

    mod:MakeInvulnerable(npc)
    npc.DepthOffset = 5

end

function mod:HangedriedRenderAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local screenpos = room:WorldToScreenPosition(npc.Position)


    if d.backDriedBody then
        local spr = d.backDriedBody:GetSprite()

        spr:Load("gfx/monsters/hanges/hanges.anm2", true)
        spr:SetFrame("HangeRopeBehind", 0)
    end

    if d.BackDriedFace then
        local spr = d.BackDriedFace:GetSprite()

        spr:Load("gfx/monsters/hanges/hanges.anm2", true)
        spr:SetFrame("HangeRopeFace", 0)
    end

    sprite:Play("HangeRopeInFront")

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
            npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 2, false, 1)
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
end