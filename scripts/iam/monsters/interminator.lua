local mod = FHAC
local game = Game()
local rng = RNG()

function mod:InterminatorAI(npc, sprite, d)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if sprite:IsFinished("Summon") then
        sprite:Play("Idle")
    end

    if sprite:IsEventTriggered("Summon") then
        local ghost = Isaac.Spawn(mod.Effects.InterminatorGhost.ID, mod.Effects.InterminatorGhost.Var, 0, mod:freeGrid(npc, false, 300, 0), Vector.Zero, npc)
        ghost:GetData().Target = npc:GetPlayerTarget()
    end

end

function mod:InterminatorDeathAI(npc)
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == mod.Monsters.Interminator.ID and v.Variant == mod.Monsters.Interminator.Var then
            mod:spritePlay(v:GetSprite(), "Summon")
        end
    end
end

