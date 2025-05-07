local game = Game()

function FHAC:CorruptedFileExeUse(item, _, player)
        player:RemoveCollectible(item)
        local nilvector = Vector.Zero
        player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)

        local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
        for k, v in ipairs(FHAC:GetPlayerCollectibles(player)) do

            local shouldSkipTmtrainer = false

            local function DoCOrruptedFileThing()
                local it = Isaac.Spawn(5, 100, v, pos, nilvector, nil)
                player:RemoveCollectible(v)
                it:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                it:Update()
                it:GetData().isSpawnedByCorruptedFile = true
            end

            if shouldSkipTmtrainer then
                DoCOrruptedFileThing()
            else
                if v== CollectibleType.COLLECTIBLE_TMTRAINER then
                    shouldSkipTmtrainer = true
                else
                    DoCOrruptedFileThing()
                end
            end
        end
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 5 and v.Variant == 100 and v.SubType > 4000000000 and v:GetData().isSpawnedByCorruptedFile then --stupid floating numbers
                player:AddCollectible(v.SubType)
                v:Remove()
            end
        end
end

FHAC:AddCallback(ModCallbacks.MC_USE_ITEM, FHAC.CorruptedFileExeUse, FHAC.Collectibles.Items.CorruptedFile)
