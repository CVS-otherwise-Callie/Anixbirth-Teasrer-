local mod = FHAC
local game = Game()

function mod:SetMegaperBoss()
    if mod:AnyPlayerHasCollectible(mod.Collectibles.Items.Megaper) then

    --OH SHIT WHOOOOOPSIES THANKS STAGEAPI
        if BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator.InTestStage and (BasementRenovator:InTestRoom() or BasementRenovator:InTestStage()) then
            return
        end

        if not StageAPI.GetBossEncountered("Megaper") then return end

        --everything under here is stageapi code. this is one of the benefits of using it as a relied source 

        local roomsList = game:GetLevel():GetRooms()
        for i = 0, roomsList.Size - 1 do
            local roomDesc = roomsList:Get(i)

                
            local baseFloorInfo = StageAPI.GetBaseFloorInfo()
            local xlFloorInfo
            if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0 then
                xlFloorInfo = StageAPI.GetBaseFloorInfo(game:GetLevel():GetStage() + 1, game:GetLevel():GetStageType())
            end

            local lastBossRoomListIndex = game:GetLevel():GetLastBossRoomListIndex()
            local backwards = game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT) or game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
            local dimension = StageAPI.GetDimension(roomDesc)
            local newRoom
            local setMirrorBossData

            if baseFloorInfo and baseFloorInfo.HasCustomBosses
            and roomDesc.Data.Type == RoomType.ROOM_BOSS
            and roomDesc.SafeGridIndex ~= GridRooms.ROOM_DEBUG_IDX
            and dimension == 0 and not backwards then
                local bossFloorInfo = baseFloorInfo
                if xlFloorInfo and roomDesc.ListIndex == lastBossRoomListIndex then
                    bossFloorInfo = xlFloorInfo
                end

                local bossID = "Megaper"
                if bossID then
                    local bossData = StageAPI.GetBossData(bossID)
                    if bossData and not bossData.BaseGameBoss and bossData.Rooms then
                        newRoom = StageAPI.GenerateBossRoom({
                            BossID = bossID,
                            NoPlayBossAnim = true,
                            CheckEncountered = false,
                        }, {
                            RoomDescriptor = roomDesc
                        })
                        
                        if StageAPI.ReplaceBossSubtypes[roomDesc.Data.Subtype] then
                            local overwritableRoomDesc = game:GetLevel():GetRoomByIdx(roomDesc.SafeGridIndex, dimension)
                            local replaceData = StageAPI.GetGotoDataForTypeShape(RoomType.ROOM_BOSS, roomDesc.Data.Shape)
                            overwritableRoomDesc.Data = replaceData
                            setMirrorBossData = replaceData
                        end
                    end
                end
            end

            if newRoom then
                local listIndex = roomDesc.ListIndex
                StageAPI.SetLevelRoom(newRoom, listIndex, dimension)
                if roomDesc.Data.Type == RoomType.ROOM_BOSS and baseFloorInfo.HasMirrorLevel and dimension == 0 and roomDesc.SafeGridIndex > -1 then
                    local mirroredRoom = newRoom:Copy(roomDesc)
                    local mirroredDesc = shared.Level:GetRoomByIdx(roomDesc.SafeGridIndex, 1)
                    if setMirrorBossData then
                        mirroredDesc.Data = setMirrorBossData
                    end

                    StageAPI.SetLevelRoom(mirroredRoom, mirroredDesc.ListIndex, 1)
                end
            end

        end
    end
end