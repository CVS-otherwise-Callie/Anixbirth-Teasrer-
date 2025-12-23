local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.DekatesseraEffect.Var then
        mod:DekatesseraEffectAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:DekatesseraEffectAI(ef, sprite, d)

    ef.State = ef.State + 1

    if not d.init then
        d.init = true
    end

    if d.target then
        local targetvelocity = d.target.Position - ef.Position
        local change = 0
        if targetvelocity:Resized(4):Length() > (targetvelocity/d.precision):Length() then
            change = targetvelocity/d.precision
        else
            change = targetvelocity:Resized(4)
        end
        ef.Position = ef.Position + change
    end

    if (d.Baby and d.Baby:IsDead()) or ef.State > 505 or (d.target and d.target:IsDead())then
        ef:Remove()
    end
end