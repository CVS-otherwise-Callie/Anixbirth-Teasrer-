local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Hangeslip.Var and npc.Type == mod.Monsters.Hangeslip.ID then
        mod:HangesAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Hangeslip.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.Hangeslip.Var and npc:GetData().Dried then
        if not npc:GetData().hangedriedanim then
            npc:GetData().hangedriedanim = "Idle"
            npc:GetData().hangedriedframe = 0
        end
        mod:HangedriedRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Hangeslip.ID)

local function FindDried(npc, range)
    local ta = {}
    local dried = Isaac.GetRoomEntities() --since dried are unlisted entities
    for k, v in ipairs(dried) do
        if v.Type == mod.Monsters.Dried.ID and v.Variant == mod.Monsters.Dried.Var and not (v.Parent and v.Parent.Variant == mod.Monsters.Hangeslip.Var and v.Parent ~= npc)  and npc.Position:Distance(v.Position) < range then
            table.insert(ta, v)
        end
    end
    if #ta ==0 then
        return nil
    else
        return ta[math.random(#ta)]
    end
end

local function FindAvailableDetachedDried(npc)
    local path = npc.Pathfinder
    local ta = {}
    local dried = Isaac.GetRoomEntities()
    local dist = 9999999
	local ent
    local pos = npc.Position
    for k, v in ipairs(dried) do
        if v.Type == mod.Monsters.DetachedDried.ID and v.Variant == mod.Monsters.DetachedDried.Var and not v.Child and v.SpriteOffset.Y == 0 and path:HasPathToPos(v.Position, false) and v:GetData().state ~= "jumpedon" then --if its a grounded, not jumped on dried without a child and can be walked to
            table.insert(ta, v)
        end
    end
    for k, v in ipairs(ta) do

		if v.Position:Distance(pos) < dist and v:IsActiveEnemy() and not v:IsDead() and v.Position:Distance(pos) ~= 0 then
			ent = v
			dist = v.Position:Distance(pos)
		end
	end
    return ent
end

function mod:HangesAI(npc, sprite, d)

    if not d.oginit then
        sprite:SetOverlayFrame("HangeHeadDown", 1)

        d.Dried = FindDried(npc, 60)

        d.oginit = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.Dried == nil and npc.StateFrame < 5 then
        d.Dried = d.Dried or FindDried(npc, 60)
    else
        if d.Dried then
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            d.movable = true
            if d.hangedriedanim ~= "Drop" then
                npc.SpriteOffset = Vector(0,-54) + d.Dried.SpriteOffset
                npc.Position = d.Dried.Position
            end
            sprite:RemoveOverlay()
            mod:HangedriedAI(npc, npc:GetSprite(), npc:GetData())
        elseif npc.StateFrame > 1 and not d.Dried then
            if d.hasbeenhangedried then
                sprite:SetFrame("WalkVert", 0)
                sprite:SetOverlayFrame("HangeropeReveal", 0)
                d.hasbeenhangedried = nil
            end
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

    if d.Dried then
        d.Dried.Parent = npc
    end

end

function mod:HangedriedAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)

    if not d.init then
        d.hasbeenhangedried = true
        d.zvel = 0
        d.hangedriedanim = "Idle"
        d.hangedriedframe = 0
        d.init = true
    end


    mod:MakeInvulnerable(npc)
    if not d.gravity then
        npc.DepthOffset = 5
    end

    if (npc.StateFrame > 25 and npc.Position:Distance(playerpos) < 45 and d.hangedriedanim == "Idle") or (d.haschomped and d.hangedriedanim == "Idle") then
        d.hangedriedanim = "Chomp"
        d.haschomped = true
    end

    if d.hangedriedanim ~= "Idle" and not (d.hangedriedanim == "Drop" and d.hangedriedframe > 43 and d.airborne == true) then
        d.hangedriedframe = d.hangedriedframe + 1
    end

    if d.hangedriedanim == "Chomp" and sprite:GetFrame() == 75 then
        d.hangedriedframe = 0
        if FindDried(npc, 150) then
            d.olddried = d.Dried
            d.Dried = FindDried(npc, 150)
            d.Dried.Parent = npc
            npc.Position = d.olddried.Position
            d.hangedriedanim = "Jump"
        else
            d.hangedriedanim = "Drop"
        end
    end

    if d.hangedriedanim == "Jump" then
        if sprite:GetFrame() > 23 then
            if not d.lerppercentdried then
                d.lerppercentdried = 0
            else
                d.lerppercentdried = math.min((sprite:GetFrame()-23)/(39-23), 1)
            end
            npc.Position = mod:Lerp(d.olddried.Position, d.Dried.Position, d.lerppercentdried)
        else
            d.lerppercentdried = 0
            npc.Position = d.olddried.Position
        end
    end

    if d.hangedriedanim == "Jump" and sprite:GetFrame() == 45 then
        d.hangedriedanim = "Idle"
        npc.StateFrame = 0
        d.hangedriedframe = 0
        d.lerppercentdried = nil
    end

    if (d.gravity and npc.SpriteOffset.Y < 0) or d.zvel < 0 then
        d.airborne = true
        npc.SpriteOffset = npc.SpriteOffset + Vector(0,d.zvel)
        d.zvel = d.zvel + 0.4
    end
    if not ((d.gravity and npc.SpriteOffset.Y < 0) or d.zvel < 0) then -- this not being else is important trust me
        d.airborne = false
        if d.gravity then
            mod:MakeVulnerable(npc)
            npc.SpriteOffset = Vector.Zero
            npc.Velocity = Vector.Zero
        end
        d.zvel = 0
    end


    d.backDriedBody = d.backDriedBody or Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BlankEffect.Var, 0, npc.Position, npc.Velocity, nil)
    d.backDriedBody.SpriteOffset = npc.SpriteOffset
    if not d.gravity then
        d.backDriedBody.DepthOffset = -50
    else
        d.backDriedBody.DepthOffset = 0
    end

    d.backDriedFace = d.backDriedFace or Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BlankEffect.Var, 0, npc.Position, npc.Velocity, nil)
    d.backDriedFace.SpriteOffset = npc.SpriteOffset + (playerpos - (npc.Position + (Vector(0,-100) + d.Dried.SpriteOffset))):Resized(1.5)
    if not d.gravity then
        d.backDriedFace.DepthOffset = -50
    else
        d.backDriedFace.DepthOffset = 0
    end


    if d.backDriedBody then
        d.backDriedBody.Position = npc.Position
    end
    if d.backDriedFace then
        d.backDriedFace.Position = npc.Position
    end

    if d.hangedriedanim == "Drop" and d.hangedriedframe > 70 then
        d.backDriedBody:Remove()
        d.backDriedFace:Remove()
        sprite:SetFrame("WalkVert", 0)
        sprite:SetOverlayFrame("HangeropeReveal", 0)
        d.Dried = nil
        npc.DepthOffset = 0
        d.init = false
    end

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
        spr:SetFrame("Hangerope"..d.hangedriedanim.."Behind", d.hangedriedframe)
    end

    if d.backDriedFace then
        local spr = d.backDriedFace:GetSprite()

        spr:Load("gfx/monsters/hanges/hanges.anm2", true)
        spr:SetFrame("Hangerope"..d.hangedriedanim.."Face", d.hangedriedframe)
    end

    if sprite:IsEventTriggered("Throw") and d.Dried:GetData().state ~= "cut" then
        d.Dried:GetData().state = "cutinit"
    end

    if sprite:IsEventTriggered("Throwstart") then
        npc.Velocity = Vector(0,1)
        d.gravity = true
        d.zvel = -2
    end

    sprite:SetFrame("Hangerope"..d.hangedriedanim.."Front", d.hangedriedframe)

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

    local speed = 2

    d.Scale = npc.Scale
    if not d.init then
        d.init = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "reveal" then
        mod:spriteOverlayPlay(sprite, "HangejumpReveal")
        if sprite:IsOverlayFinished() then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 2, false, 1)
            d.state = "chase"
        end

        npc:MultiplyFriction(0.8)
    end

    if not d.detacheddried and FindAvailableDetachedDried(npc) and d.state == "chase" then
        d.detacheddried = FindAvailableDetachedDried(npc)
        d.detacheddried.Child = npc
        npc.Parent = d.detacheddried
    end

    if d.state == "chase" then

        if npc.Parent and path:HasPathToPos(npc.Parent.Position, false) then
            local childpos = npc.Parent.Position
            if room:CheckLine(npc.Position,childpos,0,1,false,false) then
                local targetvelocity = (childpos - npc.Position):Resized(speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(childpos, 0.8, 1, true)
            end
        else
            if mod:isScare(npc) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(playerpos, 0.8, 1, true)
            end
        end

        sprite:SetOverlayFrame("HangejumpReveal", 31)

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end

    end

    if d.state == "smash" then
        npc.DepthOffset = 10

        if d.detacheddried and d.lerpstart then
            npc.Position = mod:Lerp(npc.Position, d.detacheddried.Position, 0.5)
        else
            npc:MultiplyFriction(0.8)
        end
        sprite:RemoveOverlay()
        mod:spritePlay(sprite, "HangejumpJump")
        if sprite:IsFinished() then
            d.lerpstart = false
            npc.DepthOffset = 0
            d.state = "chase"
        end
    end

    if sprite:IsEventTriggered("Throwstart") then
        d.lerpstart = true
    end

    if sprite:IsEventTriggered("Throw") then
        d.lerpstart = false
        if d.detacheddried then
            d.detacheddried:GetData().state = "jumpedon"
        end
    end

    if d.detacheddried and ((d.detacheddried:IsDead() or not d.detacheddried:Exists()) or d.detacheddried:GetData().state == "jumpedon" or not path:HasPathToPos(d.detacheddried.Position, false)) then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried = nil
    end

    if (npc:IsDead() or not npc:Exists()) and d.detacheddried then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried:GetData().goalheight = 0
        d.detacheddried.EntityCollisionClass = 4
        d.detacheddried.DepthOffset = 0
    end

end

function mod:HangethrowAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 4

    d.Scale = npc.Scale
    if not d.init then
        d.init = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "reveal" then
        mod:spriteOverlayPlay(sprite, "HangethrowReveal")
        if sprite:IsOverlayFinished() then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 2, false, 1)
            d.state = "chase"
        end

        npc:MultiplyFriction(0.8)
    end

    if not d.detacheddried and FindAvailableDetachedDried(npc) and d.state == "chase" then
        d.detacheddried = FindAvailableDetachedDried(npc)
        d.detacheddried.Child = npc
        npc.Parent = d.detacheddried
    end

    if d.state == "chase" then

        if npc.Parent and path:HasPathToPos(npc.Parent.Position, false) then
            local childpos = npc.Parent.Position
            if room:CheckLine(npc.Position,childpos,0,1,false,false) then
                local targetvelocity = (childpos - npc.Position):Resized(speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(childpos, 0.8, 1, true)
            end
        else
            if mod:isScare(npc) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(playerpos, 0.8, 1, true)
            end
        end

        sprite:SetOverlayFrame("HangethrowReveal", 31)

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end

    end

    if d.state == "pickup" then

        if d.detacheddried then
            d.detacheddried.EntityCollisionClass = 0
            if not d.lerpstart or not d.lerppercent then
                d.lerpstart = d.detacheddried.Position
                d.lerppercent = 0
            end
        end
        if d.detacheddried and d.detacheddried:GetData().goalheight == -20 * npc.Scale then
            d.detacheddried.Position = mod:Lerp(d.lerpstart, npc.Position, d.lerppercent)
            if d.lerppercent < 1 then
                d.lerppercent = d.lerppercent + 0.05
            else
                d.lerppercent = 1
            end
        end
        sprite:RemoveOverlay()
        if d.detacheddried and d.detacheddried.Position:Distance(npc.Position) < 40 then
            mod:spritePlay(sprite, "HangethrowPickup")
        else
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebody", 0)
            d.state = "chase"
        end

        if sprite:IsFinished() then
            if d.detacheddried then
                if not d.detacheddried:GetData().airborne then
                    npc.StateFrame = 0
                    d.lerpstart = nil
                    d.lerppercent = nil
                    d.state = "chasepickup"
                end
            else
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebody", 0)
                d.lerpstart = nil
                d.lerppercent = nil
                d.state = "chase"
            end
        end

        npc:MultiplyFriction(0.8)
    end

    if d.state == "chasepickup" then

        if mod:isScare(npc) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        else
            path:FindGridPath(playerpos, 0.8, 1, true)
        end

        if d.detacheddried then
            d.detacheddried.Position = npc.Position
            d.detacheddried.Velocity = npc.Velocity
        else
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebody", 0)
            d.state = "chase"
        end

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end

        sprite:SetOverlayFrame("HangethrowCarryHead", 0)

        npc:MultiplyFriction(0.8)

        if npc.StateFrame > 50 then
            npc.StateFrame = 0
            d.detacheddried:GetData().goalheight = -18 * npc.Scale
            d.state = "throw"
        end
    end

    if d.state == "throw" then
        npc:MultiplyFriction(0.8)
        sprite:RemoveOverlay()
        mod:spritePlay(sprite, "HangethrowThrow")
        if sprite:IsFinished() then
            d.state = "chase"
        end
        if d.detacheddried then
            d.detacheddried.Position = npc.Position
            d.detacheddried.Velocity = npc.Velocity
        end
    end

    if d.detacheddried and ((d.detacheddried:IsDead() or not d.detacheddried:Exists()) or d.detacheddried:GetData().state == "jumpedon" or not path:HasPathToPos(d.detacheddried.Position, false)) then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried = nil
    end

    if (npc:IsDead() or not npc:Exists()) and d.detacheddried then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried:GetData().goalheight = 0
        d.detacheddried.EntityCollisionClass = 4
        d.detacheddried.DepthOffset = 0
    end

    if sprite:IsEventTriggered("Throwstart") then

        if d.detacheddried and not npc:IsDead() and d.detacheddried.Position:Distance(npc.Position) < 40 then
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebodypickup", 0)
            d.detacheddried:GetData().goalheight = -20 * npc.Scale
            d.detacheddried:GetData().zvel = -5
            d.detacheddried.EntityCollisionClass = 0
            d.detacheddried.DepthOffset = 10
        end
    end

    if sprite:IsEventTriggered("Throw") then
        if d.detacheddried then
            d.detacheddried.EntityCollisionClass = 0
            d.detacheddried.GridCollisionClass = 3
            d.detacheddried.Velocity = ((playerpos + player.Velocity * 40) - npc.Position) / 40
            d.detacheddried:GetData().goalheight = 0
            d.detacheddried:GetData().zvel = -7
            npc.Parent = nil
            d.detacheddried.Child = nil
            d.detacheddried = nil
        else
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebody", 0)
            d.state = "chase"
        end
    end

    if sprite:IsEventTriggered("Throwend") then
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/hanges/hangebody", 0)
    end
end

function mod:HangekickAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 2.5

    d.Scale = npc.Scale
    if not d.init then
        d.init = true
        d.state = "reveal"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "reveal" then
        mod:spriteOverlayPlay(sprite, "HangekickReveal")
        if sprite:IsOverlayFinished() then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 2, false, 1)
            d.state = "chase"
        end

        npc:MultiplyFriction(0.8)
    end

    if not d.detacheddried and FindAvailableDetachedDried(npc) and d.state == "chase" then
        d.detacheddried = FindAvailableDetachedDried(npc)
        d.detacheddried.Child = npc
        npc.Parent = d.detacheddried
    end

    if d.state == "chase" then

        if npc.Parent and path:HasPathToPos(npc.Parent.Position, false) then
            local childpos = npc.Parent.Position
            _, d.targetpos = room:CheckLine(childpos, playerpos + (childpos - playerpos):Resized(playerpos:Distance(childpos) + 30) , 0)
            local pathfindtargpos = mod:freeGridToPos(d.targetpos, true, 0, 0, true)
            if pathfindtargpos:Distance(childpos) < 10 or not room:CheckLine(childpos, pathfindtargpos , 0) then
                pathfindtargpos = childpos
            end
            if npc.Position:Distance(pathfindtargpos) > 10 then
                if room:CheckLine(npc.Position,pathfindtargpos,0,1,false,false) then
                    local targetvelocity = (pathfindtargpos - npc.Position):Resized(speed)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
                else
                    path:FindGridPath(pathfindtargpos, 0.8, 1, true)
                end
            else
               d.state = "kick"
            end
        else
            if mod:isScare(npc) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
                local targetvelocity = (playerpos - npc.Position):Resized(speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            else
                path:FindGridPath(playerpos, 0.8, 1, true)
            end
        end

        sprite:SetOverlayFrame("HangekickReveal", 31)

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end

    end

    if d.state == "kick" then
        if d.detacheddried and d.targetpos.X > d.detacheddried.Position.X then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
        npc:MultiplyFriction(0.8)
        sprite:RemoveOverlay()
        mod:spritePlay(sprite, "HangekickKick")
        if sprite:IsFinished() then
            d.state = "chase"
        end
    end

    if sprite:IsEventTriggered("Throwstart") then
        if d.detacheddried and not npc:IsDead() then
            npc.Velocity = (npc.Position - d.detacheddried.Position):Resized(3)
        end
    end

    if sprite:IsEventTriggered("Throw") then
        if d.detacheddried and not npc:IsDead() then
            d.detacheddried.Velocity = (d.detacheddried.Position - d.targetpos):Resized(13):Rotated(math.random(-10,10)) + Vector(math.random(-3,3), math.random(-3,3))
            d.detacheddried:GetData().zvel = -2
        end
    end

    if sprite:IsEventTriggered("Throwend") then
        if d.detacheddried and not npc:IsDead() then
            npc.Velocity = (d.detacheddried.Position - npc.Position):Resized(8)
        end
    end

    if d.detacheddried and ((d.detacheddried:IsDead() or not d.detacheddried:Exists()) or d.detacheddried:GetData().state == "jumpedon" or not path:HasPathToPos(d.detacheddried.Position, false)) then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried = nil
    end

    if (npc:IsDead() or not npc:Exists()) and d.detacheddried then
        npc.Parent = nil
        d.detacheddried.Child = nil
        d.detacheddried:GetData().goalheight = 0
        d.detacheddried.EntityCollisionClass = 4
        d.detacheddried.DepthOffset = 0
    end

end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider, low)
    if (npc.Type == mod.Monsters.Hangeslip.ID and npc.Variant == mod.Monsters.Hangeslip.Var and npc.SubType > 0) and (collider.Type == mod.Monsters.DetachedDried.ID and collider.Variant == mod.Monsters.DetachedDried.Var) then
        if collider.SpriteOffset.Y == 0 then
            if npc.SubType == 1 then
                if npc:GetData().detacheddried  and npc:GetData().detacheddried.InitSeed == collider.InitSeed then
                    npc:GetData().state = "smash"
                    return true
                end
            end
            if npc.SubType == 2 then
                if npc:GetData().state == "chase" and npc:GetData().detacheddried and npc:GetData().detacheddried.InitSeed == collider.InitSeed then
                   npc:GetData().state = "pickup"
                end
            end
            if npc.SubType == 3 then
                return true
            end
        else
            return true
        end

    end
end, 161)