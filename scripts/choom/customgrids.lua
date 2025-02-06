--[[local mod = FHAC
local game = Game()
local sfx = SFXManager()

FHAC.BoxGrid = StageAPI.CustomGrid("FHACBox", {
    BaseType = GridEntityType.GRID_ROCKB,
    BaseVariant = 0,
    Anm2 = "gfx/grid/box.anm2",
    Animation = "box1",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2902}
})

function mod.BoxCashout(customGrid)

    print("fukyou")

    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    mod:spritePlay(sprite, "box1")

    local tab = {
        {{PickupVariant.PICKUP_KEY, 2}, {PickupVariant.PICKUP_COIN, 2}, {PickupVariant.PICKUP_BOMB, 2}}
    }

    if not d.init then
        d.init = true
        d.mytab = tab[math.random(#tab)]
    end

    local function SpawnCoins() --bc of a oddly specific bug
        Isaac.Spawn(5, 20, 0, grid.Position, RandomVector()*math.random(2,5), nil)
    end

    if grid.State == 2 and not d.hasSpawned then
        for k, v in ipairs(d.mytab) do
            for i = 1, v[2] do
                if v[2] == 20 then
                    Isaac.Spawn(5, 20, 0, grid.Position, RandomVector()*math.random(2,5), nil)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, v[1], 0, grid.Position, RandomVector()*math.random(2,5), nil)
                end
            end
        end
        d.hasSpawned = true
        SpawnCoins()
    end
end

StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.BoxCashout, "FHACBox")]]
