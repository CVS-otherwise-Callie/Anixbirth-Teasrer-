local game = Game()
local mod = FHAC

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.NPCS.Scannard.Var then
        mod:scannard(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.NPCS.RuinNPC.ID)

function mod:scannard(npc, sprite, d)
    if not d.init then
        print("marvelous")
        d.init = true
    end
end

mod.onNPCTouch("Scannard", function(player, npc)
    print("yesss")
end)