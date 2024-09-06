FHAC = RegisterMod("Fivehead", 1)

function FHAC:LoadScripts(includestart, t)
    for k, v in ipairs(t) do
        if includestart then v= includestart.."." .. v end
        include(v)
    end
end

if REPENTOGON and StageAPI and StageAPI.Loaded then
StageAPI.UnregisterCallbacks("FHAC")
FHAC:LoadScripts("scripts", {
	"savedata",
	"library",
	"constants",
	"items",
	"entities2",
	"compatability.fiend folio.modcompact",
	"callbacks",
	"iam.main",
	"stolen.fiend folio.api.fortunehandling",
	"stolen.fiend folio.api.apioverride",
	"iam.misc.resources.fortunes",
	"stolen.proapi.proapi"
})
--ff
FHAC.savedata = FHAC.savedata or {}
else
	include("scripts.iam.misc.warning")
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------