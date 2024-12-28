local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Stoner.Var then
        mod:StonerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Stoner.ID)

function mod:StonerAI(npc, sprite, d)

    local room = game:GetRoom()

    mod:SaveEntToRoom({
        Name="Stoner",
        NPC = npc,
    })

    if not d.init then
        d.face = d.face or math.random(430)
        sprite:SetFrame("Idle", d.face)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        npc:MultiplyFriction(0.6)
    end

    ---@param plate GridEntity
    local function ActivePressurePlate(plate) --thanks kerkel!!!!
        if plate.State ~= 0 then return end
        sfx:Play(469, 1, 0, false, 1, 0)

        plate.State = 3
        plate:GetSprite():Play("Switched", true)
        plate:ToPressurePlate():Reward()
    end


    for i = 0, room:GetGridSize() do 
        if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 then
            --print(room:GetGridEntity(i):ToPressurePlate().State, room:GetGridEntity(i):GetVariant())
            if npc.Position:Distance(room:GetGridEntity(i).Position) < 35 then
                local grid = Game():GetRoom():GetGridEntityFromPos(npc.Position)

                if grid and grid:GetType() == GridEntityType.GRID_PRESSURE_PLATE and grid.VarData ~= 20 then
                    print("sure")
                    ActivePressurePlate(grid)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.Stoner.ID and npc.Variant == mod.Monsters.Stoner.Var then
        return false
    end
end, mod.Monsters.Stoner.ID)


