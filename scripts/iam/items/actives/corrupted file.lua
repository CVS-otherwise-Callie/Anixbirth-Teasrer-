local game = Game()

function FHAC:CorruptedFileExeUse(player)
    if not player:GetData().isWeird then
        local nilvector = Vector.Zero

        local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
        for i = 1, 100 do
        player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        local item = Isaac.Spawn(5, 100, 0, pos, nilvector, nil)
        item:SetColor(Color(math.random() * 2,math.random() * 2,math.random() * 2,1, math.random() * 2, math.random() * 2, math.random() * 2),15,1,true,false)
        item:Update()
        end
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 5 and v.Variant == 100 then
                player:AddCollectible(v.SubType)
                v:Remove()
            end
        end
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        player:GetData().isWeird = true
    end
end