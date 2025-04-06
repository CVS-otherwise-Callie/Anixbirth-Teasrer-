--not very shcokingly i just stole the larry king jr ai thing

local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.MiniBosses.Chomb.Var then
        mod:ChombAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.MiniBosses.Chomb.ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount , damage, source)
    if npc.Variant == mod.MiniBosses.Chomb.Var then
        mod:ChombHurt(npc, amount, damage, source)
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
    local target = npc:GetPlayerTarget()
    local targetpos = target.Position

    if not d.larryKJinit then

        d.butts = {}

        table.insert(d.butts, npc)

        if not d.bodyInit and not d.IsSegment then
            d.InitSeed = npc.InitSeed
            d.extraNum = 0
            d.name = nil
            d.MovementLog = d.MovementLog or {}
            local num = math.random(3)+1
            if npc.SubType == 0 then
                npc.SubType = 1
            elseif npc.SubType < 0 then
                npc.SubType = num
            end
            for i = 1, npc.SubType do
                local pos
                if #d.butts > 0 then
                    pos = d.butts[#d.butts]
                else
                    pos = npc
                end
                local butt = Isaac.Spawn(mod.MiniBosses.Chomb.ID, mod.MiniBosses.Chomb.Var, (i > 1 and mod.MiniBosses.Chomb.Sub or 0), mod:FindClosestNextEntitySpawn(pos, 50, false), Vector.Zero, npc)
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
            d.randWait = math.random(-20, 20)
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

        npc:GetData().MoveDelay = (d.SegNumber-1) * 6
        npc.DepthOffset = (-6 * d.SegNumber-1)

        local targpos = npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay]
        if targpos then
            npc.Velocity = targpos - npc.Position
        elseif npc.Parent:GetData().butts[d.SegNumber - 1] then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc.Velocity = mod:Lerp(npc.Velocity, (npc.Parent:GetData().butts[d.SegNumber - 1].Position - npc.Position):Resized(15), 1)
        end

        npc.Color = npc.Parent.Color
        sprite.Color = npc.Parent:GetSprite().Color

        if d.state == "Hidden" then
            if npc.StateFrame > 60 + npc.Parent:GetData().randWait then
                d.state = "Appearing"
            end
        elseif d.state == "Appearing" then
            mod:spritePlay(sprite, d.name .. "UnBurrow")
            npc.Visible = true
        elseif d.state == "Hiding" then
            npc:MultiplyFriction(0.9)
            mod:spritePlay(sprite, d.name .. "Burrow")
        else
            mod:spritePlay(sprite, d.name .. "Vert")
        end

        if sprite:IsFinished(d.name .. "UnBurrow") then
            d.state = "Moving"
        end

    elseif not d.IsSegment then
        
        if npc:HasMortalDamage() then
            for k, v in ipairs(d.butts) do
                v:Kill()
            end
        end

        if d.state == "Moving" then

            npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

            d.killernewpos = nil

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

        elseif d.state == "Hidden" then
            if npc.StateFrame > 60 + d.randWait then
                    npc.Position = Vector((targetpos + RandomVector()*3).X, room:GetTopLeftPos().Y)
                    npc.Velocity = Vector.Zero
                d.state = "Appearing"
            end
        elseif d.state == "Appearing" then
            mod:spritePlay(sprite, "UnBurrow")
            npc.Visible = true
        elseif d.state == "Charging" then

            d.hasCharged = true

            if not d.chargeInit then
                d.dir = nil
                if target.Position.X < npc.Position.X then --future me pls don't fuck this up
                    sprite.FlipX = true
                    d.dir = -10
                else
                    sprite.FlipX = false
                    d.dir =10
                end
                d.chargeInit = true
            end

            mod:spritePlay(sprite, "Charge")

            local targetvelocity = (Vector(npc.Position.X + d.dir, npc.Position.Y) - npc.Position):Resized(10)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)

            if npc:CollidesWithGrid() and (room:GetGridCollisionAtPos(npc.Position + Vector(d.dir*2, 0)) == GridCollisionClass.COLLISION_WALL or room:GetGridCollisionAtPos(npc.Position + Vector(d.dir*2, 0)) == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) then
                d.state = "ChargeOffset"
                game:ShakeScreen(10)
                d.chargeInit = false
            end

        elseif d.state == "ChargeOffset" then

            npc:MultiplyFriction(0)
            mod:spritePlay(sprite, "Slam")

        end

        if d.state == "Moving" and not (room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL or room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) and
        math.abs(npc.Position.Y - targetpos.Y) < 20 and not d.hasCharged then
            d.state = "Charging"
        end

        d.MovementLog[npc.FrameCount] = npc.Position
    end

    if d.state == "Moving" and (room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL or room:GetGridCollisionAtPos(npc.Position + Vector(0, 10)) == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) then
        npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        d.state = "Hiding"
    end

    if sprite:IsEventTriggered("Dissapear") and d.state ~= "Hidden" then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.Visible = false
        d.hasCharged = false

        npc.StateFrame = 0
        d.state = "Hidden"
    end

    if sprite:IsEventTriggered("Appear") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
    end

    if sprite:IsFinished("UnBurrow") then
        d.state = "Moving"
    elseif sprite:IsFinished("Slam") then
        d.state = "Moving"
    end

end

function mod:ChombHurt(npc, amount, damageFlags, source)
    local d = npc:GetData()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()

        if not d.IsSegment then
            for _, butt in ipairs(Isaac.FindByType(mod.MiniBosses.Chomb.ID, mod.MiniBosses.Chomb.Var)) do
                if butt.Parent and butt.Parent.InitSeed == npc.InitSeed then
                    butt:TakeDamage(amount, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
                end
            end
        elseif not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, damageFlags) then
            npc.Parent:TakeDamage(amount, damageFlags, source, 0)
            return false
        end
end