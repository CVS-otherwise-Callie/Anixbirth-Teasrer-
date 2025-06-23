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

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
        d.goalheight = 0

        if npc.Parent then

            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            if npc.Parent.Variant == mod.Monsters.Dried.Var then
                d.zvel = 0
                d.state = "falling"
            end
        else
            d.zvel = 0
            d.state = "idle"
        end
        d.init = true
    end

    if not npc.Child then
        d.goalheight = 0
    end

    if d.state == "falling" then
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "FallRed")
    end

    if d.state == "ropesplat" then
        mod:spritePlay(sprite, "RopeSplatRed")
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "hangethrowheadsplat" then
        if npc.SpriteOffset.Y == -20 then
            mod:spritePlay(sprite, "LandOnHangethrowHeadRed")
        else
            mod:spritePlay(sprite, "HangethrowHeadSplatRed")
        end
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "splat" then
        mod:spritePlay(sprite, "SplatRed")
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "idle" then

        if npc.Child and npc.Child.SubType == 2 and (npc.SpriteOffset.Y == -20 * npc.Child:GetData().Scale and d.zvel >= 0) then
            sprite:SetFrame("LandOnHangethrowHeadRed", 16)
        else
            sprite:SetFrame("RopeSplatRed", 20)
        end
    end

    if npc.SpriteOffset.Y < d.goalheight or d.zvel < 0 then
        d.airborne = true
        npc.SpriteOffset = npc.SpriteOffset + Vector(0,d.zvel)
        d.zvel = d.zvel + 0.4
    else
        npc.Velocity = npc.Velocity * 0.8
        npc.SpriteOffset.Y = d.goalheight
        d.zvel = 0
        if d.goalheight == 0 then
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

    if d.airborne and d.zvel < 0 then
        npc.GridCollisionClass = 3
    elseif (not d.airborne) and ((room:GetGridEntity(room:GetGridIndex(npc.Position)) and room:GetGridEntity(room:GetGridIndex(npc.Position)).CollisionClass == 0) or not (room:GetGridEntity(room:GetGridIndex(npc.Position)))) then
        npc.GridCollisionClass = 5
    end

    if d.state == "jumpedon" then
        npc.EntityCollisionClass = 0
        mod:spritePlay(sprite, "HangejumpExplodeRed")
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.DetachedDried.ID and npc.Variant == mod.Monsters.DetachedDried.Var then
        return false
    end
end, mod.Monsters.DetachedDried.ID)
