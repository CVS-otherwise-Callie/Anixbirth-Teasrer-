local mod = IsMoQu
local game = Game()
local rng = RNG()

---- GENERATE LEVEL ----
local luaRooms = include("resources.luarooms.quiz1")
local roomsList = StageAPI.RoomsList("IMOQUQUIZ_1", luaRooms)
local enteringNewLevel = false
local damitpleaseWork = false -- same thing that happened to Boss Butch i fucking hate this stupid game
local everythingisfinallyFuckingRendered = false --you need this otherwise it wont fucking load!!!!!!

-- Generate the level
function mod:GenLevel()

    mod.SavMan.GetRunSave().moddquizSaveDat = mod.SavMan.GetRunSave().moddquizSaveDat or {}

    if game.Challenge ~= mod.Challenges.Quiz then
        everythingisfinallyFuckingRendered = false
        return
    end

    damitpleaseWork = true
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.GenLevel)

function mod:GenFirstLevel(continued)
    if not continued then
        mod.SavMan.GetRunSave().moddquizSaveDat = {}
        enteringNewLevel = true
        mod:GenLevel()
    else
        if game.Challenge == mod.Challenges.Quiz then
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

            mod.ChallengeMap = StageAPI.CreateMapFromRoomsList(roomsList, nil, {NoChampions = true})
            StageAPI.InitCustomLevel(mod.ChallengeMap, true)
            everythingisfinallyFuckingRendered = true
        end

        damitpleaseWork = false
    end

end
)

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function()
    if game.Challenge == mod.Challenges.Quiz then
        return 0
    end
end)

---- END OF GENERATING LEVEL ----

local dataReloaded = false
local questionsReloaded = false

local function GetQuestionTypeFromName(name)
    local na  = 0
    for i = 0, 999 do
        if string.find(name, tostring(i)) then
            na = i
        end
    end
    return na
end

local function GetQuestion(diff, choices)

    rng:SetSeed(game:GetRoom():GetSpawnSeed(), 32)

    choices = choices or {}

    local File = include("quizscripts.questions.diff" .. diff)

    local questions = {}

    for k, v in ipairs(File) do
        local na = 0
        for i = 1, 999 do
            if v["An" .. i] then
                na = na + 1
            end
        end

        if na == #choices then
            table.insert(questions, v)
        end
        --v["An" .. i]
    end

    local na = 0

    if #questions > 1 then
        na = 1
    end

    if #questions == 0 then return end

    local choice = questions[rng:RandomInt(1, #questions-na)]
    
    if choice and #choices > 0 then

        local nums = mod:getSeveralDifferentNumbers(#mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM, #mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM)

        for k, v in ipairs(mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM) do
            if mod.SavMan.GetRunSave().moddquizSaveDat.RefreshQuestions then
                v.PersistentData = {}
            end
            v.PersistentData.Question = {choice["An" .. nums[k]], nums[k], choice, k} --no before you ask i do NOT know why i did it like this
        end

        mod.SavMan.GetRunSave().moddquizSaveDat.CurCur = choice
        mod.SavMan.GetRunSave().moddquizSaveDat.CurAnsw = choice["RightAn"]
    end

end

local function FindQuestionPlacement()
    if #Isaac.FindByType(mod.Ents.QuizQuestionPlacement.ID, mod.Ents.QuizQuestionPlacement.Var) > 0 then
        return Isaac.FindByType(mod.Ents.QuizQuestionPlacement.ID, mod.Ents.QuizQuestionPlacement.Var)[1].Position
    else
        return Game():GetRoom():GetCenterPos()
    end
end


function mod:CheckAnswer()
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
    local input = mod.SavMan.GetRunSave().moddquizSaveDat.inputtedAnsw
    if input and input ~= 0 then
        if input == mod.SavMan.GetRunSave().moddquizSaveDat.CurAnsw then
            for k, v in ipairs(mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM) do
                v.State = 3
                v.PersistentData.Question = nil
                v.PersistentData.ShouldBeOff = true
                v.PersistentData.SetTransOff = 30
            end
            roomDescriptor.Flags = roomDescriptor.Flags & RoomDescriptor.FLAG_NO_REWARD & RoomDescriptor.FLAG_CLEAR
            roomDescriptor.Clear = true
        else
            for k, v in ipairs(mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM) do
                v.PersistentData.Question = nil
            end
        end
    end
end

function mod:ModdedAmbush()

    mod.SavMan.GetRunSave().moddquizSaveDat.HasCommitedAmbushInRoom = true
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()

    local File = include("quizscripts.misc.waves.diff" .. math.ceil(GetQuestionTypeFromName(StageAPI.GetCurrentRoom().Layout.Name)/3))
    rng:SetSeed(game:GetRoom():GetSpawnSeed(), 32)
    local choice = File[rng:RandomInt(1, #File)]

    for _, ents in ipairs(choice) do
        if type(ents) == "table" and not ents.ISDOOR then

            local pos = StageAPI.VectorToGrid(ents.GRIDX, ents.GRIDY, choice.WIDTH + 2)
            local ent
            for k, v in ipairs(ents) do
                if type(v) == "table" then
                    ent = v
                end
            end

            Isaac.Spawn(ent.TYPE, ent.VARIANT, ent.SUBTYPE, game:GetRoom():GetGridPosition(pos), Vector.Zero, nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if game.Challenge == mod.Challenges.Quiz then

        local dat = mod.SavMan.GetRunSave().moddquizSaveDat

        if dat then

            dat.RoomList = dat.RoomList or {}

            dat.ButtsAliveATM = dat.ButtsAliveATM or {}

            if StageAPI.GetCurrentRoom() then

                if not mod:CheckTableContents(dat.RoomList, StageAPI.GetCurrentRoomID()) then
                    table.insert(dat.RoomList, StageAPI.GetCurrentRoomID())
                end

                if mod.SavMan.GetRunSave().moddquizSaveDat.RefreshQuestions == StageAPI.GetCurrentRoomID() then
                    mod.SavMan.GetRunSave().moddquizSaveDat.RefreshQuestions = nil
                end

                dat.CurDiff = dat.CurDiff or 0

                local curroom = GetQuestionTypeFromName(StageAPI.GetCurrentRoom().Layout.Name)
                if dat.CurDiff and curroom > dat.CurDiff then
                    if StageAPI.GetCurrentRoomID() > 1 then
                        dat.SendBackRoom = dat.RoomList[#dat.RoomList]
                    else
                        dat.SendBackRoom = 1
                    end
                end  
            end

            dat.inputtedAnsw = 0

            dat.ButtsAliveATM = {}
        end
        dataReloaded = false
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

    mod.SavMan.GetRunSave().moddquizSaveDat = mod.SavMan.GetRunSave().moddquizSaveDat or {}

    if game.Challenge == mod.Challenges.Quiz then

        --#reigon Data
        local dat = mod.SavMan.GetRunSave().moddquizSaveDat
        if StageAPI.GetCurrentRoom() and not dataReloaded and dat then
            questionsReloaded = false
            dat.ButtsAliveATM = dat.ButtsAliveATM or {}
            for k, v in ipairs(mod.SavMan.GetRunSave().moddquizSaveDat.ButtsAliveATM) do
                v.PersistentData.Question = nil
            end
            dat.CurQues = nil
            dat.CurCur = nil
            dat.ButtonStrings = {}
            dat.HasCommitedAmbushInRoom = false
            dat.CurDiff = GetQuestionTypeFromName(StageAPI.GetCurrentRoom().Layout.Name)
            dat.inputtedAnsw = 0
            dat.SendBackRoom = dat.SendBackRoom or 1
            dataReloaded = true
        end

        if StageAPI.GetCurrentRoom() and dat and dataReloaded then
            mod:CheckAnswer()
        end
        --#endreigon Data

        if dat.ButtsAliveATM and #dat.ButtsAliveATM > 0 and not questionsReloaded then
            GetQuestion(dat.CurDiff, dat.ButtsAliveATM)
            questionsReloaded = true
        end
    end

end)

local function LoadTexts()
    if game.Challenge == mod.Challenges.Quiz then

        local dat = mod.SavMan.GetRunSave().moddquizSaveDat

        if dat then
            local str = dat.CurQues
        
            if StageAPI.GetCurrentRoom() and dataReloaded and dat and str then
                local opacity = 1

                if type(dat.CurQues) == "table" then
                    for k = 1, #dat.CurQues do
                        local pos = Game():GetRoom():WorldToScreenPosition(FindQuestionPlacement()) + Vector(IsMoQu.TempestFont:GetStringWidth(str[#dat.CurQues - k + 1]) * -0.5, -15)
                        IsMoQu.TempestFont:DrawString(str[#dat.CurQues - k + 1], pos.X, pos.Y - (12*(k-1)), KColor(1,1,1,opacity), 0, false)
                    end
                elseif type(dat.CurQues) == "string" then
                    local pos = Game():GetRoom():WorldToScreenPosition(FindQuestionPlacement()) + Vector(IsMoQu.TempestFont:GetStringWidth(str) * -0.5, -15)
                    IsMoQu.TempestFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
                end
            end

            if dat.ButtonStrings then

                for k, v in pairs(dat.ButtonStrings) do

                    if v and v[1] and not v[1][1] then
                        questionsReloaded = false
                        return
                    end

                    if not (v and v[1] and v[1][1]) then return end

                    local grid = v[2]

                    v[3] = v[3] or 1
                    v[4] = v[4] or 0

                    local pos = Game():GetRoom():WorldToScreenPosition(grid.Position) + Vector(IsMoQu.TempestFont:GetStringWidth(v[1][1]) * -0.5, -(grid:GetSprite().Scale.Y * 35) - v[4])

                    if type(v[1]) == "table" then
                        for j = 1, #v[1][1] do
                            IsMoQu.TempestFont:DrawString(v[1][1], pos.X, pos.Y, KColor(v[3],v[3],v[3],v[3]), 0, false)   
                        end
                    elseif type(v[1]) == "string" then
                        IsMoQu.TempestFont:DrawString(v[1][1], pos.X, pos.Y, KColor(v[3],v[3],v[3],v[3]), 0, false)             
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    LoadTexts()
end)

--- FUNCTIONS ---

mod.funcs = {}
function mod.scheduleCallback(foo, delay, callback, noCancelOnNewRoom)
	callback = callback or ModCallbacks.MC_POST_UPDATE
	if not mod.funcs[callback] then
		mod.funcs[callback] = {}
		mod:AddCallback(callback, function()
			for i = #mod.funcs[callback], 1, -1 do
				local func = mod.funcs[callback][i]
				func.Delay = func.Delay - 1
				if func.Delay <= 0 then
					func.Func()
					table.remove(mod.funcs[callback], i)
				end
			end
		end)
	end

    delay = delay or 1

	table.insert(mod.funcs[callback], { Func = foo, Delay = delay, NoCancel = noCancelOnNewRoom })
end

function mod:CheckTableContentsGrid(table, element)
	for _, value in pairs(table) do
        if not (value.GridEntity or element.GridEntity) then return false end
	  	if Game():GetRoom():GetGridIndex(value.GridEntity.Position) == Game():GetRoom():GetGridIndex(element.GridEntity.Position) then
			return true
	  	end
	end
	return false
end

function mod:CheckTableContents(table, element)
	for _, value in pairs(table) do
	  	if value == element then
			return true
	  	end
	end
	return false
end

function mod:getSeveralDifferentNumbers(needed, totalAmount, customRNG, blacklist)
	local numTable = {}
	local results = {}
	for i=1,totalAmount do
		table.insert(numTable, i)
	end
	local rng = RNG()
	if customRNG == nil then
		rng:SetSeed(game:GetRoom():GetSpawnSeed(), 0)
	else
		rng = customRNG
	end
	
	if blacklist then
		for _,num in ipairs(blacklist) do
			table.remove(numTable, num)
		end
	end

	for i=1,needed do
		if #numTable == 0 then
            break
        else
            local roll = rng:RandomInt(#numTable)+1
            results[i] = numTable[roll]
            table.remove(numTable, roll)
        end
	end
	return results
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Ents.QuizQuestionPlacement.Var then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end, mod.Ents.QuizQuestionPlacement.ID)
