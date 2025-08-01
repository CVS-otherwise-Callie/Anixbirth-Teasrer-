local mod = FHAC
local game = Game()
local rng = RNG()

function mod:ZapperTellerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        d.state = "idle"
        d.offset = math.random(-30, 30)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        d.lightning = nil

        d.newidle = math.random(2)
        mod:spritePlay(sprite, "Idle" .. d.newidle)
        
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 80+d.offset+npc.SubType and d.state == "idle" then
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
        if not d.restartlightning then
            d.lightning = nil
            d.restartlightning = true
        end
        if not d.lightning then
            d.lightning = Isaac.Spawn(1000, 420, 55, npc:GetPlayerTarget().Position, Vector.Zero, npc)
            d.lightning:GetSprite().Scale = d.lightning:GetSprite().Scale * 3
            d.lightning:ToEffect().LifeSpan = 120
        else
            d.lightning:GetData().lightningtimeout = 1000000
        end
    elseif d.state == "boom" then
        d.restartlightning = false
        d.lightning:GetData().lightningtimeout = 30
        mod:spritePlay(sprite, "Boom")
        d.lightning:ToEffect().State = 20
    end

    if d.lightning then

        local child = d.lightning:GetData().lightning

        if child and child:GetData().isLightning and child:GetSprite():IsPlaying("Lightning" .. (child:GetData().lightningtype or 1)) and child:GetSprite():GetFrame() >= 1 and child:GetSprite():GetFrame() <= 4 then
            for k, v in ipairs(Isaac.FindInRadius(d.lightning.Position, 50, EntityPartition.PLAYER)) do
                v:TakeDamage(2, 0, EntityRef(npc), 1)
            end
            for k, v in ipairs(Isaac.FindInRadius(d.lightning.Position, 50, EntityPartition.ENEMY)) do
                v:TakeDamage(0.1, 0, EntityRef(npc), 1)
            end
        elseif  child and child:GetData().isLightning and child:GetSprite():IsPlaying("Lightning" .. (child:GetData().lightningtype or 1)) and child:GetSprite():GetFrame() == 5 then
            d.lightning.Velocity = mod:Lerp(Vector.Zero, (targpos - d.lightning.Position) + (targpos - d.lightning.Position):Normalized()*1.05, Isaac.GetPlayer().MoveSpeed*100/1000)
        elseif child and d.state ~= "boom" then
            d.lightning:MultiplyFriction(0.7)
        elseif npc.StateFrame > 50 and npc.StateFrame < 173 then
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

