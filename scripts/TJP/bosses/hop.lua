local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Bosses.Hop.Var then
        mod:HopAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Bosses.Hop.ID)

function mod:HopAI(npc, sprite, d)
    mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/hopperbrothers/hop", 0)

    if not d.init then

        d.init = true
        d.attacktimer = 134
        d.state = "idle"
    else
        npc.StateFrame = npc.StateFrame + 1
        d.attacktimer = d.attacktimer + 1
    end

    if d.attacktimer == 201 then
        d.attacktimer = 0
        d.attack = true
    else
        d.attack = false
    end

    if d.state == "idle" then
        print("hop")
        mod:spritePlay(sprite, "Idle")
        if d.attack then
            npc.Velocity = Vector(10, 10):Rotated(math.random(0,360))
        else
            npc:MultiplyFriction(0.8)
        end
    end
end