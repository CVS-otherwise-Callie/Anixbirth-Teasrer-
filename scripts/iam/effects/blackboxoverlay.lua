local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.BlackOverlayBox.Var and effect.SubType == 55 then
        mod:BlackOverlayBoxAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:BlackOverlayBoxAI(ef, sprite, d)

    if not d.init then
        mod:spritePlay(sprite, "Death")
        sprite.Color = mod.Color.Invisible
        mod:spritePlay(sprite, "Idle")
        d.time = game.TimeCounter
        d.init = true
    end

    ef.DepthOffset = -20

    local time2 = game.TimeCounter - d.time

    sprite.Color = Color.Lerp(mod.Color.Invisible, mod.Color.ColorDankBlackReal, time2/(30*d.transColor))

    if time2/(30*d.transColor) > 1 and d.ending then
        game:End(d.ending)
    end

end

function mod:FadeOutBlack(time, ending)
    if mod:CheckForEntInRoom({Type = EntityType.ENTITY_EFFECT, Variant = mod.Effects.BlackOverlayBox.Var, SubType = 55}, true, true, false) == false  then
        local box = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effects.BlackOverlayBox.Var, 55, Vector(game:GetRoom():GetCenterPos().X, game:GetRoom():GetBottomRightPos().Y), Vector.Zero, nil):ToEffect()
        box:GetData().transColor = time
        box:GetData().ending = ending
        box:AddEntityFlags(EntityFlag.FLAG_NO_QUERY | EntityFlag.FLAG_NO_TARGET)
    end
end