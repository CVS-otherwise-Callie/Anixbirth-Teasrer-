local mod = FHAC
local game = Game()
local rng = RNG()

local loglist = {
    {mod.Monsters.Patient.ID, mod.Monsters.Patient.Var, 0.6},
}

function mod:NPCDeathTransform(npc)
    for k, v in ipairs(loglist) do
        for i = 1, #v do
            local l = v[1]
            local t = v[2]
            local g = v[3]
            if l == npc.Type and t == npc.Variant and npc:HasMortalDamage() and math.random(1) > g then
                --mod:MorphOnDeath(npc, mod.Monsters.Log.ID, mod.Monsters.Log.Var, 0, SoundEffect.SOUND_MEAT_JUMPS, g, 2)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.NPCDeathTransform)
