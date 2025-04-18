local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.FearFlower.Var then
        mod:FearFlowerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.FearFlower.ID)

function mod:FearFlowerAI(npc, sprite, d)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        mod:spritePlay(sprite, "Open")
        d.fearEffect = Isaac.Spawn(1000, mod.Effects.FearFlowerFear.Var, 55, npc.Position, Vector.Zero, npc):ToEffect()
        d.fearEffect:GetData().state = "appear"
        d.fearEffect.SpriteScale = d.fearEffect.SpriteScale*0.5
        d.state = "opening"
        d.canbeHit = true
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")

        if d.fearEffect then
            if d.fearEffect.SpriteScale.X >= 1.5 then
                d.fearEffect.SpriteScale = Vector(1.5, 1.5)
            else
                d.fearEffect.SpriteScale = d.fearEffect.SpriteScale*1.01
            end
        end

    elseif d.state == "hiding" then

        if d.fearEffect then
            if d.fearEffect.SpriteScale.X <= 0.5 then
                d.fearEffect.SpriteScale = Vector(0.5, 0.5)
            else
                d.fearEffect.SpriteScale = d.fearEffect.SpriteScale*0.99
            end
        end

        mod:spritePlay(sprite, "ClosedLoop")

        if npc.StateFrame > 100 then
            d.state = "opening"
        end

    elseif d.state == "closing" then
        mod:spritePlay(sprite, "Close")
    elseif d.state == "opening" then
        mod:spritePlay(sprite, "Open")
    end

    if sprite:IsFinished("Open") then
        d.state = "idle"
        d.fearRad = 30
    elseif sprite:IsFinished("Close") then
        npc.StateFrame = 0
        d.state = "hiding"
    end
    
    if sprite:IsEventTriggered("Open") then
        d.canbeHit = true
        
    elseif sprite:IsEventTriggered("Close") then
        d.canbeHit = false
    end

    if npc:IsDead() and d.fearEffect then
        d.fearEffect:GetData().state = "kill"
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function (_, npc, amount, damageFlags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.FearFlower.Var then
        local d = npc:GetData()
        if not npc:GetData().canbeHit then

            if d.state == "hiding" then
                npc:ToNPC().StateFrame = 10
            end

            return false
        elseif d.state == "idle" and mod:CheckForOnlyEntInRoom({mod:ENT("Fear Flower")}) == false and not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, damageFlags) then
            npc:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
            d.state = "closing"
            return false
        end
    end
end)

