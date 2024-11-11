SaveManager  = include("scripts.save_manager")
SaveManager.Init(FHAC)
SaveManager.Load()

FHAC.DSSavedata = SaveManager.GetDeadSeaScrollsSave()
if not FHAC.DSSavedata then
    FHAC.DSSavedata.monsterReplacements = FHAC.DSSavedata.monsterReplacements or 2
    FHAC.DSSavedata.customFortunes = FHAC.DSSavedata.customFortunes or 1
    FHAC.DSSavedata.fortuneDeathChance = FHAC.DSSavedata.fortuneDeathChance or 3
    FHAC.DSSavedata.fortuneLanguage = FHAC.DSSavedata.fortuneLanguage or 1

    -- enemies --
    FHAC.DSSavedata.prettyMushlooms = FHAC.DSSavedata.prettyMushlooms or 1
end

FHAC:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	Isaac.DebugString("PREGAMEEXITPRESAVE")
    SaveManager.Save()
	Isaac.DebugString("PREGAMEEXITPOSTSAVE")
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if FHAC.gamestarted then
        SaveManager.Save()
    end
end)

--end of fiend folio