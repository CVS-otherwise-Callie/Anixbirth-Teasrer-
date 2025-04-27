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
        --ef:AddEntityFlags(EntityFlag.FLAG_IGNO)
        d.init = true
    end

    if d.target then
        local targetvelocity = (d.target.Position - ef.Position):Resized(4)
        ef.Velocity = mod:Lerp(ef.Velocity, targetvelocity, 0.6)
    end

    if d.target and d.target.Type ~= 1 then
        for k, v in ipairs(d.dekkaTears) do
            if v:GetData().offyourfuckingheadset and v:GetData().moveit then
                v:GetData().offyourfuckingheadset = v:GetData().offyourfuckingheadset - 0.1
                v:GetData().moveit = v:GetData().moveit + 0.1
            end
        end
    end

    if ef.State > 519 then
        if ef.Velocity:Length() > 2 then
            d.target = nil
        else
            if d.dekkaTears then
                for k, v in ipairs(d.dekkaTears) do
                    v:GetData().type = nil
                end
            end
        end 
    end


end