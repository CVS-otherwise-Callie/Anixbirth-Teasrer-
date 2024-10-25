local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Blank.Var then
        mod:BlankAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Blank.ID)

function mod:BlankAI(npc, sprite, d)

end

