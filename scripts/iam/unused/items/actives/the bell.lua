local game = Game()

function FHAC:RingingOfTheBell(_, _, player)
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION, true, 1)
        local gird = Isaac.Spawn(33, 4, 0, player.Position, Vector.Zero, nil)
        gird:GetData().issuppsoedtoDie = true
        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, false, true, false)
        player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION, 1)
end

--FHAC:AddCallback(ModCallbacks.MC_USE_ITEM, FHAC.RingingOfTheBell, FHAC.Collectibles.Items.TheBell)

FHAC:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
        if npc.Variant == 4 then
                if npc:GetData().issuppsoedtoDie then
                        npc.StateFrame = npc.StateFrame + 1

                        if npc.StateFrame > 5 then
                                npc:Remove()
                        end
                end
        end
end, 33)
