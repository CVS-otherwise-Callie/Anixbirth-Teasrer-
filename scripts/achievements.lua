local mod = FHAC
local game = Game()

FHAC.ACHIEVEMENT = {
    { -- not actually a achievement lol
		ID = "HOPEANIXBIRTH",
		Note = "playmod",
		Tooltip = {"playing", "anixbirth"},
		Tags = {"FHAC"}
	},
}

-- setting it up reminiscent of Fiend Folio (except for the dss ig)

-- chorse:
--- add a init for achievements
--- add a unlock function (for achievement)
--- add a check function
--- add a callback replacement function (for things)


local FHACAchievements = {}

for i = 1, #FHAC.ACHIEVEMENT do
	local ach = FHAC.ACHIEVEMENT[i]

	FHACAchievements[i] = ach

	if ach.Item then
		FHACAchievements["ITEM_" .. string.upper(ach.ID)] = i
	elseif ach.Trinket then
		FHACAchievements["TRINKET_" .. string.upper(ach.ID)] = i
	elseif ach.Player then
		FHACAchievements["PLAYER_" .. string.upper(ach.ID)] = i
	else
		FHACAchievements[string.upper(ach.ID)] = i
	end

end

function FHACAchievements:Setup()

	if AnixbirthSaveManager.GetSettingsSave().lockall == 2 then
		FHAC.TEMPORARYUNLOCK = true
	else
		FHAC.TEMPORARYUNLOCK = false
	end

	local save = AnixbirthSaveManager.GetPersistentSave()
	save.FHACAchievements = save.FHACAchievements or {}

	for i = 1, #FHACAchievements do

			local name = tostring(FHACAchievements[i].ID)

			--[[if FHACAchievements[i].Item then
				if save.FHACAchievements[name].Item and save.FHACAchievements[name] then
				end
			elseif FHACAchievements[i].Trinket then
			elseif FHACAchievements[i].Player then
			end]]

			save.FHACAchievements[name] = save.FHACAchievements[name] or {}

			for na, player in pairs(mod.Players) do
				local correctedName = string.lower(tostring(na))
				local highNum = string.upper(string.sub(correctedName,1,1))
				correctedName = highNum  .. string.sub(correctedName, 2, string.len(correctedName)) --fixing

				if mod:CheckTableContents(FHACAchievements[i].Tags, tostring(correctedName)) then
					save["Unlock" .. FHACAchievements[i]["Tags"][1]] = FHACAchievements[i]["Tags"][2]
				end	
			end
		

			local itemSave = save.FHACAchievements[name]
			
			if itemSave.Locked == nil then
				itemSave.Locked = true
			elseif itemSave.Locked then
				if FHAC.TEMPORARYUNLOCK then
					itemSave.TempLock = true
					itemSave.Locked = false
				end
			elseif itemSave.TempLock == true and not FHAC.TEMPORARYUNLOCK then
				itemSave.Locked = true
			end

	end
end

function FHACAchievements:Unlock(ID, shouldShowNote)
	local save = AnixbirthSaveManager.GetPersistentSave()
	local ach = FHACAchievements[ID]
	shouldShowNote = shouldShowNote or false
	if tonumber(ach) then
		ach = FHACAchievements[ach]
	end

	if not save.FHACAchievements then
		error("Save has not been set up yet!")
	end

	if not ach or not ID or not ach.ID then
		error("ID or Achievement Given was a nil value!")
	end

	if FHACAchievements:IsUnlocked(ID) then return end

	if shouldShowNote then
		mod.QueueAchievementNote("gfx/ui/achievement/achievement_" .. string.lower(ach.ID) ..".png")
	end

	save.FHACAchievements[ach.ID].Locked = false
	save.FHACAchievements[ach.ID].TempLock = false
end

function FHACAchievements:IsUnlocked(ID)
	local save = AnixbirthSaveManager.GetPersistentSave()
	local ach = FHACAchievements[ID]
	if tonumber(ach) then
		ach = FHACAchievements[ach]
	elseif not ach and save.FHACAchievements[ID] then
		return save.FHACAchievements[ID].Locked == false
	end

	if not save.FHACAchievements then
		error("Save has not been set up yet!")
	end

	if not ach or not ID or not ach.ID then
		error("ID or Achievement Given was a nil value!")
	end

	return save.FHACAchievements[ach.ID].Locked == false
end

function FHACAchievements.RemoveLockedCollectiblesFromPool()
	local pool = Game():GetItemPool()
	for i = 1, #FHACAchievements do
		if FHACAchievements[i].Item and 
		not FHACAchievements:IsUnlocked("ITEM_" .. FHACAchievements[i].ID) then
			pool:RemoveCollectible(FHACAchievements[i].Item)
		end
	end
end

-- setup for completion marks...

function FHACAchievements.AddEntitiesToUnlocks(npc, player, ID)
	local save = AnixbirthSaveManager.GetPersistentSave()

	if not tonumber(ID) then
		ID = FHACAchievements[ID]
	end
	if not tonumber(ID) then
		error("Gave invalid variable to ACHIEVEMENT slot!")
	end

	local ach = FHACAchievements[ID]

	if not npc.Type and tonumber(npc[1]) then
		npc = {Type = npc[1], Variant = (npc[2] or 0), SubType = (npc[3] or 0)}
	elseif not npc.Type then
		error("Gave invalid variable to NPC Slot!")
	end

	if not player then
		error("Gave invalid to PLAYER slot!")
	end

	local correctedName = string.lower(tostring(player))
	local highNum = string.upper(string.sub(correctedName,1,1))
	correctedName = highNum  .. string.sub(correctedName, 2, string.len(correctedName)) --fixing

	if mod:CheckTableContents(ach.Tags, tostring(correctedName)) then
		mod:NestVariable(save, ID, "Unlock" .. correctedName , tostring(npc.Type),  tostring(npc.Variant))
	end	
end

function FHACAchievements.UnlockToEntityKill(npc)
	local save = AnixbirthSaveManager.GetPersistentSave()

	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer()
		local correctedName = string.lower(tostring(player:GetName()))
		local highNum = string.upper(string.sub(correctedName,1,1))
		correctedName = highNum  .. string.sub(correctedName, 2, string.len(correctedName)) --fixing

		local unlock = mod:GetNestedVariable(save, "Unlock" .. correctedName , tostring(npc.Type),  tostring(npc.Variant))
		if unlock and not FHACAchievements:IsUnlocked(unlock) then
			FHACAchievements:Unlock(unlock, true)
		end
	end
end


-- thanks ff for giantbook manager --------------------------------------------------------------------------------------------------------------------------
local paused
local pausedAt
local pauseDuration = 0
local forceUnpause
local justForcedUnpause

function mod.PauseGame(frames, force)
	if game:GetRoom():GetBossID() ~= 54 or force then -- Intentionally fail achievement note pauses on Lamb, since it breaks the Victory Lap menu super hard
		for _, projectile in pairs(Isaac.FindByType(9)) do
			projectile:Remove()

			local poof = Isaac.Spawn(1000, 15, 0, projectile.Position, Vector.Zero, nil)
			poof.SpriteScale = Vector.One * 0.75
		end

		for _, pillar in pairs(Isaac.FindByType(951, 1)) do
			pillar:Kill()
			pillar:Remove()
		end

		pausedAt = pausedAt or game:GetFrameCount()
		pauseDuration = pauseDuration + frames
		paused = true

		Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
	end
end

local achievementSprite = Sprite()
local achievementUpdate = false
local renderAchievement = false

achievementSprite:Load("gfx/ui/achievement/_FHAC_achievement.anm2", true)

local achievementNoteQueue = {}
function mod.QueueAchievementNote(gfx)
	table.insert(achievementNoteQueue, gfx)
end

function mod.PlayAchievementNote(gfx)
	if Options.DisplayPopups then
		mod.PauseGame(41)

		achievementSprite:ReplaceSpritesheet(2, gfx)
		achievementSprite:LoadGraphics()
		achievementSprite:Play("Idle", true)

		achievementUpdate = false
		renderAchievement = true

		SFXManager():Play(SoundEffect.SOUND_CHOIR_UNLOCK)
	end
end

function mod.IsPlayingAchievementNote()
	return renderAchievement
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	local player = Isaac.GetPlayer()
	if not renderAchievement and #achievementNoteQueue > 0 
	and (not DeadSeaScrollsMenu or (not DeadSeaScrollsMenu.IsOpen() and (not DeadSeaScrollsMenu.QueuedMenus or #DeadSeaScrollsMenu.QueuedMenus == 0))) 
	and player.ControlsEnabled and player.ControlsCooldown == 0 then
		mod.PlayAchievementNote(achievementNoteQueue[1])
		table.remove(achievementNoteQueue, 1)
	end
end)

local function doRender()
	if renderAchievement then
		if achievementUpdate then
			achievementSprite:Update()
		end
		achievementUpdate = not achievementUpdate
	
		local position = game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286) / 2
		achievementSprite:Render(position - Vector(20, 0), Vector.Zero, Vector.Zero)

		if achievementSprite:IsFinished() then
			renderAchievement = false
		end
	end
end

if StageAPI then
	mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName) -- Hijack the existance of the StageAPI shader to render over the hud
		if shaderName == "StageAPI-RenderAboveHUD" then
			doRender()
		end
	end)
else
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, doRender)
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	justForcedUnpause = nil
	if pausedAt and pausedAt + pauseDuration < game:GetFrameCount() then
		paused = false
		pausedAt = nil
		pauseDuration = 0

		forceUnpause = true
	end

	local save = AnixbirthSaveManager.GetPersistentSave()
end)

for hook = InputHook.IS_ACTION_PRESSED, InputHook.IS_ACTION_TRIGGERED do
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
		if paused and action ~= ButtonAction.ACTION_CONSOLE then
			return false
		end
	end, hook)
end

mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
	if paused and action ~= ButtonAction.ACTION_CONSOLE then
		return 0
	elseif forceUnpause and action == ButtonAction.ACTION_SHOOTDOWN then
		forceUnpause = false
		justForcedUnpause = true
		return 0.75
	end
end, InputHook.GET_ACTION_VALUE)

-- ok done thanking ----------------------------------------------------------------------------------------------------------------------

FHAC:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continuing)
	FHACAchievements:Setup()
	FHACAchievements.RemoveLockedCollectiblesFromPool()
end)

FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	FHACAchievements.UnlockToEntityKill(npc)
end)

FHAC:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	local save = AnixbirthSaveManager.GetPersistentSave()

	local entTab = {

	}

	for _, v in ipairs(entTab) do
		if mod:GetNestedVariable(save, "Unlock" .. v[2], v[1][1], v[1][2]) == false then
			FHACAchievements.AddEntitiesToUnlocks(v[1], v[2], v[3])
		end
	end
end)

return FHACAchievements
