local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedWebMother.Var then
        mod:TaintedWebMotherAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedWebMother.ID)

function mod:TaintedWebMotherAI(npc, sprite, d)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        d.state = "idle"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        print("tainteddd")
    end

end

--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
--    if npc.Type == mod.Monsters.TaintedWebMother.ID and npc.Variant == mod.Monsters.TaintedWebMother.Var and npc.HitPoints - dmg <= 0 then
--        npc:GetData().state = "dead"
--        return false
--    end
--end, 161)