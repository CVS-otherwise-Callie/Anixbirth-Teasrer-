local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.DetachedDried.Var then
        mod:DetachedDriedAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.DetachedDried.ID)

--if you're looking for dried's code its in the iam folder


function mod:DetachedDriedAI(npc, sprite, d)
    local room = game:GetRoom()

        local driedsubtypes = {
        {
            --black
            colour = "Black",
            creep = 26,
            creepsec = 1,
            splat = Color(0, 0, 0, 1)
        },
        {
            --white
            colour = "White",
            creep = 25,
            creepsec = 1,
            splat = Color(255, 255, 255, 1)
        },
        {
            --slippery brown
            colour = "Brown",
            creep = 94,
            creepsec = 1,
            splat = Color(126, 97, 9, 1),
            creeptype = ProjectileFlags.CREEP_BROWN
        },
        {
            --green
            colour = "Green",
            creep = 23,
            creepsec = 0.5,
            splat = Color(18, 143, 31, 1)
        },
        {
            --yellow
            colour = "Yellow",
            creep = 24,
            creepsec = 1,
            splat = Color(240, 235, 0, 1)
        },
        {
            --red
            colour = "Red",
            creep = 22,
            creepsec = 1,
            creeptype = ProjectileFlags.RED_CREEP,
            splat = Color.Default
        }
    }

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
        d.goalheight = 0

        d.mynumber = d.mynumber or math.random(1, #driedsubtypes)

        if npc.SubType == nil or npc.SubType == 0 then
            d.tab= driedsubtypes[d.mynumber]
        else
            d.tab = driedsubtypes[npc.SubType]
        end

        if npc.Parent then

            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            if npc.Parent.Variant == mod.Monsters.Dried.Var then
                d.zvel = 0
                d.state = "falling"
                npc.DepthOffset = -20
            end
            if npc.Parent.Variant == mod.Monsters.Hangeslip.Var then
                d.zvel = 0
                d.state = "falling"
                npc.Parent = nil
            end
        else
            d.zvel = 0
            d.state = "idle"
        end
        d.init = true
    end

    if not npc.Child then
        mod:SaveEntToRoom(npc, true)
        d.goalheight = 0
    end

    if d.state == "falling" then
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "Fall" .. d.tab.colour)
    end

    if d.state == "ropesplat" then
        mod:spritePlay(sprite, "RopeSplat" .. d.tab.colour)
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "hangethrowheadsplat" then
        if npc.SpriteOffset.Y == -20 then
            mod:spritePlay(sprite, "LandOnHangethrowHead" .. d.tab.colour)
        else
            mod:spritePlay(sprite, "HangethrowHeadSplat" .. d.tab.colour)
        end
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "splat" then
        mod:spritePlay(sprite, "Splat" .. d.tab.colour)
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "idle" then

        if npc.Child and npc.Child.SubType == 2 and (npc.SpriteOffset.Y == -20 * npc.Child:GetData().Scale and d.zvel >= 0) then
            sprite:SetFrame("LandOnHangethrowHead" .. d.tab.colour, 16)
        else
            sprite:SetFrame("RopeSplat" .. d.tab.colour, 20)
        end
    end

    if npc.SpriteOffset.Y < d.goalheight or d.zvel < 0 then
        d.airborne = true
        if npc.SpriteOffset.Y + d.zvel < 0 then
            npc.SpriteOffset = npc.SpriteOffset + Vector(0,d.zvel)
        else
            npc.SpriteOffset.Y = 0
        end
        npc.EntityCollisionClass = 0
        d.zvel = d.zvel + 0.4
    else
        if room:GetGridEntity(room:GetGridIndex(npc.Position)) and room:GetGridEntity(room:GetGridIndex(npc.Position)):GetType() == 7 then
            d.state = "hole"
        else

            if d.splat then
                for i = 1, 20, 1 do
                    local rotated = math.random(-180,180)
                    local projectile = Isaac.Spawn(9, 0, 0, (npc.Position + (Vector(10,10):Rotated(rotated))), Vector(math.random(2,4),0):Rotated(rotated) , npc):ToProjectile();
                    projectile:GetData().targ = npc:GetPlayerTarget()
                    projectile.FallingAccel = 0.5
                    projectile.FallingSpeed = - (math.random() * 4)
                    projectile.Height = -5
                    projectile.Color = d.tab.splat
                --[[    if npc.SubType == nil or npc.SubType == 0 then
                        projectile:GetData().isDetDried = d.mynumber
                    else
                        projectile:GetData().isDetDried = npc.SubType
                    end ]]
                end
                d.splat = false
            end

            if d.hurtfly then
                d.hurtfly = false
            end

            npc.Velocity = npc.Velocity * 0.8
            npc.SpriteOffset.Y = d.goalheight
            d.zvel = 0
            if d.goalheight == 0 then
                npc.DepthOffset = 0
                if d.state ~= "jumpedon" then
                    npc.EntityCollisionClass = 4
                end
            end
            if d.airborne then
                d.airborne = false
                if d.state == "falling" then
                    d.state = "ropesplat"
                elseif npc.Child and d.goalheight == -20 * npc.Child:GetData().Scale then
                    d.state = "hangethrowheadsplat"
                else
                    d.state = "splat"
                end
            end
        end
    end

    if d.state == "hole" then
        mod:spritePlay(sprite, "Hole" .. d.tab.colour)
        if sprite:IsFinished() then
            npc:Remove()
        end
    end

    local player = npc:GetPlayerTarget()
    if d.hurtfly and npc.Position:Distance(player.Position) < 30 then
        player:TakeDamage(1, 0, EntityRef(npc), 0)
    end

    if room:GetGridEntity(room:GetGridIndex(npc.Position)) then
        --print(room:GetGridEntity(room:GetGridIndex(npc.Position)):GetType())
    end

    if d.airborne and d.zvel < 0 then
        npc.GridCollisionClass = 3
    elseif (not d.airborne) and ((room:GetGridEntity(room:GetGridIndex(npc.Position)) and room:GetGridEntity(room:GetGridIndex(npc.Position)).CollisionClass == 0) or not (room:GetGridEntity(room:GetGridIndex(npc.Position)))) then
        npc.GridCollisionClass = 5
    end

    if d.state == "jumpedon" then
        if not d.splurted then
            for i = 1, 20, 1 do
                local posneg = ((i%2)*2)-1
                local projectile = Isaac.Spawn(9, 0, 0, (npc.Position + Vector(30*posneg, math.random(-5,5))), Vector( (math.random()*8) * posneg,0):Rotated(math.random(-5,5)) , npc):ToProjectile();
                projectile:GetData().targ = npc:GetPlayerTarget()
                projectile.FallingAccel = 0.5
                projectile.FallingSpeed = math.random(-7,-2)
                projectile.Height = -5
                projectile.Color = d.tab.splat
             --[[    if npc.SubType == nil or npc.SubType == 0 then
                    projectile:GetData().isDetDried = d.mynumber
                else
                    projectile:GetData().isDetDried = npc.SubType
                end ]]
            end
            d.splurted = true
        end
        npc.EntityCollisionClass = 0
        mod:spritePlay(sprite, "HangejumpExplode" .. d.tab.colour)
        if sprite:IsFinished() then
            mod:RemoveEntFromRoomSave(npc)
            npc:Remove()
        end
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.DetachedDried.ID and npc.Variant == mod.Monsters.DetachedDried.Var then
        return false
    end
end, mod.Monsters.DetachedDried.ID)
