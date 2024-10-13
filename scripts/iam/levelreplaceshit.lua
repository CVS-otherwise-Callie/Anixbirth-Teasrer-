local mod = FHAC
local game = Game()

function mod:MusicCheckCallback()
    if mod.DSSavedata.customRoomMusic == 1 then
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
end

function mod:NPCReplaceCallback(npc)
    local game = Game()
    local level = game:GetLevel()
    local roomDescriptor = level:GetCurrentRoomDesc()
    local roomConfigRoom = roomDescriptor.Data
    local tab = {
        Schmoot = {mod.Monsters.Schmoot.ID, mod.Monsters.Schmoot.Var, mod.Monsters.Schmoot.Sub, {EntityType.ENTITY_HORF}, {3}, 0.5}
    }
    if mod.DSSavedata.monsterReplacements ~= 3 then
        if mod.DSSavedata.monsterReplacements == 1 then

        end
        for k, v in pairs(tab) do
            local coolertab = v[4]
            for i = 1, #coolertab do
                print(npc.Type == coolertab[i], v[5], roomConfigRoom.StageID, mod:CheckTableContents(v[5], roomConfigRoom.StageID))
                if npc.Type == coolertab[i] and game:GetRoom():GetRoomConfigStage() == v[5] then
                    if math.random(0, 1) > v[6] then
                        npc:Remove()
                        Isaac.Spawn(v[1], v[2], v[3], npc.Position, npc.Velocity, nil)
                    end
                end
            end
        end

    end
end