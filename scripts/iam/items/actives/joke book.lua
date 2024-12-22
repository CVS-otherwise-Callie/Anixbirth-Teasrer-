local mod = FHAC

function mod:JokeBook(item, _, player)
    local coolnumber = mod.DSSavedata.fortuneLanguage
    mod.JokeBookDelay = true
    mod.DSSavedata.fortuneLanguage = 4
    mod.FortuneTable = {}
    mod:ShowFortune()
    mod.DSSavedata.fortuneLanguage = coolnumber
    mod.FortuneTable = {}
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v:IsActiveEnemy() then
            v:AddFear(EntityRef(player), 150)
        end
    end
    return {ShowAnim = true}
end

function mod:JokeBookStats(player)
    local d = player:GetData()
    if player:HasCollectible(mod.Collectibles.Items.JokeBook) then
        player.MaxFireDelay = mod:tearsUp(player.MaxFireDelay, 
        0.5*(1+player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.Items.JokeBook)))
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.JokeBook, mod.Collectibles.Items.JokeBook)
