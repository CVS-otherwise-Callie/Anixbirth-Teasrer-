local mod = FHAC
local game = Game()

function mod:MusicCheckCallback()
	local rDD = game:GetLevel():GetCurrentRoomDesc().Data
    local customMusicID = nil
    local ms = MusicManager()

    if mod:GetRoomNameByType(rDD.Type) then
        if mod:GetRoomNameByType(rDD.Type) == "Secret" then
            customMusicID = Isaac.GetMusicIdByName("AnixbirthGrief")
        elseif mod:GetRoomNameByType(rDD.Type) == "Arcade" then
            customMusicID = Isaac.GetMusicIdByName("12AM")
        end
    end

    if customMusicID and customMusicID~=-1 and ms:GetCurrentMusicID() ~= customMusicID then
        print(customMusicID)
        ms:Play(customMusicID, 0)
        ms:UpdateVolume()
    end

end