local mod = FHAC
local stinkymushroomDamage = 1

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(mod.Collectibles.Items.StinkyMushroom)
        local damageToAdd = stinkymushroomDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)