local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pill, player, flags)
    if flags ~= flags | UseFlag.USE_OWNED and flags ~= flags | UseFlag.USE_ALLOWNONMAIN and flags ~= flags | UseFlag.USE_MIMIC then
        if player:ToPlayer():GetHearts() < player:ToPlayer():GetHeartLimit() and player:GetHearts() ~= 0 then
            player:AddHearts(1)
        elseif player:GetHearts() == 0 then
            player:AddSoulHearts(1)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, bool)
    rng:SetSeed(pickup.InitSeed, 32)
    local chosenum = rng:RandomInt(100)
    if pickup.Variant == PickupVariant.PICKUP_HEART and coll.Type == 1 then
        if chosenum > 75 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, Game():GetRoom():FindFreePickupSpawnPosition(coll.Position, 40,true), Vector.Zero, nil)
        end
    end
end)