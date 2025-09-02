local mod = FHAC
local game = Game()
local ms = MusicManager()

mod.AddItemCallback(function(p, added)
	local player = p
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		if player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
	end
	
    player:AddMaxHearts(2, true)
	player:AddHearts(2)
	ms:Play(Isaac.GetMusicIdByName("albuquerque"), 1)
	for i = 1, math.random(2) do
		Isaac.Spawn(mod.Collectibles.PickupsEnt.BowlOfSauerkraut.ID, mod.Collectibles.PickupsEnt.BowlOfSauerkraut.Var, 0, Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 5, true, false), Vector.Zero, player)
	end
end, nil, mod.Collectibles.Items.BigOlBowlofSauerkraut)

function mod:BigOlBowlOfSauerkrautSpawn()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i)
		if not player:HasCollectible(mod.Collectibles.Items.BigOlBowlofSauerkraut) or game:GetRoom():IsClear() then return end
		for j = 1, math.random(2*player:GetCollectibleNum(mod.Collectibles.Items.BigOlBowlofSauerkraut, false, false)) do
			Isaac.Spawn(mod.Collectibles.PickupsEnt.BowlOfSauerkraut.ID, mod.Collectibles.PickupsEnt.BowlOfSauerkraut.Var, 0, Game():GetRoom():FindFreePickupSpawnPosition(mod:freeGrid(player, true, 200, 100), 5, true, false), Vector.Zero, player)
		end
	end
end