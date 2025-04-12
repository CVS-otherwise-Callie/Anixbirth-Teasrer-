local mod = FHAC
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.ClatterTellerTarget.Var then
        mod:ClatterTellerTargetAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:ClatterTellerTargetAI(ef, sprite, d)

    if not d.init then
        ef.DepthOffset = -100
        d.state = "chase"

        d.init = true
    end

    if d.state == "chase" then
        mod:spritePlay(sprite, "Idle")
        --ef.Position:Lerp(target, 0.1)
    end

end

