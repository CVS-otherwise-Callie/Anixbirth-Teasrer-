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

function mod:MysteryMilkRoomInit(player)
    rng:SetSeed(game:GetLevel():GetCurrentRoomDesc().AwardSeed, 1)
    local dat = SaveManager.GetRoomSave(player).anixbirthsaveData or player:GetData()
    if dat.MysteryMilkEffect then return end
    dat.MysteryMilkEffect = true
    if math.random(player:GetTrinketRNG(mod.Collectibles.Trinkets.MysteryMilk):RandomInt(100)) > 15 then return end
    local itemCount = player:HasTrinket(mod.Collectibles.Trinkets.MysteryMilk)
    
    if itemCount then
        for i = 0, player:GetTrinketMultiplier(mod.Collectibles.Trinkets.MysteryMilk) - 1 do
            local pickup = tab[math.random(#tab)]
            mod:AddTempItem(pickup)
        end
    end
end