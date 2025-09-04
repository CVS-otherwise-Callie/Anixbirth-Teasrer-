local number = 1

FHAC:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local sData = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
    sData.TravellerBagActives = sData.TravellerBagActives or {}
    if player.QueuedItem and player.QueuedItem.Item and player.QueuedItem.Item.ID 
    and player.QueuedItem.Item.Type == 3 and sData and sData.HasGivenItem == false and player:HasCollectible(FHAC.Collectibles.Items.TravelersBag) then

        sData.TravellerBagActives[#sData.TravellerBagActives + 1] = player.QueuedItem.Item.ID
        sData.HasGivenItem = true
        number = number + 1

        if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) then
            --print(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
        end

        --print("---", sData.HasGivenItem, number, player:GetSprite():GetAnimation(), player:GetActiveItem(ActiveSlot.SLOT_PRIMARY), "---")

    elseif string.find(player:GetSprite():GetAnimation(), "Pickup") == nil then
        sData.HasGivenItem = false
    end
end)

FHAC:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, npc, coll)
    if coll and coll.Type == 1 and coll:ToPlayer():HasCollectible(FHAC.Collectibles.Items.TravelersBag) then
        local player = coll:ToPlayer()

        local sData = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
        sData.TravellerBagActives = sData.TravellerBagActives or {}

        if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == 0 then
            player:AddCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
            player:AddCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY), player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY), false, ActiveSlot.SLOT_SECONDARY, 0)
            player:RemoveCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY), player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY), false, ActiveSlot.SLOT_PRIMARY, 0)
        elseif player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == 0 then
            --sData.TravellerBagActives[#sData.TravellerBagActives + 1]
        end
    end
end)