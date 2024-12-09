local mod = FHAC

function mod:JokeBook(item, _, player)
    mod.JokeBookDelay = true
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v:IsActiveEnemy() then
            v:AddFear(EntityRef(player), 150)
        end
    end
    return {ShowAnim = true}
end

function mod:JokeBookStats(player)
    local d = player:GetData()
    d.JokeBookFireDelay = 0
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v:IsActiveEnemy() then
            d.JokeBookFireDelay = d.JokeBookFireDelay + 0.05
        end
    end
    if player:HasCollectible(mod.Collectibles.Items.JokeBook) then
        player.MaxFireDelay = mod:tearsUp(player.MaxFireDelay, 
        d.JokeBookFireDelay*(1+player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.Items.JokeBook)))
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.JokeBook, mod.Collectibles.Items.JokeBook)
