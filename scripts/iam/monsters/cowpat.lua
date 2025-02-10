local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Cowpat.Var then
        mod:CowpatAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Cowpat.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc:GetData().type == "cowpat" then
        mod:CowpatFlyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, EntityType.ENTITY_ATTACKFLY)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.Cowpat.Var then
        mod:CowpatPostAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Cowpat.ID)

function mod:CowpatAI(npc, sprite, d)

    if not d.init then
        d.state = "idle"
        npc.SplatColor = Color(0,0,0,1,55/255,35/255,30/255)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder
    local params = ProjectileParams()

    params.HeightModifier = 20
    params.Variant = ProjectileVariant.PROJECTILE_PUKE
    params.FallingAccelModifier = 0.2
    params.FallingSpeedModifier = -2

    if mod:isScare(npc) then
        if targetpos.X < npc.Position.X then
            sprite.FlipX = false
        else
            sprite.FlipX = true
        end
    else
        if targetpos.X < npc.Position.X then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc:MultiplyFriction(0.8)
        if npc.StateFrame > math.random(25, 45) then
            if npc.Position:Distance(targetpos) < 100 or math.random(3) == 3 then
                d.state = "shoot"
            else
                d.state = "move"
            end
        end
    elseif d.state == "move" then
        mod:spritePlay(sprite, "Move")
    elseif d.state == "shoot" then
        mod:spritePlay(sprite, "Jump")
    end

    if sprite:IsEventTriggered("Push") then

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            path:FindGridPath(targetpos, 0.5, 1, true)
        end 

        if npc.Position:Distance(targetpos) < 5 then
            d.state = "pickup"
        end
        
    elseif sprite:IsEventTriggered("Shoot") then

        npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.5, 1, false, 0.8)

        local num = math.random(0, 90)

        for i = 0, 5 do
            npc:FireProjectiles(npc.Position, Vector(2.7,5):Rotated((60*i+num)), 0, params)
        end

        if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(-3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(2)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.7)
            path:FindGridPath(targetpos, 0.5, 1, true)
        end 

    end

    if sprite:IsFinished("Move") or sprite:IsFinished("Jump") then
        d.state = "idle"
        npc.StateFrame = 0
    end

end

function mod:CowpatPostAI(npc, _,  d)
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local isFlood = (room:GetBackdropType() == BackdropType.DROSS)


    if npc:IsDead() and not d.hasSpawned then

        local fly
        if isFlood then
            fly = Isaac.Spawn(mod.Monsters.GassedFly.ID, mod.Monsters.GassedFly.Var, 0, npc.Position, (Vector(10, 0)):Rotated((target.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20)), npc)
        else
            fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, npc.Position, (Vector(10, 0)):Rotated((target.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20)), npc)
            fly:GetData().type = "cowpat"
        end
        fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        d.hasSpawned = true

    end
end

function mod:CowpatFlyAI(npc, sprite, d)

    npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL

    if not d.Baby then
        d.Baby = mod:GetSpecificEntInRoom({ID = mod.Monsters.Cowpat.ID, Var = mod.Monsters.Cowpat.Var}, npc, 1000)
        d.state = nil
    end

    npc.Mass = 0.1
    sprite.FlipX = false

    local room = game:GetRoom()
    local target = d.Baby

    if target:IsDead() then

        d.Baby = mod:GetSpecificEntInRoom({ID = mod.Monsters.Cowpat.ID, Var = mod.Monsters.Cowpat.Var}, npc, 1000)
        d.state = nil

    else
        d.newpos = target.Position
    end

    if d.specificTargTypeIsPlayer then return end

    d.moveit = d.moveit or 0

    if d.moveit >= 360 then d.moveit = 0 else d.moveit = d.moveit + 0.05 end

    local vel = mod:GetCirc(45, d.moveit)
    if d.state == "circling" then
        npc.Velocity = mod:Lerp(npc.Velocity, Vector(d.newpos.X - vel.X, d.newpos.Y - vel.Y) - npc.Position, 0.1)
    else
        npc.Velocity = mod:Lerp(npc.Velocity,(target.Position - npc.Position):Resized(15), 0.1)
        if npc.Position:Distance(target.Position) < 40 then
            d.state = "circling"
        end
    end

    return
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc:GetData().type == "cowpat" and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        if not npc:GetData().Baby or (not npc:GetData().specificTargTypeIsPlayer and not npc:GetData().Baby:IsDead()) then
            npc:TakeDamage(damage*0.1, flag | DamageFlag.DAMAGE_CLONES, source, 0)
            return false
        end
    end
end, EntityType.ENTITY_ATTACKFLY)
