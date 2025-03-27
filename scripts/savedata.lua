
AnixbirthSaveManager  = include("scripts.save_manager")

AnixbirthSaveManager.Utility.AddDefaultRunData(AnixbirthSaveManager.DefaultSaveKeys.PLAYER, {anixbirthsaveData = {}})
AnixbirthSaveManager.Utility.AddDefaultRoomData(AnixbirthSaveManager.DefaultSaveKeys.PLAYER, {anixbirthsaveData = {}})
--AnixbirthSaveManager.Utility.AddDefaultRunData(AnixbirthSaveManager.DefaultSaveKeys.GLOBAL, {PreSavedEntsLevel = {}, SavedEntsLevel = {}, ToBeSavedEnts = {}})

AnixbirthSaveManager.Init(FHAC)
FHAC.AnixbirthSaveManager = AnixbirthSaveManager

AnixbirthSaveManager.AddCallback(AnixbirthSaveManager.Utility.CustomCallback.POST_DATA_LOAD, function()
        FHAC.DSSavedata = AnixbirthSaveManager.GetSettingsSave()
        FHAC.DSSavedata.monsterReplacements = FHAC.DSSavedata.monsterReplacements or 2
        FHAC.DSSavedata.customFortunes = FHAC.DSSavedata.customFortunes or 1
        FHAC.DSSavedata.fortuneDeathChance = FHAC.DSSavedata.fortuneDeathChance or 3
        FHAC.DSSavedata.fortuneLanguage = FHAC.DSSavedata.fortuneLanguage or 1
        FHAC.DSSavedata.customRoomMusic = FHAC.DSSavedata.customRoomMusic or 1
    
        -- enemies --
        FHAC.DSSavedata.prettyMushlooms = FHAC.DSSavedata.prettyMushlooms or 1
        FHAC.DSSavedata.pallunShot = FHAC.DSSavedata.pallunShot or 1
        FHAC.DSSavedata.randomDried = FHAC.DSSavedata.randomDried or 1

        local player = Isaac.GetPlayer()
end)