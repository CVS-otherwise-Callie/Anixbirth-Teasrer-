local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dunglivery.Var then
        mod:DungliveryAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dunglivery.ID)

function mod:DungliveryAI(npc, sprite, d)

    if not d.init then
        d.state = "idle"
        d.init = true
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc:MultiplyFriction(0.1)
    end
end

