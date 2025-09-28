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
    
    for i = 1, Game():GetNumPlayers() do

        AnixbirthSaveManager.GetRunSave(Isaac.GetPlayer(i)).jokeBookUpNum =
        0.15*(1+player:GetEffects():GetCollectibleEffectNum(mod.Collectibles.Items.JokeBook))*#mod:GetRoomEntsActive(false)

        player:EvaluateItems()
    end

    return {ShowAnim = true}
end

function mod:JokeBookStats(player)
    local d = player:GetData()


    if player:HasCollectible(mod.Collectibles.Items.JokeBook) then
        player.MaxFireDelay = mod:tearsUp(player.MaxFireDelay, 
        AnixbirthSaveManager.GetRunSave(player).jokeBookUpNum)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.JokeBook, mod.Collectibles.Items.JokeBook)
