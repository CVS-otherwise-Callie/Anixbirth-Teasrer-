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

    if d.state == "falling" then
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "FallRed")
    end

    if d.state == "ropesplat" then
        npc.Velocity = npc.Velocity * 0.8
        mod:spritePlay(sprite, "RopeSplatRed")
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "splat" then
        npc.Velocity = npc.Velocity * 0.8
        mod:spritePlay(sprite, "SplatRed")
        if sprite:IsFinished() then
            d.state = "idle"
        end
    end

    if d.state == "idle" then
        npc.Velocity = npc.Velocity * 0.8
        sprite:SetFrame("RopeSplatRed", 20)
    end

    if npc.SpriteOffset.Y < d.goalheight or d.zvel < 0 then
        d.airborne = true
        npc.SpriteOffset = npc.SpriteOffset + Vector(0,d.zvel)
        d.zvel = d.zvel + 0.4
    else
        if d.airborne then
            d.airborne = false
            if d.state == "falling" then
                d.state = "ropesplat"
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