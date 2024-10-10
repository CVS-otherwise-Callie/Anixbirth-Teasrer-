SaveManager  = include("scripts.save_manager")
SaveManager.Init(FHAC)
SaveManager.Load(true)

FHAC.DSSavedata = SaveManager.GetDeadSeaScrollsSave()

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