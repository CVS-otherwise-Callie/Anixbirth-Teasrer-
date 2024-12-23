local mod = FHAC
local game = Game()
local rng = RNG()

local loglist = {
    {EntityType.ENTITY_GAPER, 0},
    {EntityType.ENTITY_GUSHER, 0},
    {EntityType.ENTITY_FATTY, 0},
    {mod.Monsters.Patient.ID, mod.Monsters.Patient.Var},
    {EntityType.ENTITY_CYCLOPIA, 0}
}

function mod:NPCDeathTransform(npc)
    for k, v in ipairs(loglist) do
        for i = 1, #v do
            local l = v[1]
            local t = v[2]
            if l == npc.Type and t == npc.Variant and npc:HasMortalDamage() then
                mod:MorphOnDeath(npc, mod.Monsters.Log.ID, mod.Monsters.Log.Var, 0, SoundEffect.SOUND_MEAT_JUMPS, 0.4, 2)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.NPCDeathTransform)
