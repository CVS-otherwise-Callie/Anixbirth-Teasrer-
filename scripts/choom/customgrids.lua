local mod = FHAC
local game = Game()
local sfx = SFXManager()

FHAC.LightPressurePlate = StageAPI.CustomGrid("FHACBox", {
    BaseType = GridEntityType.GRID_ROCKB,
    BaseVariant = 0,
    Anm2 = "gfx/grid/box.anm2",
    Animation = "box1",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2902}
})

function mod.BoxCashout(customGrid)
    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData
    local tab = {
{{PickupVariant.PICKUP_KEY, 2}, {PickupVariant.PICKUP_COIN, 2}}
    }
       if not d.init then
        d.init = true
        d.mytab = tab[math.random(#tab)]
        end
end 
if grid.State == 2 then|
  for k, v in ipairs(d.mytab)
     for i = 1, v[2]-1 do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, v[1], -1, grid.Position, RandomVector()*math.random(2,5), nil)
     end
    end
end
StageAPI.AddCallback("FHAC", "POST_SPAWN_CUSTOM_GRID", 1, mod.BoxCashout, "FHACBox")