local mod = FHAC
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
    if proj.Variant == mod.Projectiles.EmberProjectile.Var then
        mod:EmberProjectileAI(proj, proj:GetSprite(), proj:GetData())
    end
end)

function mod:EmberProjectileAI(proj, sprite, d)

    if not d.init then
        sprite:ReplaceSpritesheet(0, "gfx/projectiles/ember.png")
        sprite:LoadGraphics() 
        d.init = true
    end

    local num = proj.Scale

    if proj.FrameCount % 3 == 0 then
        local ember = Isaac.Spawn(1000,EffectVariant.EMBER_PARTICLE, 0, proj.Position - Vector(0, math.abs(proj:ToProjectile().Height)), proj.Velocity:Rotated(180):Resized(7), proj)
        ember:GetSprite().Scale = Vector(ember:GetSprite().Scale.X * num, ember:GetSprite().Scale.Y * num)
        ember:ToEffect().LifeSpan = 60
    end
end