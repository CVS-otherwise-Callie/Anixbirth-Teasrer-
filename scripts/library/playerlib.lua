local mod = FHAC
local rng = RNG()
local game = Game()

function mod:GetPlayerCollectibles(player)
	local tab = {}
	for i = 1, CollectibleType.NUM_COLLECTIBLES do
		if player:HasCollectible(i, true) then
			for j = 1, player:GetCollectibleNum(i, false) do
				table.insert(tab, i)
			end
		end
	end
	return tab
end

function mod:AnyPlayerHasTrinket(trinketType)
	for i = 1, game:GetNumPlayers() do
        if game:GetPlayer(i):ToPlayer():HasTrinket(trinketType) then
            return true
        end
    end

    return false
end

function mod:AnyPlayerHasCollectible(coll)
	for i = 1, game:GetNumPlayers() do
        if game:GetPlayer(i):ToPlayer():HasCollectible(coll) then
            return true
        end
    end

    return false
end

function mod:IsSourceofDamagePlayer(source, bomb)
	if source.Entity then
		if bomb then
			return (source.Entity.Type == 1 or source.Entity.Type == 3 or source.Entity.Type == 4 or source.Entity.SpawnerType == 1 or source.Entity.Type == 3 or source.Entity.SpawnerType == 4)
		else
			return (source.Entity.Type == 1 or source.Entity.Type == 3 or source.Entity.SpawnerType == 1 or source.Entity.SpawnerType == 3)
		end
	else
		return false
	end
end

-- thanks fiend folio
function mod:tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end
