local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.RainGridEffect.Var then
        mod:RainGridEffect(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:RainGridEffect(ef, sprite, d)

    if ef.FrameCount % 3 == 0 then
        d.rngshoot = math.random(100)
        for i = 0, 3 do
            local proj = Isaac.Spawn(1000, EffectVariant.RAIN_DROP, 0, ef.Position + Vector(math.random(0, 40), 0):Rotated((60*i+d.rngshoot)), Vector.Zero, ef):ToEffect()
            proj:Update()
            d.rngshoot = d.rngshoot + 30
        end
    end

    ef.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

    mod:SaveEntToRoom(ef, true)

end