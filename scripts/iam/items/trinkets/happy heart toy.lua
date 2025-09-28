local mod = FHAC
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemConfig = Isaac.GetItemConfig()


function mod:ReplaceHeartHeartToy(item)
    if mod:AnyPlayerHasTrinket(mod.Collectibles.Trinkets.HappyHeartToy) then
        local heart = item:ToPickup()
        rng:SetSeed(item.InitSeed, 32)

        if rng:RandomInt(1, 4) > 2 then

            if rng:RandomInt(1, 3) == 3 then
                if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_HEART and item.SubType == HeartSubType.HEART_FULL then
                    item:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK)
                end
            end

            if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_HEART and item.SubType == HeartSubType.HEART_HALF then
                item:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF-1)
            elseif item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_HEART and item.SubType == HeartSubType.HEART_HALF_SOUL then
                item:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL-1)
            end
        end
    end
end
