IsMoQuSaveManager  = include("quizscripts.save_manager")

IsMoQuSaveManager.Utility.AddDefaultRunData(IsMoQuSaveManager.DefaultSaveKeys.PLAYER, {moddquizSaveDat = {}})
IsMoQuSaveManager.Utility.AddDefaultFloorData(IsMoQuSaveManager.DefaultSaveKeys.PLAYER, {moddquizSaveDat = {}})
IsMoQuSaveManager.Utility.AddDefaultRoomData(IsMoQuSaveManager.DefaultSaveKeys.PLAYER, {moddquizSaveDat = {}})

IsMoQuSaveManager.Init(IsMoQu)
IsMoQu.SavMan = IsMoQuSaveManager