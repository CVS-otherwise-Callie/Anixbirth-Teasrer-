local mod = FHAC
local game = Game()
local music = MusicManager()
local stage = game:GetLevel():GetName()
local stagetext = mod:removeSubstring(tostring(stage), "I")

--this is rushed atm ill make proper support later
--TRUST THE PROCESSSSSSSS

--[[if music:IsEnabled(stagetext) then
    music:Pause()
end]]

--[[mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() 
    if music:GetCurrentMusicID() == Music.MUSIC_CELLAR then
        music:Play(Isaac.GetMusicIdByName("Of Food and Bees"), 1)
        music:Pause(Music.MUSIC_CELLAR)
    else
        music:Enable()
    end
end)]]


