local mod = FHAC
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local tab = {
    --CollectibleType.COLLECTIBLE_MILK,
    CollectibleType.COLLECTIBLE_SOY_MILK,
    CollectibleType.COLLECTIBLE_ALMOND_MILK,
    CollectibleType.COLLECTIBLE_CHOCOLATE_MILK
}
local function GetAllTempItemsFromPlayerTempItems(tabl, player)

    local t = {}

    for k, v in pairs(tabl) do --messy but i rlly dont give a shit

        if k == "TemporaryItems" then
            for h, i in pairs(v) do
                if type(i) == "table" then
                    for l, m in pairs(i) do
                        if l == "Item" then
                            table.insert(t, m)
                        end
                    end
                end
            end
        end
    end

    return t
end

local function FindItemAndPlayerInTempItems(player, item)
    local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData or player:GetData()

    --Annex:PrintAllOfTable(dat)

    if not dat.TemporaryItems then return end


    for k, v in ipairs(tab) do
        if mod:CheckTableContents(GetAllTempItemsFromPlayerTempItems(dat, player), v) then
            return true
        end
    end
    return false
end

local function CheckMysteryMilkList(list, player)
    for k, v in ipairs(list) do
        if FindItemAndPlayerInTempItems(player, v) then
            return true
        end
    end
    return false
end

function mod:MysteryMilkRoomInit(player)
    rng:SetSeed(game:GetLevel():GetCurrentRoomDesc().AwardSeed, 1)
    local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData or player:GetData()
    if CheckMysteryMilkList(tab, player) then return end
    local itemCount = player:HasTrinket(mod.Collectibles.Trinkets.MysteryMilk)
    
    if itemCount then
        for i = 0, player:GetTrinketMultiplier(mod.Collectibles.Trinkets.MysteryMilk) - 1 do
            local pickup = tab[math.random(#tab)]
            mod:AddTempItem(pickup, player)
        end
    end
    dat.MysteryMilkEffect = true
end