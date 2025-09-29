local mod = FHAC
local rng = RNG()
local game = Game()
local sfx = SFXManager()

function mod:textToAscii(char)
	local ascii = string.byte(char)

	return ascii - 32
end

function mod:npcTalkWilloWalker(ef, sent, sentlen)
	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local bcenter = Vector(center.X, bottomright.Y - 300)
	local loopcount = 0
	local sprite = ef:GetSprite()
	local charX = 0
	local charY = 0

	ef:SetColor(Color.Default, 2, 1, false, false)
	ef:GetData().letterdelay = 1
    ef.Visible = true
	while loopcount < sentlen do
		loopcount = loopcount + 1
		charX = charX + 1
		local letter = string.sub(sent,loopcount,loopcount)
		local ascii = mod:textToAscii(letter)
		if string.sub(sent,loopcount,loopcount) == [[\]] then
			local letter = string.sub(sent,loopcount + 1,loopcount + 1)

			--EFFECTS
			if letter == "W" then --white text
				ef:SetColor(Color.Default, 2, 1, false, false)
			end

			if letter == "Y" then --yellow text
				ef:SetColor(Color(1,1,0,1), 2, 1, false, false)
			end

			if letter == "L" then --new line
				charX = 1
				charY = charY + 1
			end

			if letter == "U" then
				if ef:GetData().letterdelay > 0 then
					ef:GetData().letterdelay = ef:GetData().letterdelay - 1
				end
			end

			if letter == "D" then
				ef:GetData().letterdelay = ef:GetData().letterdelay + 1
			end

			loopcount = loopcount + 1
			charX = charX - 1

		else
			sprite:SetFrame(ascii)
			sprite:Render(Vector(bcenter.X + (charX * 9) - 200, (Isaac.GetScreenHeight() - 45) + (charY * 13)), Vector.Zero, Vector.Zero)
		end
	end
	ef.Visible = false
	if sentlen >= #sent then
		return true
	else
		return false
	end
end

function mod.onNPCTouch(entity, fn)
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
			if mod.NPCS[entity] then
				for _, i in  ipairs(Isaac.FindByType(mod.NPCS[entity].ID, mod.NPCS[entity].Var)) do
					if i:GetData().sizeMulti then
						if (math.abs(i.Position.X-p.Position.X) ^ 2 <= (i.Size*i.SizeMulti.X + p.Size) ^ 2) and (math.abs(i.Position.Y-p.Position.Y) ^ 2 <= (i.Size*i.SizeMulti.Y + p.Size) ^ 2) then
							fn(p, i)
						end
					else
						if i.Position:DistanceSquared(p.Position) <= (i.Size + p.Size) ^ 2 then
							fn(p, i)
						end
					end
				end	
			end
	end)
end

function mod.onEffectTouch(entity, fn)
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
		for name, ent in pairs(mod.Effects) do
			if ent.ID == entity.ID and entity.Var == ent.Var then
				for _, i in  ipairs(Isaac.FindByType(ent.ID, entity.Variant)) do
					if i:GetData().sizeMulti then
						if (math.abs(i.Position.X-p.Position.X) ^ 2 <= (i.Size*i.SizeMulti.X + p.Size) ^ 2) and (math.abs(i.Position.Y-p.Position.Y) ^ 2 <= (i.Size*i.SizeMulti.Y + p.Size) ^ 2) then
							fn(p, i)
						end
					else
						if i.Position:DistanceSquared(p.Position) <= (i.Size + p.Size) ^ 2 then
							fn(p, i)
						end
					end
				end	
			end
		end
	end)
end

local function split(pString, pPattern) --thanks ff
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
       end
       last_end = e+1
       s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
       cap = pString:sub(last_end)
       table.insert(Table, cap)
    end
    return Table
end

local function GetWordsAsTable(str)
	local word = ""
	local tab = {}
	for i = 1, #str + 1 do
		if not (string.sub(str, i, i) == "" or string.sub(str, i, i) == " ") then
			word = word .. string.sub(str, i, i)
		elseif word ~= "" then
			table.insert(tab, word)
			word = ""
		end
	end
	return tab
end

function mod:GetTextBoxTables(str, sentanceCap, paragrpahCap)

	local elTab = split(str, "\n")

	if paragrpahCap == 0 then
		paragrpahCap = 10^10 --highi number
	end

	local parTab = {}
	local curParagraph = {}

	local senTab = ""

	for rep = 1, #elTab do

		senTab = ""

		if elTab[rep] then
			local tab = GetWordsAsTable(elTab[rep])

			sentanceCap = sentanceCap or 12
			paragrpahCap = paragrpahCap or 3


			for i = 1, #tab+1 do

				if tab[i] then

					if #curParagraph+1 > paragrpahCap then
						table.insert(parTab, curParagraph)
						curParagraph = {}
					end

					if tab[i] ~= "" and #senTab + #tab[i] + 1 <= sentanceCap then
						senTab = senTab .. tab[i] .. " "
					elseif tab[i] ~= "" and #senTab + #tab[i] == sentanceCap then
						senTab = senTab .. tab[i]
					elseif senTab ~= "" then

						table.insert(curParagraph, senTab)
						senTab = tab[i] .. " "
					end
				end
			end
			table.insert(curParagraph, senTab)
		end
	end

	if #curParagraph+1 > paragrpahCap then
		table.insert(parTab, curParagraph)
		curParagraph = {}
	end

	if not (#curParagraph == 0) then
		table.insert(curParagraph, senTab)
		table.insert(parTab, curParagraph)
	end

	return parTab
end

function mod:GetStringPars(str, sentanceCap) 

	local elTab = split(str, "\n")
	local parsTab = {}
	local curSen = ""

	for rep = 1, #elTab do
		curSen = curSen .. "\n" .. elTab[rep]
		if rep%sentanceCap == 0 then
			table.insert(parsTab, curSen)
			curSen = ""
		end
	end

	if #elTab%sentanceCap ~= 0 then
		table.insert(parsTab, curSen)
	end

	return parsTab

end

function mod:DrawDialougeTalk(text, position, stats) -- time in seconds, rate in milliseconds

	stats = stats or {}

	local runDat = AnixbirthSaveManager.GetRunSave().anixbirthsaveData

	local rate = stats.rate or 5
	local senCap = stats.senCap or 17
	local parCap = stats.parCap or 3
	local scale = stats.scale or 1
	local font = stats.font or mod.TempestFont
	local overallRate = (#text+1)*rate
	local anchorPoint = stats.anchor or 1

	local n = tostring(runDat.diaNum)

	local str = mod:GetTextBoxTables(text, senCap, parCap)
	runDat.diaLouges[n] = {}
	local drawDiaStat = runDat.diaLouges[n]
	drawDiaStat.diaNum = drawDiaStat.diaNum or runDat.diaNum

	for nu = 1, overallRate do

		mod.scheduleCallback(function()

			if drawDiaStat.cancel then return end

			mod.IsDrawingText = true

			drawDiaStat.curParagraph = drawDiaStat.curParagraph or 1
			drawDiaStat.curSentance = drawDiaStat.curSentance or 1
			drawDiaStat.lastSen = drawDiaStat.lastSen or 0
			drawDiaStat.sentances = drawDiaStat.sentances or {}

			local trueSen = str[drawDiaStat.curParagraph][drawDiaStat.curSentance]
			local character = math.ceil((nu-drawDiaStat.lastSen)/rate)

			if nu%rate == 0 and trueSen ~= nil then

				if character > #trueSen then
					drawDiaStat.lastSen = nu
					table.insert(drawDiaStat.sentances, trueSen)
					drawDiaStat.curSentance = drawDiaStat.curSentance + 1
					trueSen = str[drawDiaStat.curParagraph][drawDiaStat.curSentance]
				end

			end

			if trueSen == nil and str[drawDiaStat.curParagraph+1] then
				drawDiaStat.curParagraph = drawDiaStat.curParagraph + 1
				drawDiaStat.curSentance = 1
				trueSen = str[drawDiaStat.curParagraph][drawDiaStat.curSentance]	
			elseif trueSen == nil then
				trueSen = ""
			end

			character = math.ceil((nu-drawDiaStat.lastSen)/rate)
			local choice = string.sub(trueSen, 1, character)

			for i = 1, drawDiaStat.curSentance do
				local xChange = 0
				if i == drawDiaStat.curSentance then

					if anchorPoint == 2 then
						xChange = (font:GetStringWidth(choice)*scale)/2
					end
					font:DrawStringScaled(choice, position.X - xChange, position.Y + 10*(i-1), scale, scale, KColor(1,1,1,0.5), 0, false)
				else
					local na = #drawDiaStat.sentances-drawDiaStat.curSentance+i+1

					if anchorPoint == 2 then
						xChange = (font:GetStringWidth(drawDiaStat.sentances[na])*scale)/2
					end

					font:DrawStringScaled(drawDiaStat.sentances[na], position.X - xChange, position.Y + 10*(i-1), scale, scale, KColor(1,1,1,0.5), 0, false)
				end
			end
		
			if nu == overallRate then
				runDat.diaNum = runDat.diaNum + 1
				runDat.finishedDias[tostring(drawDiaStat.diaNum)] = {str, position, scale}
				drawDiaStat.isFinished = true
			else
				drawDiaStat.isFinished = false
			end

		end, nu, ModCallbacks.MC_POST_RENDER, false)
	end

	return drawDiaStat

end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()

	if AnixbirthSaveManager.IsLoaded() and AnixbirthSaveManager.GetRunSave().anixbirthsaveData then
		AnixbirthSaveManager.GetRunSave().anixbirthsaveData.diaLouges = AnixbirthSaveManager.GetRunSave().anixbirthsaveData.diaLouges or {}
		AnixbirthSaveManager.GetRunSave().anixbirthsaveData.finishedDias = AnixbirthSaveManager.GetRunSave().anixbirthsaveData.finishedDias or {}
		AnixbirthSaveManager.GetRunSave().anixbirthsaveData.diaNum = AnixbirthSaveManager.GetRunSave().anixbirthsaveData.diaNum or 0
	end
end)