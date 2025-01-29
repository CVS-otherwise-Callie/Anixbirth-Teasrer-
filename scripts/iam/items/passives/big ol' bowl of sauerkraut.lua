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
	ms:Play(Isaac.GetMusicIdByName("albuquerque"), 0.1)
	for i = 1, math.random(2) do
		Isaac.Spawn(mod.Collectibles.Pickups.BowlOfSauerkraut.ID, mod.Collectibles.Pickups.BowlOfSauerkraut.Var, -1, Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 5, true, false), Vector.Zero, player)
	end
end, nil, mod.Collectibles.Items.BigBowlOfSauerkraut)

function mod:BigBowlOfSauerkrautSpawn()
	local player = Isaac.GetPlayer()
	if not player:HasCollectible(mod.Collectibles.Items.BigBowlOfSauerkraut) or mod:CheckForEntInRoom({Type = 5, Variant = mod.Collectibles.Pickups.BowlOfSauerkraut.Var, SubType = 0}, true, true, false) == true or game:GetRoom():IsClear() then return end
	for i = 1, math.random(2*player:GetCollectibleNum(mod.Collectibles.Items.BigBowlOfSauerkraut, false, false)) do
		Isaac.Spawn(mod.Collectibles.Pickups.BowlOfSauerkraut.ID, mod.Collectibles.Pickups.BowlOfSauerkraut.Var, -1, Game():GetRoom():FindFreePickupSpawnPosition(mod:freeGrid(player, true, 200, 100), 5, true, false), Vector.Zero, player)
	end
end