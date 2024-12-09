local mod = FHAC
local game = Game()

function mod:MusicCheckCallback()
    if mod.DSSavedata and mod.DSSavedata.customRoomMusic == 1 then
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
        elseif mod:GetRoomNameByType(rDD.Type) == "Shop" then
            customMusicID = Isaac.GetMusicIdByName("AnixbirthForsaken")
        end
    end

    if customMusicID and customMusicID~=-1 and ms:GetCurrentMusicID() ~= customMusicID and ms:GetCurrentMusicID() < 118 then
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
        Schmoot = {mod.Monsters.Schmoot.ID, mod.Monsters.Schmoot.Var, 0, {EntityType.ENTITY_HORF}, {3}, 0.5},
    }
    if mod.DSSavedata.monsterReplacements ~= 3 then
        if mod.DSSavedata.monsterReplacements == 1 then
            for k, v in pairs(tab) do
                v[6] = 1
            end
        end
        for k, v in pairs(tab) do
            local coolertab = v[4]
            for i = 1, #coolertab do
                if npc.Type == coolertab[i] and  mod:CheckTableContents(v[5], roomConfigRoom.StageID) then
                    --extra for certain thigns not to break
                    if npc.Type == EntityType.ENTITY_WILLO and npc.SpawnerEntity and npc.SpawnerEntity.Type == 913 then return end --miss minmin my favortie

                    --and done!
                    if math.random(0, 100) >= v[6]*100 then
                        npc:Remove()
                        Isaac.Spawn(v[1], v[2], v[3], npc.Position, npc.Velocity, nil)
                    end
                end
            end
        end

    end
end