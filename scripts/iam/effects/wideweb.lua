local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.LargeSpiderweb.Var then
        mod:LargeSpiderwebAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:LargeSpiderwebAI(ef, sprite, d)

    mod:SaveEntToRoom(ef)

    sprite:ReplaceSpritesheet(0 , "gfx/effects/effect_LargeSpiderweb_placeholder (PLEASE DELETE LATER).png")

    if not d.init then
        ef.DepthOffset = -1000
        d.Size = ef.SubType + 1
        d.init = true
    end

    sprite.Scale = Vector(d.Size/100, d.Size/100)

    local hathnum = d.Size

    for _, player in ipairs(Isaac.FindInRadius(ef.Position, hathnum * 2, EntityPartition.PLAYER)) do
        if player.Position:Distance(ef.Position) < hathnum then
            player:MultiplyFriction(0.8)
            player:GetSprite().Color = Color(0.5, 0.5, 0.5, 1)
        else
            player:GetSprite().Color = Color(1, 1, 1, 1)
        end
    end

end