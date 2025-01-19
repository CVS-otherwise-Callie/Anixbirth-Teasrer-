local mod = FHAC
local game = Game()
local johannes = FHAC.Players.Bohannes
local player = Isaac.GetPlayer()
local rng = RNG()
local isplayer

function mod:GiveCostumesOnInit(player)
    if not Isaac.GetPersistentGameData():Unlocked(FHAC.Unlocks.Bohannes) then return end

    if player:GetPlayerType() ~= johannes then
        isplayer = false
        return
    else
    isplayer = true
    --player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/johanneshair.anm2"))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.GiveCostumesOnInit)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function()
    local player = Isaac.GetPlayer()
    if player:GetPlayerType() ~= johannes then return end
    local persistentGameData = Isaac.GetPersistentGameData()
    if not Isaac.GetPersistentGameData():Unlocked(FHAC.Unlocks.Bohannes) then     
        mod:AltLockedClosetCutscene()
    end
end)