local mod = FHAC
local game = Game()
local rng = RNG()


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.ClatterTeller.Var then
        mod:ClatterTellerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.ClatterTeller.ID)

function mod:ClatterTellerAI(npc, sprite, d)
    local tear = ProjectileParams()
    local myawesomepurplecolor = Color(1,1,1,1,0.3,0,0.6)
    myawesomepurplecolor:SetColorize(1,1,1,1)
    tear.Color = myawesomepurplecolor
    tear.VelocityMulti = 7
    tear.FallingSpeedModifier = 1.5

    d.playerpos = npc:GetPlayerTarget().Position
    d.stateframe = npc.StateFrame

    if d.tardat and npc.Child then
            d.tardat = npc.Child:GetData()
    end

    --[[d.order = 0
    for _, enemy in ipairs(Isaac.FindInRadius(npc.Position, 999, EntityPartition.ENEMY)) do
        if enemy.Variant == npc.Variant then
            if GetPtrHash(enemy) ~= GetPtrHash(npc) then
                if GetPtrHash(enemy) < GetPtrHash(npc) then
                    d.order = d.order + 1
                end
            end
        end
    end]]

    if not d.init then

        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.blacListents = {}
        d.state = "idle"

        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame >= 40 then
            d.state = "switch"
        end
    end

    if d.state == "switch" then
        mod:spritePlay(sprite, "Idle_Switch")

        if sprite:IsEventTriggered("target") then
            npc.StateFrame = 0
            d.target = Isaac.Spawn(1000, 425, 55, npc.Position, npc.Velocity, npc):ToEffect()
            d.target.Parent = npc
            npc.Child = d.target
            d.tardat = npc.Child:GetData()
        end

        if sprite:IsFinished() then
            npc.StateFrame = 0
            d.state = "chasing"
        end
    end

    if d.state == "chasing" then
        mod:spritePlay(sprite, "Chasing")
    end

    if d.state == "attack" then
        if d.delay > 10 then
            if sprite:IsEventTriggered("X attack") then
                if d.deadenemy then
                    print("h")
                    local ent = Isaac.Spawn(d.deadenemy.Type, d.deadenemy.Variant, d.deadenemy.SubType, d.target.Position, d.deadenemy.Velocity, d.deadenemy.Parent)
                    ent:GetData().isClatterTellerKilled = true
                    table.insert(d.blacListents, ent.InitSeed)
                    ent:Kill()
                else
                    npc:FireProjectiles(d.tardat.effectpos, Vector(1,1), 7, tear)
                end
            end
            mod:spritePlay(sprite, "Attack")
            if sprite:IsFinished() then
                npc.StateFrame = 0
                d.deadenemy = nil
                d.state = "idle"
            end
        else
            d.delay = d.delay + 1
        end
    end

    if not d.target or d.target:IsDead() or not d.target:Exists() then
        d.target = nil
    end

end

--[[function FindDeadEnemyName(npc)
    for _, enemy in ipairs(Isaac.FindInRadius(npc.Position, 999, EntityPartition.ENEMY)) do
        if enemy:IsDead() then

            

            if enemy.Type == 25 and enemy.Variant == 0 then
                return "Boom Fly"
            else
                return "no death effect"
            end
        end
    end
    return "none"
end]]

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function (_, npc)
    if npc:IsDead() and npc:GetData().isClatterTellerKilled == nil then
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            local d = v:GetData()
            mod.scheduleCallback(function()
                if v.Type == 161 and v.Variant == mod.Monsters.ClatterTeller.Var and not v:IsDead() and d.target and d.blacListents and not mod:CheckTableContents(d.blacListents, npc.InitSeed) then
                    d.delay = 0
                    d.deadenemy = npc --{ID = npc.Type, Var = npc.Variant, Sub = npc.SubType, Pos = npc.Position, Vel = npc.Velocity, Par = npc.Parent, Dat = npc:GetData()}
                    table.insert(d.blacListents, npc.InitSeed)
                    d.state = "attack"
                end
            end, (k-1)*10, ModCallbacks.MC_NPC_UPDATE)     
        end
    end
end)]]

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function (_, npc)


    if npc:HasMortalDamage() and npc:GetData().isClatterTellerKilled == nil then
        local count = 1
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 161 and v.Variant == mod.Monsters.ClatterTeller.Var then
                ClatterTellerDeathThingy(npc, k, v, count)
                count = count + 1
            end
        end
    end
end)

function ClatterTellerDeathThingy(npc, k, v, count)
    local d = v:GetData()
    mod.scheduleCallback(function()
        if v.Type == 161 and v.Variant == mod.Monsters.ClatterTeller.Var and not v:IsDead() and d.target and d.blacListents then
            print(not mod:CheckTableContents(d.blacListents, npc.InitSeed) , not CheckIfSchmootRollin(npc) , npc:GetData().ClatterTellerHighPriority , npc:GetData().ClatterTellerLowPriority)
            if not mod:CheckTableContents(d.blacListents, npc.InitSeed) and not CheckIfSchmootRollin(npc) and (npc:GetData().ClatterTellerHighPriority or npc:GetData().ClatterTellerLowPriority) then
                d.deadenemy = npc --{ID = npc.Type, Var = npc.Variant, Sub = npc.SubType, Pos = npc.Position, Vel = npc.Velocity, Par = npc.Parent, Dat = npc:GetData()}
            end
            d.delay = 0
            table.insert(d.blacListents, npc.InitSeed)
            d.state = "attack"
        end
    end, (count-1)*10, ModCallbacks.MC_NPC_UPDATE)
end

function CheckIfSchmootRollin(npc)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Schmoot.Var and npc:GetData().secondinit then
        return true
    end
end
