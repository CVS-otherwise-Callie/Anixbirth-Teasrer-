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
            customMusicID = Isaac.GetMusicIdByName("Anixbirth12AM")
        elseif mod:GetRoomNameByType(rDD.Type) == "Library" then
            customMusicID = Isaac.GetMusicIdByName("AnixbirthFunctions")
        elseif mod:GetRoomNameByType(rDD.Type) == "Sacrifice" then
            customMusicID = Isaac.GetMusicIdByName("AnixbirthSacrilege")
        elseif mod:GetRoomNameByType(rDD.Type) == "Bedroom" then
            customMusicID = Isaac.GetMusicIdByName("AnixbirthGoodnightPrince")
        end
    end

    if customMusicID and customMusicID~=-1 and ms:GetCurrentMusicID() ~= customMusicID then
        ms:Play(customMusicID, 0)
        ms:UpdateVolume()
    end

end