local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.TextBox.Var then
        mod:TextBoxNPCAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:TextBoxNPCAI(ef, sprite, d)

    if not d.init then
        d.state = d.state or "prompt"
        d.anchor = d.anchor or 1
        d.init = true
    end

    d.text = d.text or 
    [===============[
this is some
random text
for idiots

two paragrpahs
are cool
    ]===============]

    sprite.Scale = Vector(0.5, 0.5)

    if d.state == "prompt" then
        mod:spritePlay(sprite, "Prompt")

        d.stringLine = 1
        d.curCharacter = ""

    elseif d.state == "opening" then
        mod:spritePlay(sprite,"Open")
    elseif d.state == "idle" then
        mod:spritePlay(sprite,"Idle")
    elseif d.state == "idletalking" then
        mod:spritePlay(sprite,"IdleTalking")
    elseif d.state == "closing" then
        mod:spritePlay(sprite, "Close")
    end

    if sprite:IsFinished("Open") then
        d.state = "idletalking"
    elseif sprite:IsFinished("Close") then
        d.state = "prompt"
    end

    if sprite:IsEventTriggered("removequick") then
        if d.removeonDeath then
            ef:Remove()
        end
    end


    if d.state == "idletalking" then
        if d.text then

            local xAnch = 50

            if d.stats.anchor and d.stats.anchor == 2 then
                xAnch = -15
            end

            if not d.textBox then
                d.textBox = mod:DrawDialougeTalk(d.text, Isaac.WorldToScreen(ef.Position - Vector(xAnch, 90)), d.stats or {rate = 3, senCap = 15, anchor = d.anchor})
            end

            if d.textBox.isFinished then
                d.textBox = nil

                d.state = "closing"
            end

        else
            mod:spritePlay("Close")
        end
    end

end

mod.onEffectTouch(mod.Effects.TextBox, function(player, npc)
    local sd = npc:GetData()

    if sd.state == "prompt" then
        sd.state = "opening"
    end
end)

function mod:NPCDialouge(text, position, stats, npc)
    position = position or Game():GetRoom():GetCenterPos()
    npc = npc or nil
    local textbox = Isaac.Spawn(mod.Effects.TextBox.ID, mod.Effects.TextBox.Var, 0, position, Vector.Zero, npc)
    textbox:GetData().text = text
    textbox:GetData().stats = stats or {}
    textbox:GetData().removeonDeath = true
    textbox:GetData().state = "opening"
end