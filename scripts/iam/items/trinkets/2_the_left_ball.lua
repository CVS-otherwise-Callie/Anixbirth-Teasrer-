local mod = FHAC
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemConfig = Isaac.GetItemConfig()


function mod:ReplaceItemTheLeftBall(item)
    if mod:AnyPlayerHasTrinket(mod.Collectibles.Trinkets.TheLeftBall) then
    local pedestal = item:ToPickup()
    if pedestal:CanReroll() then
        if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local itemcon = itemConfig:GetCollectible(pedestal.SubType)
        local itemconfig = Isaac.GetItemConfig():GetCollectible(item)
        if itemcon and not itemcon:HasTags(ItemConfig.TAG_QUEST) then
                  if itemconfig.Quality <= 2 then
                      --Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, item.Position, item.Velocity, item)
                      pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.SkeletalFigureReplaceList[rng:RandomInt(1, #mod.SkeletalFigureReplaceList)], true, true, true)
                  end
=            end
        end
    end
    end
end
