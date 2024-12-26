local mod = FHAC
local game = Game()
local rng = RNG()

local loglist = {
    {EntityType.ENTITY_GAPER, 0, 0.5},
    {EntityType.ENTITY_GUSHER, 0, 0.9},
    {EntityType.ENTITY_GUSHER, 1, 0.9},
    {EntityType.ENTITY_FATTY, 0, 0.4},
    {mod.Monsters.Patient.ID, mod.Monsters.Patient.Var, 0.6},
    {EntityType.ENTITY_CYCLOPIA, 0, 0.6},
    {EntityType.ENTITY_FACELESS, 0, 1},
    {EntityType.ENTITY_HOPPER, 0, 0.5},
    {EntityType.ENTITY_GEMINI, 0, 1},
    {EntityType.ENTITY_BOUNCER, 0, 0.9},
    {EntityType.ENTITY_DANNY, 0, 0.9},
    {EntityType.ENTITY_LEAPER, 0, 0.7},
    {EntityType.ENTITY_VIS, 0, 0.6},
    {EntityType.ENTITY_SKINNY, 0, 0.9},
}

function mod:NPCDeathTransform(npc)
    for k, v in ipairs(loglist) do
        for i = 1, #v do
            local l = v[1]
            local t = v[2]
            local g = v[3]
            if l == npc.Type and t == npc.Variant and npc:HasMortalDamage() then
                mod:MorphOnDeath(npc, mod.Monsters.Log.ID, mod.Monsters.Log.Var, 0, SoundEffect.SOUND_MEAT_JUMPS, g, 2)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.NPCDeathTransform)
