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
	"iam.misc.resources.fortunes",
	"otherapi.fiend folio.api.fortunehandling",
	"otherapi.fiend folio.api.apioverride",
	"otherapi.proapi.proapi"
})
--ff
else
	include("scripts.iam.misc.warning")
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------