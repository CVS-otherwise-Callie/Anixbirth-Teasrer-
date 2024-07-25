local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Patient.Var then
        mod:PatientAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Patient.ID)

function mod:PatientAI(npc, sprite, d)

end

