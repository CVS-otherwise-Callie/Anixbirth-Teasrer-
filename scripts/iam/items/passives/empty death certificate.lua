local mod = FHAC
local game = Game()

--thanks fiend folio for allowing me to save my sanituy :D
local perthrod = perthrod or false
local actived = actived or false
local certActivated = certActivated or false

local bedenHit = bedenHit or false

local missingnod = missingnod or false
local missingnod2 = missingnod2 or false

local diceroom = diceroom or false

local blockActives = {
    {CollectibleType.COLLECTIBLE_D6, 6},
    {CollectibleType.COLLECTIBLE_ETERNAL_D6, 2},
    {CollectibleType.COLLECTIBLE_D100, 6},
    {CollectibleType.COLLECTIBLE_LEMEGETON, 6},
    {CollectibleType.COLLECTIBLE_D4, 6},
    {CollectibleType.COLLECTIBLE_D_INFINITY, 2}, --jesus
    {CollectibleType.COLLECTIBLE_D_INFINITY, 3},
    {CollectibleType.COLLECTIBLE_D_INFINITY, 4},
    {CollectibleType.COLLECTIBLE_D_INFINITY, 6},
}

--pocket items that stop rerolling when used
local blockPockets = {
    Card.RUNE_PERTHRO,
    Card.CARD_DICE_SHARD,
    Card.CARD_REVERSE_WHEEL_OF_FORTUNE
}

mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, function(_, c, pt, d, s)
	for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1):ToPlayer()

        if player:HasCollectible(mod.Collectibles.Items.EmptyDeathCertificate) then
            --Keep this as mystery gift, can be replaced for funnies
            local replacedItem = CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE
            --replacedItem = 628
            if certActivated or actived or perthrod or bedenHit or missingnod or missingnod2 or diceroom then
                --the way this works: if the players active item is currently mystery gift  OR  it is d6 and also d6 is fully charged
                --																				AND the player is pressing the space bar (which is basically like checking if the player is using the d6 and its actually rerolling things)
                --																				THEN do not turn item into gift
                return c
            end

            return replacedItem
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, ent, hook, action)
    if ent and ent:ToPlayer() then
        local player = ent:ToPlayer()

        if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) then
            actived = false

            for i = 1, #blockActives, 1 do
                if player:GetActiveItem() == blockActives[i][1] and (player:GetActiveCharge() == blockActives[i][2] or player:GetBloodCharge() >= blockActives[i][2] or player:GetSoulCharge() >= blockActives[i][2]) then
                    actived = true
                end
            end

            if player:GetActiveItem() == CollectibleType.COLLECTIBLE_MYSTERY_GIFT then
                certActivated = true
            else
                certActivated = false
            end
        else
            actived = false
        end

        if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
            perthrod = false

            for i = 1, #blockPockets, 1 do
                if player:GetCard(0) == blockPockets[i] then
                    perthrod = true
                end
            end

            for i = 1, #blockActives, 1 do
                if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == blockActives[i][1] and (player:GetActiveCharge(ActiveSlot.SLOT_POCKET) == blockActives[i][2] or player:GetBloodCharge() >= blockActives[i][2] or player:GetSoulCharge() >= blockActives[i][2]) then
                    actived = true
                end
                --for dice bag (repentance)
                if player:GetActiveItem(ActiveSlot.SLOT_POCKET2) == blockActives[i][1] then
                    actived = true
                end
            end
        else
            perthrod = false
        end
    end
end)

--damocles fix, items spawned by mystery gift aren't duplicated
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, p)
    if certActivated and p:HasEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE) then
        p:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)
    end
end, 100)

--special case for missingno
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() --aaaaahhhh
    if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_MISSING_NO) then
        missingnod = true
    end
end)


--fix for coop with tainted eden
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, tookDamage, amount, flags, source, countdown)
    local player = tookDamage:ToPlayer()

    if player and (player:GetPlayerType() == PlayerType.PLAYER_EDEN_B or player:HasTrinket(TrinketType.TRINKET_CRACKED_DICE)) then
        bedenHit = true
    end
end, 1)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if bedenHit then bedenHit = false end
    if missingnod2 then
        missingnod2 = false
    end
    if missingnod then
        missingnod = false
        missingnod2 = true
    end

    if diceroom then
        diceroom = false
    end

    local room = game:GetRoom()

    if room:GetType() == RoomType.ROOM_DICE then
        for _, v in ipairs(Isaac.FindByType(1000, 76)) do
            if #Isaac.FindInRadius(v.Position, 65, EntityPartition.PLAYER) > 0 then
                diceroom = true
            end
        end
    end
  end)
