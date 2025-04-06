--not very shcokingly i just stole the larry king jr ai thing

local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.MiniBosses.Chomb.Var then
        mod:ChombAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.MiniBosses.Chomb.ID)

local function ChombYAxisAligned(pos, ignorerocks)
    local room = game:GetRoom()
    local vec = Vector(0, 1)
    local positions = {}
    for i = 1, 4 do
        if i % 4 == 0 then
            local gridvalid = true
            local dist = 1
            while gridvalid == true do
                local newpos = pos + (vec:Rotated(i * 90) * dist)
                local gridColl = room:GetGridCollisionAtPos(newpos)
                if (gridColl ~= GridCollisionClass.COLLISION_NONE or dist > 25) and not ignorerocks then
                    gridvalid = false
                elseif ignorerocks and gridColl == GridCollisionClass.COLLISION_WALL or dist > 25 then
                    gridvalid = false
                else
                    table.insert(positions, newpos)
                    dist = dist + 1
                end
            end
        end
    end
    --[[for i = 1, #positions do
		Isaac.Spawn(5, 40, 0, positions[i], nilvector, npc):ToEffect()
	end]]
    if #positions > 0 then
        return positions[#positions]
    else
        return pos
    end
end

function mod:ChombAI(npc, sprite, d)

    local room = game:GetRoom()

    if not d.larryKJinit then

        d.butts = {}

        table.insert(d.butts, npc)

        if not d.bodyInit and not d.IsSegment then
            d.InitSeed = npc.InitSeed
            d.extraNum = 0
            d.MovementLog = d.MovementLog or {}
            local num = math.random(3)+1
            if npc.SubType == 0 then
                npc.SubType = 1
            elseif npc.SubType < 0 then
                npc.SubType = num
            end
            for i = 1, npc.SubType do
                local butt = Isaac.Spawn(mod.MiniBosses.Chomb.ID, mod.MiniBosses.Chomb.Var, (i > 1 and mod.MiniBosses.Chomb.Sub or 0), npc.Position, Vector.Zero, npc)
                butt.Parent = npc
                butt:GetData().InitSeed  = npc.InitSeed
                butt:GetData().OldPos = butt.Position
                butt.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                butt.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                butt:GetData().SegNumber = i + 1
                butt:GetData().MovementLog = {}
                table.insert(butt:GetData().MovementLog, npc.Position)
                if i == npc.SubType then
                    butt:GetData().IsSegment = true
                    butt:GetData().IsButt = true
                    butt:GetData().name = "Butt"
                    butt:SetSpriteFrame("ButtHori", 1)
                else
                    butt:GetData().IsSegment = true
                    butt:GetData().name = "Body"
                    butt:SetSpriteFrame("BodyHori", 1)
                end
                table.insert(d.butts, butt)
                table.insert(d.MovementLog, butt.Position)
                butt:GetData().butts = d.butts
            end
        elseif not d.IsSegment then
            d.SegNumber = 1
        end
        npc.StateFrame = 0
        d.state = "Moving"
        d.larryKJinit = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.IsSegment then

        npc:GetData().MoveDelay = (d.SegNumber-1) * 8
        npc.DepthOffset = (-8 * d.SegNumber-1)

        local targpos = npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay]
        if targpos then
            npc.Velocity = targpos - npc.Position
        end

        npc.Color = npc.Parent.Color
        sprite.Color = npc.Parent:GetSprite().Color
    elseif not d.IsSegment then

        if d.state == "Moving" then

            d.newpos = d.newpos or ChombYAxisAligned(npc.Position, false)
            if (npc.Position:Distance(d.newpos) < 10 or npc.Velocity:Length() == 0) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0)then
                d.newpos = ChombYAxisAligned(npc.Position, false)
            end
            local targetvelocity = (d.newpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)

            mod:spritePlay(sprite, "HeadVert")
        elseif d.state == "Hiding" then

            mod:spritePlay(sprite, "Burrow")
            --npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 1), 1)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

            for k, v in ipairs(d.butts) do
                v.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                v:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end

            npc:MultiplyFriction(0.9)

        end

        if sprite:IsEventTriggered("Dissapear") then
            npc.EntityCollisionClass = EntityCollisionClass.COLLISION_NONE
        end

        if room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL or room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
            npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
            d.state = "Hiding"
        end


        d.MovementLog[npc.FrameCount] = npc.Position
    end

end