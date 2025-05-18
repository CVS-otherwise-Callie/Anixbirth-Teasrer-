local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Bosses.Jump.Var then
        mod:JumpAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Bosses.Jump.ID)

function mod:JumpAI(npc, sprite, d)

    if not d.init then
        d.state = "Idle"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "Idle" then
        mod:spritePlay(sprite, "Idle")
    end
end