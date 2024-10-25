local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Cuber.Var then
        mod:CuberAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Cuber.ID)

function mod:CuberAI(npc, sprite, d)

end

