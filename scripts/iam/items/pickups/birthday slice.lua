local mod = FHAC
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, useflags)
	local r = player:GetCardRNG(cardID)

    print(cardID)

    if cardID == 98 then
        local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
        dat.aceCakePickup = dat.aceCakePickup or 1
        dat.aceCakePickup = dat.aceCakePickup + 1

        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end

end, mod.Collectibles.Pickups.BirthdaySlice)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,function(_, player, flag)

    local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

    if dat.aceCakePickup and dat.aceCakePickup > 0 and dat.aceCakePickup ~= dat.aceCakePickupOld then
        player.Damage = player.Damage + (1 * dat.aceCakePickup)
        player.MoveSpeed = player.MoveSpeed + (0.2 * dat.aceCakePickup)
        player.ShotSpeed = player.ShotSpeed + (0.05 * dat.aceCakePickup)
        player.TearRange = player.TearRange + (50 * dat.aceCakePickup)

        local ent = Isaac.Spawn(161, 2, 5, player.Position, Vector(10, 0), player)
        ent:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_CHARM)

        dat.aceCakePickupOld = dat.aceCakePickup
    end
end)