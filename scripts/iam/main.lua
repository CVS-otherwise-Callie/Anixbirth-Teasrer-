----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mod = FHAC
local rng = RNG()
local game = Game()
local player = Isaac.GetPlayer()


mod.LuaFont = Font()
mod.LuaFont:Load("font/luaminioutlined.fnt")

local rng = RNG()
function mod:ShowRoomText()
	local room = StageAPI.GetCurrentRoom()
	local rDD = game:GetLevel():GetCurrentRoomDesc().Data
	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local scale = 1 --make this dss changeable?
	local text = ""
	local vartext = ""
	local bcenter = Vector(center.X, bottomright.Y - 152 * 2)
	local ismodtext = false
	local useVar = rDD.Variant

	if not game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then

		if room and room.Layout then
			text = text .. tostring(room.Layout.Variant) .. " " .. room.Layout.Name
		else
			if useVar >= 45000 and useVar <= 60000 then
				ismodtext = true
				useVar = useVar - 44999
				text = "(HOPE) "
			end

			text = text .. rDD.Name
			vartext = tostring(useVar)
		end

		if not ismodtext then

			--dont question the process
			if rDD.Type ~= 5 then
				if text and string.find(text, "New Room") or string.find(text, "copy") or string.find(text, "Copy") or text == "" or string.find(text, "Shop") or string.find(text, "Dungeon") then
					text = game:GetLevel():GetName()
				end
			end

			if rDD.Type ~= 5 and rDD.Type ~= 6 and rDD.Type ~= 27 and rDD.Type ~= 24 and rDD.Type >= 2 then
				text = text .. ": " .. mod:GetRoomNameByType(rDD.Type)
			elseif rDD.Type == 5 then
				text = mod:removeSubstring(text, "(copy)")
			elseif rDD.Type == 6 then
				text = mod:GetRoomNameByType(rDD.Type) .. ": " .. text
			end

		end

		if Isaac.GetChallenge() == Challenge.CHALLENGE_DELETE_THIS then
			if not game:IsPaused() then
			local pastext = text
			text = ""
			for i = 0, tonumber(string.len(pastext)) do
				local letter = string.sub(pastext, i, i)
				local randint = math.random(1, 15)
				if randint == 1 then
					letter = string.char(math.random(65, 65 + 25))
				elseif randint == 2 then
					letter = string.char(math.random(65, 65 + 25)):lower()
				end
				text = text..letter
			end
			local pastext = vartext
			vartext = ""
			for i = 0, tonumber(string.len(pastext)) do
				if i ~= "-" or i ~= "" then
				local letter = string.sub(pastext, i, i)
				if math.random(1, 5) == 1 then
					letter = math.random(1, 9)
				end
				vartext = vartext..tostring(letter)
				end
			end
			if math.random(3) == 3 then
				glitchedtext = text
				glitchedvar = vartext
			end
			end
		else
			glitchedtext = nil
			glitchedvar = nil
		end

		local y = Isaac.GetScreenHeight() / 3 - 104

		if not glitchedtext then
			if text and #text ~= 0 then text = "- " .. text .. " -" end
			if vartext and #vartext ~= 0 then vartext = "- "..vartext.." -" end
		else
			if text and #text ~= 0 then text = "- "..glitchedtext.." -" end
			if vartext and #vartext ~= 0 and not StageAPI.GetCurrentRoom() then vartext = "- "..glitchedvar.." -" end
		end

		if StageAPI.GetCurrentRoom() then
			text = mod:removeSubstring(text, StageAPI:GetCurrentRoomID())
		end

		local size = mod.LuaFont:GetStringWidth(text) * scale
		local varsize = mod.LuaFont:GetStringWidth(vartext) * scale

		--bcenter = player.Position
		mod.LuaFont:DrawStringScaled(text, bcenter.X - (size/2), y, scale, scale, KColor(1,1,1,0.5), 0, false)
		mod.LuaFont:DrawStringScaled(vartext, bcenter.X - (varsize / 2), y + 10, scale, scale, KColor(1,1,1,0.5), 0, false)

	end
end

function mod:ShowFortuneDeath()
	if mod.DSSavedata.fortuneDeathChance ~= 0 and mod.DSSavedata.customFortunes == 1 then
		if math.random(mod.DSSavedata.fortuneDeathChance, 10) == 10 then 
			FHAC:ShowFortune()
		end 
	end
end

function mod:SpawnRandomDried()
	local game = Game()
    local level = game:GetLevel()
    local roomDescriptor = level:GetCurrentRoomDesc()
    local roomConfigRoom = roomDescriptor.Data
	if mod.spawnedDried~=0 and not mod:CheckForEntInRoom({Type = mod.Monsters.Dried.ID, Variant = mod.Monsters.Dried.Var, SubType = 0}, true, true, false) and game:GetLevel():GetCurrentRoomDesc().Data.Type == 1 and game:GetLevel():GetCurrentRoomDesc().Data.Variant <= 1151 and roomConfigRoom.StageID==2 then
		mod.driedRooms = {}
		for i = 0,  math.random(FHAC.DSSavedata.randomDried) do
			local pos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(0), 1, true, false)
			local dried = Isaac.Spawn(mod.Monsters.Dried.ID, mod.Monsters.Dried.Var, 6, pos, Vector.Zero, nil)
            dried:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
	mod.spawnedDried = true
end
