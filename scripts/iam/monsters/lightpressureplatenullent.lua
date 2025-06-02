local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Type == mod.Monsters.LightPressurePlateEntNull.ID and npc.Variant == mod.Monsters.LightPressurePlateEntNull.Var then
        mod:LightPressurePlateEntNullAI(npc, npc:GetSprite(), npc:GetData())
    end
end)

local function FidnPlate(d)
    local room = game:GetRoom()
    local dist = 9999999
    local pick 
    for i = 0, room:GetGridSize() do
        if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 and room:GetGridEntity(i).Position:Distance(d.specificgird) < dist and room:GetGridEntity(i).VarData ~= 20 then
            dist = room:GetGridEntity(i).Position:Distance(d.specificgird)
            pick = room:GetGridEntity(i)
        end
    end
    return pick
end

function mod:LightPressurePlateEntNullAI(npc, sprite, d)

    local room = game:GetRoom()

    if not d.init then

        for i = 0, room:GetGridSize() do
            if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 and room:GetGridEntity(i).VarData == 19 then
                game:GetRoom():RemoveGridEntity(i, 0, false)
            end
        end

        npc:AddEntityFlags( EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
        if d.wasSpawned then
            npc.Visible = false
        end
        d.specificgird = mod:freeGrid(npc, false, 10000, 0)
        npc.Position = d.specificgird
        d.init = true
    end

    d.ent = FidnPlate(d)

    if d.ent then

        if not d.entinit then
            d.ent.State = 0
            d.entinit = true
        end

        --d.ent:GetSprite().Scale = Vector(0, 0)
        d.ent.CollisionClass = GridCollisionClass.COLLISION_NONE
        d.ent.VarData = 19
    else
        Isaac.GridSpawn(20, 0, d.specificgird, false)
    end

    local function AllPressuredButtonsCleared()
        for i = 0, room:GetGridSize() do 
            if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 and room:GetGridEntity(i).VarData == 20 then
                if room:GetGridEntity(i).State ~= 1 then
                    for i = 0, 8 do
                        local doorL = game:GetRoom():GetDoor(i)
                        if not (doorL == nil) then doorL:Close(true) end
                    end
                    if d.ent then
                        d.ent.State = 0
                        d.ent:GetSprite():Play("Off")
                    end
                    return false
                end
            end
        end
        return true
    end

    if AllPressuredButtonsCleared() and d.wasSpawned then
        if d.ent and d.ent.VarData == 19 then
            d.ent.State = 3
            game:GetRoom():RemoveGridEntity(game:GetRoom():GetGridIndex(d.ent.Position), 0, false)
        end
    end
end