local mod = FHAC
local game = Game()
local rng = RNG()

local attacks = {
    {"brimstone", 15},
    {"summon", 30},
    {"chase", 35},
}

local attacks2 = {
    {"brimstone", 10},
    {"summon", 20},
    {"summonbabies", 50},
    {"teleport", 40},
}

local spawn = {
    {EntityType.ENTITY_MOMS_HEART, 1},
    {EntityType.ENTITY_THE_LAMB, 0},
    {EntityType.ENTITY_SATAN, 0},
    {EntityType.ENTITY_ISAAC, 0},
    {EntityType.ENTITY_ISAAC, 1},
}

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.MiniBosses.Sam.Var then
        mod:SamMinibossAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.MiniBosses.Sam.ID)

function mod:SamMinibossAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        d.state = "idle"
        d.waitTime = 0
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end
    

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc.Velocity = Vector.Zero
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        local choice
        if npc.HitPoints <= (npc.MaxHitPoints / 2) then
            choice = attacks2
        else
            choice = attacks
        end
        if npc.StateFrame > d.waitTime then
            d.state = mod:GetNextAttack(choice)
            if d.brim and 
            d.brim:Exists() and 
            not d.brim:IsDead() then
                d.brim:Remove()
            end
            d.waitTime = math.random(100, 200)
            npc.StateFrame = 0
        end
    elseif d.state == "chase" then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        mod:spritePlay(sprite, "Walk")
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        else
            path:FindGridPath(targetpos, (0.5+(7/3))*0.7, 900, true)
        end
        if npc.StateFrame > d.waitTime then
            d.state = "idle"
            d.waitTime = math.random(20, 40)
            npc.StateFrame = 0
        end
    elseif d.state == "summon" then
        mod:spritePlay(sprite, "IdleBounce")

        local function GetSummonable()
            local choice = spawn[math.random(#spawn)]

            local function MakeSureYouCanSpawnSomething()
                for k, v in ipairs(spawn) do
                    if #Isaac.FindByType(choice[1], choice[2]) == 0 then
                        return true
                    end
                end
            end

            if not MakeSureYouCanSpawnSomething() then return false end

            if #Isaac.FindByType(choice[1], choice[2]) ~= 0 then
                return GetSummonable()
            else
                return choice
            end
        end

        if sprite:IsFinished("IdleBounce") then
            local choice = GetSummonable()
            if choice then
                Isaac.Spawn(choice[1], choice[2], 0, npc.Position, Vector.Zero, npc)
            end
            d.state = "idle"
            d.waitTime = math.random(20, 40)
            npc.StateFrame = 0
        end
    elseif d.state == "brimstone" then
        mod:spritePlay(sprite, "IdleBounce")
        if sprite:IsFinished("IdleBounce") then
            local brim = Isaac.Spawn(7,1,0,npc.Position, Vector.Zero, npc):ToLaser()
            brim.PositionOffset = Vector(0, -26)
            brim.SpawnerEntity = npc
            brim.Parent = npc
            brim.Angle = (npc:GetPlayerTarget().Position - npc.Position):GetAngleDegrees()
            brim:SetTimeout(10000)
            d.brim = brim
            d.state = "idle"
            d.waitTime = math.random(20, 40)
            npc.StateFrame = 0
        end
    elseif d.state == "teleport" then
        if not d.teleportStart then
            mod:spritePlay(sprite, "TeleportUp")
            d.teleportStart = true
        end
        if sprite:IsFinished("TeleportUp") then
            npc.Position = npc:GetPlayerTarget().Position
            mod:spritePlay(sprite, "TeleportDown")
        end
        if sprite:IsFinished("TeleportDown") and npc.StateFrame > 5 then
            d.teleportStart = false
            d.state = "idle"
            d.waitTime = math.random(20, 40)
            npc.StateFrame = 0
        end
    elseif d.state == "summonbabies" then
        mod:spritePlay(sprite, "IdleBounce")
        if sprite:IsFinished("IdleBounce") then
            for i = 1, 3 do
                Isaac.Spawn(mod.Monsters.SamBabies.ID, mod.Monsters.SamBabies.Var, 0, npc.Position, Vector.Zero, npc)
            end
            d.state = "idle"
            d.waitTime = math.random(20, 40)
            npc.StateFrame = 0
        end
    end

end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SamBabies.Var then
        mod:SamBabiesAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SamBabies.ID)

function mod:SamBabiesAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if mod:isScare(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(-7)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
    elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
        local targetvelocity = (targetpos - npc.Position):Resized(7)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
    else
        path:FindGridPath(targetpos, (0.5+(7/3))*0.7, 900, true)
    end

    if d.isDying then
        mod:spritePlay(sprite, "Death")

        if sprite:IsFinished("Death") then
            npc:Remove()
        end
    else
        sprite:Play("Idle")
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type == mod.Monsters.SamBabies.ID and npc.Variant == mod.Monsters.SamBabies.Var and npc.HitPoints - damage <= 0 then
        npc:GetData().isDying = true
        return false
    elseif not npc:GetData().isDying and damage >= 3.5 and npc.Type == mod.Monsters.SamBabies.ID and npc.Variant == mod.Monsters.SamBabies.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        npc:TakeDamage(3.5, flag | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end, mod.Monsters.SamBabies.ID)
