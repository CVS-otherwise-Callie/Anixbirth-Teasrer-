local mod = FHAC
local game = Game()
local rng = RNG()


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.ClatterTeller.Var then
        mod:ClatterTellerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.ClatterTeller.ID)

function mod:ClatterTellerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()

    if not d.init then

        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.state = "idle"

        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame >= 80 then
            d.state = "switch"
        end
    end

    if d.state == "switch" then
        mod:spritePlay(sprite, "Idle_Switch")

        if sprite:IsFinished() then
            npc.StateFrame = 0
            d.state = "chasing"
        end
    end

    if d.state == "chasing" then
        mod:spritePlay(sprite, "Chasing")
        if npc.StateFrame >= 80 then
            d.state = "attack"
        end
    end

    if d.state == "attack" then
        mod:spritePlay(sprite, "Attack")
        if sprite:IsFinished() then
            npc.StateFrame = 0
            d.state = "idle"
        end
    end

end

