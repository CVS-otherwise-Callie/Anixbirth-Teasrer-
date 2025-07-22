local mod = IsMoQu

IsMoQu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc.SubType == 0 then
        npc:GetSprite():Play("Idle")
    end
end, IsMoQu.Grids.GlobalGridSpawner.ID)

IsMoQu.LightPressurePlate = StageAPI.CustomGrid("IsMoQuLightPressurePlate1", {
    BaseType = GridEntityType.GRID_PRESSURE_PLATE,
    BaseVariant = 0,
    Anm2 = "gfx/grid/_quizshowbuttons.anm2",
    Animation = "Off",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = IsMoQu.Grids.GlobalGridSpawner.ID, Variant = 2900}
})

local function quizButAI(customGrid, answ)
    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    local function IsRoomClear()
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v:CanShutDoors() and not v:IsDead() then
                return false
            end
        end
        return true
    end

    if not mod:CheckTableContentsGrid(IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM, customGrid) then
        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM = IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM or {}
        table.insert(IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM, customGrid)
        grid.State = 0
        d.FakeStateFrame = 0
        d.questionLoaded = false
    end

    if d.AmbushGoinOn then
        if IsRoomClear() then
            grid.State = 3
            d.ShouldBeOff = true
            d.AmbushGoinOn = false
            d.CopyQues = nil
            Game():GetLevel():GetCurrentRoomDesc().Clear = true
        end
        grid.CollisionClass = GridCollisionClass.COLLISION_NONE
        sprite:Play("On")
        sprite:Update()
        return
    end

    if d.ShouldBeOff and not d.CopyQues then
        grid.State = 3
        sprite:Play("On")
        sprite:Update()
        Game():GetLevel():GetCurrentRoomDesc().Clear = true
        return
    end

    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()

    roomDescriptor.Flags = roomDescriptor.Flags & RoomDescriptor.FLAG_NO_REWARD
    roomDescriptor.NoReward = true
    
    if not d.init then
        sprite:Play("Off")
        d.FakeStateFrame = 0
        d.questionLoaded = false
        grid.State = 0
        d.init = true
    end

    local level = Game():GetLevel()
    local roomDescriptor = level:GetCurrentRoomDesc()

    if grid.State == 3 and 
    mod.SavMan and 
    mod.SavMan.GetRunSave() and
    mod.SavMan.GetRunSave().moddquizSaveDat and 
    d.Question and 
    mod.SavMan.GetRunSave().moddquizSaveDat.CurAnsw ~= IsMoQu.SavMan.GetRunSave().moddquizSaveDat.inputtedAnsw then
        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.inputtedAnsw = d.Question[2] --change this to being the .Question but without the "An" part
    else
        roomDescriptor.Clear = false
    end

    local op = 0.5

    for k, v in ipairs(Isaac.FindInRadius(grid.Position, 100, EntityPartition.PLAYER)) do
        if not Game():GetRoom():CheckLine(v.Position,grid.Position,3,900,false,false) then return end
        if op < 1 then
            d.FakeStateFrame = d.FakeStateFrame + 1
            op = op + (d.FakeStateFrame*0.1)
        end
    end
    if #Isaac.FindInRadius(grid.Position, 100, EntityPartition.PLAYER) == 0 then
        d.FakeStateFrame = 0
    end

    local function RenderText(text)
        for j = 1, 120 do
            IsMoQu.scheduleCallback(function()
                if roomDescriptor.ListIndex and text and type(text[1]) == "string" then

                    local kcol

                    if grid.Position == Vector(280, 440) or not Game():GetRoom():IsPositionInRoom(grid.Position, 15) then return end

                    if IsMoQuSaveManager.GetSettingsSave().showanswe ~= 2 then
                        if (not d.ShouldBeOff and text[2] ~= text[3]["RightAn"]) then
                            kcol = {1, 0.5, 0.5}
                        elseif text[2] == text[3]["RightAn"] then
                            kcol = {0.5, 1, 0.5}
                        else
                            kcol = {1, 1, 1}
                        end  
                    else
                        if not d.ShouldBeOff then
                            kcol = {1, 0.5, 0.5}
                        elseif text[2] == text[3]["RightAn"] then
                            kcol = {0.5, 1, 0.5}
                        else
                            kcol = {1, 1, 1}
                        end     
                    end

                    local pos = Game():GetRoom():WorldToScreenPosition(grid.Position) + Vector(IsMoQu.TempestFont:GetStringWidth(text[1]) * -0.5, -(grid:GetSprite().Scale.Y * 35) - j*0.1)

                    if type(text[1]) == "table" then
                        for h = 1, #text[1] do
                            IsMoQu.TempestFont:DrawString(text[1], pos.X, pos.Y, KColor(kcol[1], kcol[2], kcol[3], (120 - j)/120), 0, false)   
                        end
                    elseif type(text[1]) == "string" then
                        IsMoQu.TempestFont:DrawString(text[1], pos.X, pos.Y, KColor(kcol[1], kcol[2], kcol[3], (120 - j)/120), 0, false)             
                    end

                    IsMoQuSaveManager.GetSettingsSave().punishment = IsMoQuSaveManager.GetSettingsSave().punishment or 2

                    if j == 90 and not d.ShouldBeOff then
                        if IsMoQuSaveManager.GetSettingsSave().punishment == 1 then
                            if not mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedAmbushInRoom then
                                mod:ModdedAmbush()
                            end
                            d.ShouldBeOff = false
                            d.AmbushGoinOn = true
                        else
                            if not mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedTeleportBack then
                                mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedTeleportBack = true
                                if not mod.SavMan.GetRunSave().moddquizSaveDat.RefreshQuestions or (mod.SavMan.GetRunSave().moddquizSaveDat.RoomList[#mod.SavMan.GetRunSave().moddquizSaveDat.RoomList] < StageAPI.GetCurrentRoomID()) then
                                    mod.SavMan.GetRunSave().moddquizSaveDat.RefreshQuestions = StageAPI.GetCurrentRoomID()
                                end 
                                for i = 0, Game():GetNumPlayers()-1 do
                                    if i then
                                        Isaac.GetPlayer(i):ToPlayer():PlayExtraAnimation("TeleportUp")
                                    end
                                end      
                            end
                        end
                    end

                    if j == 120 and not d.ShouldBeOff then
                        local room = mod.SavMan.GetRunSave().moddquizSaveDat.SendBackRoom or 1
                        if room == 0 then
                            room = 1
                        end
                        if room and StageAPI.CurrentLevelMapID and IsMoQuSaveManager.GetSettingsSave().punishment == 2 and mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedTeleportBack then
                            StageAPI.ExtraRoomTransition(room, Direction.NO_DIRECTION, -1, StageAPI.CurrentLevelMapID, nil, nil, Vector(320, 380))
                            for i = 0, Game():GetNumPlayers()-1 do
                                if i then
                                    Isaac.GetPlayer(i):ToPlayer():PlayExtraAnimation("TeleportDown")
                                end
                            end
                            mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedTeleportBack = false
                        end
                    end
                end
            end, j, ModCallbacks.MC_POST_RENDER)
        end
    end

    if d.Question and #d.Question > 0 then

        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.CurQues = d.Question[3]["Question"]
        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.CurAnsw = d.Question[3]["RightAn"]
        
        d.CopyQues = d.CopyQues or d.Question

        d.Question[1] = d.Question[3]["An" .. d.Question[2]]

        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtonStrings = IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtonStrings or {}

        if roomDescriptor.ListIndex then
            IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtonStrings[tostring((Game():GetRoom():GetGridIndex(grid.Position) + roomDescriptor.ListIndex))] = {d.Question, grid, op}
        end
    elseif d.CopyQues then

        IsMoQu.SavMan.GetRunSave().moddquizSaveDat.ButtonStrings[tostring((Game():GetRoom():GetGridIndex(grid.Position) + roomDescriptor.ListIndex))] = nil

        RenderText(d.CopyQues)

        d.CopyQues = nil
            
    end
end

function IsMoQu.quizButtonAI1(customGrid)
    quizButAI(customGrid, 1)
end

StageAPI.AddCallback("IsMoQu", "POST_CUSTOM_GRID_UPDATE", 1, IsMoQu.quizButtonAI1, "IsMoQuLightPressurePlate1")
