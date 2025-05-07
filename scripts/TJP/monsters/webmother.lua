local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.WebMother.Var then
        mod:WebMotherAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.WebMother.ID)

function mod:WebMotherAI(npc, sprite, d)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        if npc.SubType == 0 then
            npc.SubType = math.random(1, 3)
        end

        d.comeback = false
        d.randomtimer = math.random(50,100)
        d.webletgroupsamount = 0
        d.children = {}
        d.init = true
        d.state = "idle"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite,"Idle")
        if npc.StateFrame > d.randomtimer then

            if math.random(1,5-d.webletgroupsamount) == 1 and d.webletgroupsamount > 0 then
                d.state = "scream"
            else
                for i = 1, npc.SubType do
                    local weblet = Isaac.Spawn(mod.Monsters.Weblet.ID, mod.Monsters.Weblet.Var, mod.Monsters.Weblet.Sub, npc.Position, Vector.Zero, npc)
                    weblet.Parent = npc
                    table.insert(d.children, weblet)
                end
                d.webletgroupsamount = d.webletgroupsamount+1
            end
            d.randomtimer = math.random(100,200)
            npc.StateFrame = 0
        end
    end

    if d.state == "scream" then
        mod:spritePlay(sprite,"Scream")
        if sprite:IsEventTriggered("Recall") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_B, 1, 2, false, 1)
            d.comeback = true
        end
        if sprite:IsFinished() then
            d.state = "waiting"
        end
    end

    if d.state == "waiting" then
        local canrestart = true
        mod:spritePlay(sprite,"Idle")
        if #(d.children) > 0 then
            for i = 1, #(d.children) do
                if not d.children[i]:IsDead() and d.children[i]:Exists() then
                    canrestart = false
                end
            end
        end
        if canrestart then
            npc.StateFrame = 0
            d.randomtimer = math.random(75,100)
            d.webletgroupsamount = 0
            d.children = {}
            d.comeback = false
            d.state = "idle"
        end
    end

    if d.state == "dead" then
        if not d.scream then
            npc:PlaySound(SoundEffect.SOUND_THE_FORSAKEN_SCREAM, 1, 2, false, 1.5)
            d.scream = true
        end
        npc.GridCollisionClass = 0
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "Death")
        if sprite:IsEventTriggered("Blood") then
            game:SpawnParticles ( npc.Position, 7, 3, 4, Color.Default, 10, 0 )
            game:SpawnParticles ( npc.Position, 77, 1, 0, Color.Default, 10, 0 )
            game:SpawnParticles ( npc.Position, 5, 5, 5, Color.Default, 10, 0 )
            npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 2, false, 1.5)
        end
        if sprite:IsFinished() then
            npc:Remove()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.WebMother.Var and npc.HitPoints - dmg <= 0 then
        npc:GetData().state = "dead"
        return false
    end
end, 161)