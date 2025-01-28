local mod = FHAC

mod.AddItemCallback(function(p, added)
	local player = p
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		if player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
	end
	
    player:AddMaxHearts(2, true)
	player:AddHearts(2)
end, nil, mod.Collectibles.Items.BigBowlOfSauerkraut)