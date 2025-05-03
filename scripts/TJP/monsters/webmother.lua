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

        d.randomtimer = 5
        d.childrennumber = 0
        d.children = {}
        d.childrendata = {}
        d.init = true
        d.state = "idle"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    --for num, child in pairs(d.children) do
    --    print(child.Parent)
    --end

    if d.state == "idle" then
        mod:spritePlay(sprite,"Idle")
        if npc.StateFrame > d.randomtimer then
            if math.random(1,5-d.childrennumber) == 1 and d.childrennumber > 0 then
                print("cmere")
                d.childrennumber = 0
            else
                d.weblet = Isaac.Spawn(mod.Monsters.Weblet.ID, mod.Monsters.Weblet.Var, mod.Monsters.Weblet.Sub, npc.Position, Vector.Zero, npc)
                d.weblet.Parent = npc
                d.webletdata = d.weblet:GetData()
                print(d.weblet)
                print(d.webletdata.Initseed)
                table.insert(d.children, d.webletdata)
                d.childrennumber = d.childrennumber+1

            end
            d.randomtimer = 100000000
            npc.StateFrame = 0
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
            --13 207 300 418!!!       316 for weblet
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