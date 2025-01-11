local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        mod:BlankAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LarryKingJr.ID)

function mod:BlankAI(npc, sprite, d)

    if not d.init then
        d.init = true
    end

end

