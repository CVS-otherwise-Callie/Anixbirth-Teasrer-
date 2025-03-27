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
        npc:Remove()

        if npc.Parent:GetData().personalMirror.Position:Distance(npc.Position)  == 0 then
            npc.Parent:GetData().personalMirror = nil
        end

        for i = 1, 8 do
            local realshot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated(45*i), npc):ToProjectile()
            local psprite = realshot:GetSprite()
            psprite:ReplaceSpritesheet(0, "gfx/projectiles/mirror shard.png")
            psprite.Rotation = 45*i
            psprite:LoadGraphics()
        end
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.NarcissismMirror.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        if npc:GetData().state == "hangingmidair" then
            npc.Parent:GetData().state = "throwmirror"
        end
        return false
    end
end, mod.Monsters.NarcissismMirror.ID)