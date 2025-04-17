local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.FearFlowerFear.Var then
        mod:FearFlowerFearAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:FearFlowerFearAI(ef, sprite, d)

    if not d.init then
        d.state = "idle"
        ef.DepthOffset = -100
        d.init = true
    end

    d.fearRad = ef.SpriteScale.X*80

    local par = ef

    if ef.Parent and ef.Parent:Exists() then
        par = ef.Parent
        ef.Postition = ef.Parent.Position
    end

    for _, player in ipairs(Isaac.FindInRadius(ef.Position, d.fearRad, EntityPartition.PLAYER)) do
        player:AddFear(EntityRef(par), 3)
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        d.timetoDie = false
    elseif d.state == "hide" then
        mod:spritePlay(sprite, "Death")
    elseif d.state == "appear" then
        mod:spritePlay(sprite, "Appear")
        d.timetoDie = false
    elseif d.state == "kill" then
        mod:spritePlay(sprite, "Death")
        d.timetoDie = true
    end

    if sprite:IsFinished("Death") and d.timetoDie == true then
        ef:Remove()
    end


end