local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Roach.Var then
        mod:RoachAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Roach.ID)

function mod:RoachAI(npc, sprite, d)
    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        d.init = true
        d.state = "spawned"
        d.turndir = math.random(-12,12)
        if d.turndir == 0 then
            d.turndir = 1
        end
    end

    if npc.HitPoints <= 0 then
        npc.HitPoints = 1
    end

    if d.state == "spawned" then
        mod:spritePlay(sprite, "Appear")
        if sprite:IsFinished() then
            npc.Velocity = Vector(4,0):Rotated(math.random(0,360))
            d.state = "skuttle"
        end
    end

    if d.state == "skuttle" then
        if npc.Velocity.Y < 0 then
            d.facinganim = "Up"
        else
            d.facinganim = "Down"
        end
        npc:AnimWalkFrame("Hori", d.facinganim, 0)

        if math.random(1,20) == 1 then
            d.turndir = math.random(3,12)*-(d.turndir/math.abs(d.turndir))
        end

        npc.Velocity = npc.Velocity:Rotated(d.turndir):Resized(4)
    end

    if d.state == "dead" then
        npc.GridCollisionClass = 0
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "Death")
        if sprite:IsEventTriggered("blood") then
            game:SpawnParticles ( npc.Position, 5, 5, 5, Color(1,0,0,0), 10, 0 )

        end
        if sprite:IsFinished() then
            npc:Remove()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Roach.Var and npc.HitPoints - dmg <= 0 then
        npc:GetData().state = "dead"
        return false
    end
end, 161)