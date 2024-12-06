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

    if npc.StateFrame >= 80+d.offset and d.state == "idle" then
        d.state = "chargeupint"
    elseif npc.StateFrame >= 140+d.offset then
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
        if not d.lightning then
            d.lightning = Isaac.Spawn(1000, 420, 55, npc:GetPlayerTarget().Position, Vector.Zero, npc)
            d.lightning:GetSprite().Scale = d.lightning:GetSprite().Scale * 1.5
            d.lightning:ToEffect().LifeSpan = 120
            d.lightning:GetData().dealsDamage = true
        else
            d.lightning:GetData().lightningtimeout = 1000000
        end
    elseif d.state == "boom" then
        d.lightning:GetData().lightningtimeout = 30
        mod:spritePlay(sprite, "Boom")
        d.lightning:ToEffect().State = 20
    end

    if d.lightning then

        local child = d.lightning:GetData().lightning

        if child and child:GetData().isLightning and child:GetSprite():IsFinished("Lightning" .. (child:GetData().lightningtype or 1)) then
            for k, v in ipairs(Isaac.FindInRadius(npc.Position, 50, EntityPartition.PLAYER)) do
                v:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(npc.Parent), 1)
            end
        else
            d.lightning.Position = npc:GetPlayerTarget().Position
        end
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
        d.lightning = nil
        d.state = "idle"
        d.newidle = math.random(2)
        mod:spritePlay(sprite, "Idle" .. d.newidle)
        d.offset = math.random(-30, 30)
        npc.StateFrame = 0
    end

    if npc:IsDead() then
        if d.lightning then
            d.lightning:Kill()
        end
    end

    npc.Velocity = Vector.Zero
end

