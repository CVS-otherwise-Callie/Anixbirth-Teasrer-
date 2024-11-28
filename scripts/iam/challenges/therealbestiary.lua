local mod = FHAC
local game = Game()
local room = game:GetRoom()
local luaRooms = include("resources.anixbirthluarooms.therealbestiary")
local roomsList = StageAPI.RoomsList("ANIXBIRTH.THE_REAL_BESTIARY", luaRooms)

local enteringNewLevel = false
local damitpleaseWork = false -- same thing that happened to Boss Butch i fucking hate this stupid game
local everythingisfinallyFuckingRendered = false

-- Generate the level
function mod:GenLevel()
    if game.Challenge ~= mod.Challenges.Bestiary then
        everythingisfinallyFuckingRendered = false
        return
    end

    damitpleaseWork = true
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.GenLevel)

function mod:GenFirstLevel(continued)
    if not continued then
        enteringNewLevel = true
        mod:GenLevel()
    else
        if game.Challenge == mod.Challenges.Bestiary then
            everythingisfinallyFuckingRendered = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.GenFirstLevel)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if damitpleaseWork then
        -- Initialize map
        if enteringNewLevel then
            enteringNewLevel = false

            -- Choose map layout
            local mapID = STARTING_ROOM

            mod.ChallengeMap = StageAPI.CreateMapFromRoomsList(roomsList, nil, {NoChampions = true})
            StageAPI.InitCustomLevel(mod.ChallengeMap, true)
            everythingisfinallyFuckingRendered = true
        end

        damitpleaseWork = false
    end

end
)

StageAPI.AddCallback("FHAC", "POST_SELECT_CHALLENGE_MUSIC", 1, function(currentstage, musicID, isCleared, musicRNG)
    return Isaac.GetMusicIdByName("Of Food and Bees")
end)

StageAPI.AddCallback("FHAC", "PRE_LEVELMAP_SPAWN_DOOR", 1, function(slot, doorData, levelRoom, targetLevelRoom, roomData, levelMap)
    if game.Challenge == mod.Challenges.Bestiary then
        --print(slot, doorData.ExitRoom)
    end
end)


