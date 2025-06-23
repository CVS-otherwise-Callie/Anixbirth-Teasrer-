local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.OGWilloWalkerBox.Var then
        effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight()*2)-70))
        mod:OGWilloWalkerBoxAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, effect)
            effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight()*2)-70))
end, mod.Effects.OGWilloWalkerBox.Var)

function mod:OGWilloWalkerBoxAI(ef, sprite, d)

    if not d.init then
        d.init = true
    end
    ef.DepthOffset = 500
end