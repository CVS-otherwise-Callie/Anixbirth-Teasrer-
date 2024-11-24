
SaveManager  = include("scripts.save_manager")
SaveManager.Init(FHAC)

SaveManager.AddCallback(SaveManager.Utility.CustomCallback.POST_DATA_LOAD, function()
    FHAC.DSSavedata = SaveManager.GetSettingsSave()
        FHAC.DSSavedata.monsterReplacements = FHAC.DSSavedata.monsterReplacements or 2
        FHAC.DSSavedata.customFortunes = FHAC.DSSavedata.customFortunes or 1
        FHAC.DSSavedata.fortuneDeathChance = FHAC.DSSavedata.fortuneDeathChance or 3
        FHAC.DSSavedata.fortuneLanguage = FHAC.DSSavedata.fortuneLanguage or 1
        FHAC.DSSavedata.customRoomMusic = FHAC.DSSavedata.customRoomMusic or 1
    
        -- enemies --
        FHAC.DSSavedata.prettyMushlooms = FHAC.DSSavedata.prettyMushlooms or 1
end)
