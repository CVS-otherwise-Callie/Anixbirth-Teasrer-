local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.ZapperTeller.Var then
        mod:ZapperTellerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.ZapperTeller.ID)

function mod:ZapperTellerAI(npc, sprite, d)

    if not d.init then
        d.state = "idle"
        d.offset = math.random(-30, 30)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.newidle = math.random(2)
        mod:spritePlay(sprite, "Idle" .. d.newidle)
        
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 150+d.offset and d.state == "idle" then
        d.state = "chargeupint"
    elseif npc.StateFrame >= 300+d.offset then
        d.state = "boom"
    elseif d.state == "idle" then
        if sprite:IsFinished("Idle" .. d.newidle) then
            d.newidle = math.random(2)
            mod:spritePlay(sprite, "Idle" .. d.newidle)
        end
    elseif d.state == "chargeup" then
        mod:spritePlay(sprite, "ChargeUp")
    end

    if d.state == "chargeupint" then
        mod:spritePlay(sprite, "ChargeUpIntro")
    elseif d.state == "boom" then
        mod:spritePlay(sprite, "Boom")
    end

    if sprite:IsFinished("ChargeUpIntro") then
        d.state = "chargeup"
        mod:spritePlay(sprite, "ChargeUp")
    end
    
    if sprite:IsFinished("ChargeUp") then
        d.state = "chargeupl"
        mod:spritePlay(sprite, "ChargeUpLoop")
    end

    if sprite:IsFinished("Boom") then
        d.state = "idle"
        d.newidle = math.random(2)
        mod:spritePlay(sprite, "Idle" .. d.newidle)
        d.offset = math.random(-30, 30)
        npc.StateFrame = 0
    end

    npc.Velocity = Vector.Zero
end

