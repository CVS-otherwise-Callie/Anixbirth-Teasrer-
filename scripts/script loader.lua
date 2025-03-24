function FHAC:LoadScripts(includestart, t)
    for k, v in ipairs(t) do
        if includestart then v= includestart.."." .. v end
        include(v)
    end
end

if StageAPI and StageAPI.Loaded then
StageAPI.UnregisterCallbacks("FHAC")
FHAC:LoadScripts("scripts", {
	"savedata",
	"otherapi.fiend folio.api.fiendfolioapi",
	"constants",
	"library",
	"iam.main",
	"callbacks",
	"iam.misc.resources.fortunes",
	"items",
	"entities2",
	"compatability.fiend folio.modcompact",
	"otherapi.fiend folio.api.fortunehandling",
	"otherapi.fiend folio.api.apioverride",
	"otherapi.proapi.proapi",
	"deathtransform",
})
FHAC:LoadScripts("scripts.choom", {
    "main"
})

FHAC:LoadScripts("scripts.TJP", {
    "main"
})

else
	include("scripts.iam.misc.warning")
end