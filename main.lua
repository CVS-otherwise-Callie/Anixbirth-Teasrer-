FHAC = RegisterMod("Fivehead", 1)

StageAPI.UnregisterCallbacks("FHAC")


FHAC.Scripts = {
	Savedata = include("scripts.savedata"),
	Library = include("scripts.library"),
	Constants = include("scripts.constants"),
	Items = include("scripts.items"),
	EntitiesLua = StageAPI.AddEntities2Function(require("scripts.entities2")),
	Compatability = {
		include("scripts.compatability.fiend folio.modcompact"),
	},
	Callbacks = include("scripts.callbacks"),
	IamScripts = include("scripts.iam.main"),
	
	Misc = {
		Fortunes = include("scripts.stolen.fiend folio.api.fortunehandling"),
		include("scripts.stolen.fiend folio.apioverride"),
		include("scripts.iam.misc.resources.fortunes"),
		include("scripts.stolen.proapi.proapi"),
	},

}
--ff
FHAC.savedata = FHAC.savedata or {}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------