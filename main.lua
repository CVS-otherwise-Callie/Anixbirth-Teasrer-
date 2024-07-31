FHAC = RegisterMod("Fivehead", 1)

StageAPI.UnregisterCallbacks("FHAC")


FHAC.Scripts = {
	Savedata = include("scripts.savedata"),
	Library = include("scripts.library"),
	Constants = include("scripts.constants"),
	Items = include("scripts.items"),
	EntitiesLua = StageAPI.AddEntities2Function(require("scripts.entities2")),
	IamScripts = include("scripts.iam.main"),
	
	Misc = {
		Fortunes = include("scripts.stolen.fiend folio.api.fortunehandling"),
		include("scripts.stolen.fiend folio.apioverride"),
		include("scripts.iam.misc.resources.fortunes"),
	},

}
--ff
FHAC.savedata = FHAC.savedata or {}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------