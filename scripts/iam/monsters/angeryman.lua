local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.AngeryMan.Var then
        mod:AngerymanAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.AngeryMan.ID)

function mod:AngerymanAI(npc, sprite, d)

    if not d.init then
        d.state = "stuck"
        d.stuckdegradeNum = 0
        d.init = true
    end

    if d.state == "stuck" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        if d.stuckdegradeNum > 20 then
            d.state = "idle"
        end
    end



end

function mod:AngeryManTakeDamage(npc, damage, flag, source)
    if npc.Type == mod.Monsters.AngeryMan.ID and npc.Variant == mod.Monsters.AngeryMan.Var then
        if npc:GetData().state == "stuck" then
            npc:GetData().stuckdegradeNum = npc:GetData().stuckdegradeNum + damage
            return false
        end
    end
end

