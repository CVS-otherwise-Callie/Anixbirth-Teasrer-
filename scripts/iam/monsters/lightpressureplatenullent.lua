local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.LightPressurePlateEntNull.Var then
        mod:LightPressurePlateEntNullAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LightPressurePlateEntNull.ID)

function mod:LightPressurePlateEntNullAI(npc, sprite, d)

    local room = game:GetRoom()

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER| EntityFlag.FLAG_NO_QUERY)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        if d.wasSpawned then
            npc.Visible = false
        end
        d.init = true
    end

    local function AllPressuredButtonsCleared()
        for i = 0, room:GetGridSize() do 
            if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 and room:GetGridEntity(i).VarData == 20 then
                if room:GetGridEntity(i).State ~= 1 then
                    npc.CanShutDoors = true
                    return
                end
            end
        end
        npc.CanShutDoors = false
    end

    AllPressuredButtonsCleared()

    npc.Position = Vector(-200, -200)

end

