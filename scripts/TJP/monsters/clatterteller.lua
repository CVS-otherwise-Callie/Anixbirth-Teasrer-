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
            target.Parent = npc
            npc.Child = target
            d.tardat = npc.Child:GetData()
        end

        if sprite:IsFinished() then
            npc.StateFrame = 0
            d.state = "chasing"
            d.tardat_spawned = false
        end
    end

    if d.state == "chasing" then
        mod:spritePlay(sprite, "Chasing")
    end

    if d.state == "attack" then
        if d.delay > 10 then
            if sprite:IsEventTriggered("X attack") then
                if d.deadenemy then
                    local ent = Isaac.Spawn(d.deadenemy.ID, d.deadenemy.Var, d.deadenemy.Sub, d.deadenemy.Pos, d.deadenemy.Vel, d.deadenemy.Par)
                    ent:Kill()
                else
                    npc:FireProjectiles(d.tardat.effectpos, Vector(1,1), 7, tear)
                end
            end
            mod:spritePlay(sprite, "Attack")
            if sprite:IsFinished() then
                npc.StateFrame = 0
                d.state = "idle"
            end
        else
            d.delay = d.delay + 1
        end
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

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function (_, npc)
    if npc:IsDead() then
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            mod.scheduleCallback(function()
                if v.Type == 161 and v.Variant == mod.Monsters.ClatterTeller.Var and not v:IsDead() and v.StateFrame > 80 then
                    d.delay = 0
                    d.deadenemy = {ID = npc.ID, Var = npc.Variant, Sub = npc.SubType, Pos = npc.Position, Vel = npc.Velocity, Par = npc.Parent}
                    d.state = "attack"
                end
            end, (k-1)*10, ModCallbacks.MC_NPC_UPDATE)     
        end
    end
end)
