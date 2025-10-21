local mod = FHAC
local game = Game()
local rng = RNG()
local itemConfig = Isaac.GetItemConfig()

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(mod.Collectibles.Items.MoneyPleaseletmeintoepiphany) then
        	player.Damage = player.Damage * 2
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
