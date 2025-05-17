local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Bosses.Skip.Var then
        mod:SkipAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Bosses.Skip.ID)

function mod:SkipAI(npc, sprite, d)

    if not d.init then
        d.state = "Idle"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "Idle" then
        mod:spritePlay(sprite, "Idle")
    end
end