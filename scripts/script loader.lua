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

FHAC:LoadScripts("scripts.iam", {
	"cvsunlocks",
	"levelreplaceshit",
	"customgrids"
})

FHAC:LoadScripts("scripts.iam.effects", {
	"zapperteller_lightning",
	"blackboxoverlay"
})

FHAC:LoadScripts("scripts.iam.familiars", {
	"snark",
	"marketableplushie"
})

FHAC:LoadScripts("scripts.iam.items.actives", {
	"joke book",
	"straw doll"
})

FHAC:LoadScripts("scripts.iam.items.trinkets", {
	"mystery milk",
})

FHAC:LoadScripts("scripts.iam.items.passives", {
	"stinky mushroom",
	"anal fissure",
	"big ol' bowl of sauerkraut",
	"empty death certificate"
})

FHAC:LoadScripts("scripts.iam.items.pickups" , {
	"bowl of sauerkraut"
})

FHAC:LoadScripts("scripts.iam.jokes", {
	"gaprrr",
})

if not FHAC.hasloadedDSS then
	FHAC:LoadScripts("scripts.iam.deadseascrolls", {
		"dssmain",
	})
	FHAC.hasloadedDSS = true
end

FHAC:LoadScripts("scripts.iam.characters", {
	"johannes",
	"johannesb",
	"pongon"
})

FHAC:LoadScripts("scripts.iam.challenges", {
	"therealbestiary",
})
else
	include("scripts.iam.misc.warning")
end

FHAC:LoadScripts("scripts.choom", {
    "main"
})

FHAC:LoadScripts("scripts.TJP", {
    "main"
})