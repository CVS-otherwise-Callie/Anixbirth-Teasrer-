local mod = FHAC
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.ClatterTellerTarget.Var then
        mod:ClatterTellerTargetAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:ClatterTellerTargetAI(ef, sprite, d)

    if not d.init then
        print("hii")
        d.init = true
    end

end

