local game = Game()

function FHAC:RingingOfTheBell(player)
        player:AddCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION, 0, false, nil, 15)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, true, false)
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION, 0, false, nil)
end
