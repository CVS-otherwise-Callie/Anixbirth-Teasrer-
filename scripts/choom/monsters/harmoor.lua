local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Harmoor.Var then
        mod:HarmoorAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Harmoor.ID)

function mod:HarmoorAI(npc, sprite, d)


    if not d.init then
        d.myvar = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

        if d.state == "idle" then
        if npc.StateFrame > 100 then
        d.state = "spawn"
        end
    elseif d.state == "spawn" then

        Isaac.Spawn(EntityType.ENTITY_CHARGER, 1, 0, npc.Position, Vector.Zero, npc)

        npc.StateFrame = 0
        d.state = "idle"
        print(elo zelo)
    end
end