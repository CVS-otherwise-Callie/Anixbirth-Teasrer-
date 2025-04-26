local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SackKid.Var then
        mod:SackKidAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SackKid.ID)

function mod:SackKidAI(npc, sprite, d)

    if not d.init then
        d.init = true
    end

end

