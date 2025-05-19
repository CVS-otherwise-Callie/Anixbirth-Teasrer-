local mod = FHAC
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.ClatterTellerTarget.Var then
        mod:ClatterTellerTargetAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:ClatterTellerTargetAI(ef, sprite, d)

    if not d.init then
        ef.SortingLayer = 0
        d.state = "chase"

        d.init = true
    end

    if ef.Parent then
        if not ef.Parent:IsDead() then
            d.clatter_teller = ef.Parent:GetData()
            d.playerpos = d.clatter_teller.playerpos
            d.effectpos = ef.Position

            if d.state == "chase" then
                if not d.speed then
                    d.speed = 0
                end
                if d.speed < 0.1 then
                    d.speed = d.speed + 0.001
                end

                if d.clatter_teller.stateframe < 80 then
                    mod:spritePlay(sprite, "De-Activated")
                    ef.Position = mod:Lerp(ef.Position, d.playerpos, d.speed/1.3)
                else
                    mod:spritePlay(sprite, "Idle")
                    ef.Position = mod:Lerp(ef.Position, d.playerpos, d.speed)
                end

                if d.clatter_teller.state == "attack" and d.clatter_teller.delay > 10 then
                    d.state = "summon"
                end
            end

            if d.state == "summon" then

                ef.Position = mod:Lerp(ef.Position, d.playerpos, d.speed)
                if sprite:IsFinished() and d.speed < 0.5 then
                    d.state = "fade"
                end

                mod:spritePlay(sprite, "Activate")
            end

            if d.state == "fade" then
                ef.Position = mod:Lerp(ef.Position, d.playerpos, d.speed)
                if d.speed > 0 then
                    d.speed = d.speed - 0.002
                end
                mod:spritePlay(sprite, "Fade")
                if sprite:IsFinished() then
                    ef:Remove()
                end
            end
        end
    else
        if d.speed then
            ef.Position = mod:Lerp(ef.Position, d.playerpos, d.speed)
            if d.speed > 0 then
                d.speed = d.speed - 0.001
            end
        end
            mod:spritePlay(sprite, "Fade")
            if sprite:IsFinished() then
                ef:Remove()
            end

    end

end

