local mod = FHAC
local game = Game()
local sfx = SFXManager()

FHAC.BreakablePot = StageAPI.CustomGrid("FHACBreakablePot", {
    BaseType = GridEntityType.GRID_POOP,
    BaseVariant = 0,
    Anm2 = "gfx/grid/breakablepot.anm2",
    Animation = "Appear",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2902}
})

function mod.breakablePotAI(customGrid)

    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    local tab = {
        {{PickupVariant.PICKUP_KEY, 2}, {PickupVariant.PICKUP_COIN, 2}, {PickupVariant.PICKUP_BOMB, 2}}
    }

    if not d.init then
        d.init = true
        d.num = math.random(3)
        d.mytab = tab[math.random(#tab)]
    end

    mod:spritePlay(sprite, sprite:GetDefaultAnimation())


end

function mod.breakablePotRewardAI(customGrid)

    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    local function SpawnCoins() --bc of a oddly specific bug
        Isaac.Spawn(5, 20, 0, grid.Position, RandomVector()*math.random(2,5), nil)
    end

    if d.hasSpawned then return end

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

StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_DESTROY", 1, mod.breakablePotRewardAI, "FHACBreakablePot")
StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.breakablePotAI, "FHACBreakablePot")
