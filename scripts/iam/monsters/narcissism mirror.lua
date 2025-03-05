local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.NarcissismMirror.Var then
        mod:NarcissismMirrorAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.NarcissismMirror.ID)

function mod:NarcissismMirrorAI(npc, sprite, d)

    if not d.init then
        d.state = d.state or "fall"
        d.init = true
    end

    if d.state == "hangingmidair" then
        if d.frame then
            sprite:SetFrame("mirror", d.frame)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        else
            mod:spritePlay(sprite, "mirror")
        end
    elseif d.state == "thrown" then
        mod:spritePlay(sprite, "mirrorfly")
    elseif d.state == "broken" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        mod:spritePlay(sprite, "glass")
    end

    if npc:CollidesWithGrid() then
        d.state = "broken"
        sprite.Rotation = 0
        if npc.Parent:GetData().personalMirror.Position:Distance(npc.Position)  == 0 then
            npc.Parent:GetData().personalMirror = nil
        end
        npc:MultiplyFriction(0)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.NarcissismMirror.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES and npc:GetData().state == "hangingmidair" then
        npc.Parent:GetData().state = "throwmirror"
        return false
    end
end, mod.Monsters.NarcissismMirror.ID)

