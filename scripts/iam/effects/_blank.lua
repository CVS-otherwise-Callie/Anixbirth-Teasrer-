local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.Blank.Var then
        mod:BlankEffectAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:BlankEffectAI(ef, sprite, d)

    if not d.init then
        d.init = true
    end

end