local mod = FHAC
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.ZapperTellerLightning.Var and effect.SubType == 55 then
        mod:ZapperTellerLightningAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:ZapperTellerLightningAI(ef, sprite, d)

    ef.State = ef.State + 1

    local int = math.floor(sprite.Scale:Length()*4)
    
    if not d.lightningtimeout then d.lightningtimeout = 20 end

    if not d.init then
        if d.isLightning and not d.state then
            mod:spritePlay(sprite, "LightningInit")
            Game():ShakeScreen(int)
            sfx:Play(SoundEffect.SOUND_THUNDER, 10/math.random(2, 3), 0, false, (math.random(9, 11))/10)
            d.lightningtype = math.random(2)
            d.state = "lightningstart"
            d.init = true
        elseif not d.isLightning then
            mod:spritePlay(sprite, "ShadowInit")
            d.state = "shadowstart"
            d.init = true
        end
    end

    if ef.State > 50 + ef.LifeSpan then
        if d.isLightning then
            d.state = "endinglight"
            mod:spritePlay(sprite, "LightningEnd")
        end
    end

    --SoundEffect.SOUND_THUNDER

    if d.state == "shadow" then
        mod:spritePlay(sprite, "Shadow")
    elseif d.state == "lightning" then
        mod:spritePlay(sprite, "Lightning" .. d.lightningtype)
    end

    if not d.isLightning and not d.hasmadelightning and ef.State > d.lightningtimeout then
        d.hasmadelightning = true
        d.lightning = Isaac.Spawn(1000, mod.Effects.ZapperTellerLightning.Var, 55, ef.Position, Vector.Zero, ef):ToEffect()
        d.lightning:GetSprite().Scale = ef:GetSprite().Scale
        d.lightning:GetData().isLightning = true
        d.lightning.Parent = ef
    end

    if sprite:IsFinished("ShadowInit") then
        d.state = "shadow"
    end

    if sprite:IsFinished("LightningInit") then
        d.state = "lightning"
    end

    if d.isLightning then
        if sprite:IsPlaying("Lightning" .. (d.lightningtype or 1)) and sprite:GetFrame() > 3 then
        else
            ef.Position = ef.Parent.Position
        end
    end

    if d.isLightning and sprite:IsFinished("Lightning" .. (d.lightningtype or 1)) then
        if math.random(2) == 2 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
        d.lightningtype = math.random(2)
        mod:spritePlay(sprite, "Lightning" .. d.lightningtype)
        if tonumber(sprite.Scale:Length()) > 2 then
            Game():ShakeScreen(int)
        end

        if ef.Parent:GetData().dealsDamage then
            for k, v in ipairs(Isaac.FindInRadius(ef.Position, 50, EntityPartition.PLAYER)) do
                v:TakeDamage(1/10, DamageFlag.DAMAGE_EXPLOSION, EntityRef(ef.Parent), 0.1)
            end
        end
    end

    if sprite:IsFinished("ShadowEnd") or sprite:IsFinished("LightningEnd") then
        ef:ToEffect():Remove()
    end

    if sprite:IsEventTriggered("lightningend") and ef.Parent then
        mod:spritePlay(ef.Parent:GetSprite(), "ShadowEnd")
        ef.Parent:GetData().state = "endshadow"
    end

end