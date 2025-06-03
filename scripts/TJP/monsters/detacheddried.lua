local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.DetachedDried.Var then
        mod:DetachedDriedAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.DetachedDried.ID)

function mod:DetachedDriedAI(npc, sprite, d)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
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

    mod:SaveEntToRoom(npc, true)

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

        if npc.Child and npc.Child.SubType == 2 and (npc.SpriteOffset.Y == -20 and d.zvel >= 0) then
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
        npc.EntityCollisionClass = 4
        if d.airborne then
            d.airborne = false
            if d.state == "falling" then
                d.state = "ropesplat"
            elseif d.goalheight == -20 then
                d.state = "hangethrowheadsplat"
            else
                d.state = "splat"
            end
        end
    end


end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.DetachedDried.ID and npc.Variant == mod.Monsters.DetachedDried.Var then
        return false
    end
end, mod.Monsters.DetachedDried.ID)
