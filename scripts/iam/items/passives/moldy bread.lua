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
	local redHearts = player:GetHearts()
	player:AddHearts(-redHearts)
	player:AddRottenHearts(redHearts)
end, nil, mod.Collectibles.Items.MoldyBread)
