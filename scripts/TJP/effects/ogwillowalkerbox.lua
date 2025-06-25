local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.OGWilloWalkerBox.Var then
        if not Options.Fullscreen then
            effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight())))
        else
            effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight())))
        end
        mod:OGWilloWalkerBoxAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, effect)
    if not Options.Fullscreen then
        effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight())))
    else
        effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight())))
    end
    --print(Isaac.GetScreenWidth())
    --effect.Position = Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight())))
end, mod.Effects.OGWilloWalkerBox.Var)

function mod:OGWilloWalkerBoxAI(ef, sprite, d)

    if not d.init then
        d.init = true
    end

    if not ef.Child then
        d.font = Isaac.Spawn(1000, 430, 55, ef.Position, ef.Velocity, ef):ToEffect() --Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight()*2)-70))
        d.font.Parent = ef
        ef.Child = d.font
        d.font = ef.Child:GetData()
    end
    print(Options.Fullscreen)
    ef.DepthOffset = 500
end