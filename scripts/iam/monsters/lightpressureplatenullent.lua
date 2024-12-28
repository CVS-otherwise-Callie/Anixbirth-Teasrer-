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
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
        if d.wasSpawned then
            npc.Visible = false
        end
        npc.Position = Vector(-200, -200)
        d.init = true
    end

    local function AllPressuredButtonsCleared()
        for i = 0, room:GetGridSize() do 
            if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 and room:GetGridEntity(i).VarData == 20 then
                if room:GetGridEntity(i).State ~= 1 then
                    npc.CanShutDoors = true
                    for i = 0, 8 do
                        local doorL = game:GetRoom():GetDoor(i)
                        if not (doorL == nil) then doorL:Close(true) end
                    end
                    return
                end
            end
        end
        npc.CanShutDoors = false
        npc:Remove()
    end

    AllPressuredButtonsCleared()
end

