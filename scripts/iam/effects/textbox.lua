local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.TextBox.Var and effect.SubType == 55 then
        mod:BlankEffectAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:BlankEffectAI(ef, sprite, d)

    if not d.init then
        d.state = "prompt"
        d.init = true
    end

    if d.state == "prompt" then
        mod:spritePlay(sprite, "Prompt")
    elseif d.state == "opening" then
        mod:spritePlay(sprite,"Open")
    elseif d.state == "idle" then
        mod:spritePlay(sprite,"Idle")
    elseif d.state == "idletalking" then
        mod:spritePlay(sprite,"IdleTalking")
    elseif d.state == "closing" then
        mod:spritePlay("Close")
    end

    if sprite:IsFinished("Open") then
        d.state = "idletalking"
    elseif sprite:IsFinished("Close") then
        d.state = "prompt"
    end

end