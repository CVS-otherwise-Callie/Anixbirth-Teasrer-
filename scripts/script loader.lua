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
	"iam.main",
	"callbacks",
	"iam.misc.resources.fortunes",
	"library",
	"items",
	"entities2",
	"compatability.fiend folio.modcompact",
	"otherapi.fiend folio.api.fortunehandling",
	"otherapi.fiend folio.api.apioverride",
	"otherapi.proapi.proapi",
})

--iam stuff
FHAC:LoadScripts("scripts.iam.monsters", {
	"fivehead",
	"floater",
	"neutralfly",
	"patient",
	"dried",
	"erythorcyte",
	"wost",
	"schmoot",
	"snidge",
	"drosslet",
	"pitpat",
	"mushloom",
	"pinprick",
	"synthetichorf",
	"gassedfly",
	"fly_ve-bomber", --HAHAHAH FUCK YOU EUAN TOO
	"pallun",
	"sillystring",
	"stickyfly",
	"wispwosp",
	"stuckpoot",
	"rainmonger",
	"zapperteller"
})

FHAC:LoadScripts("scripts.iam", {
	"cvsunlocks",
	"levelreplaceshit",
})

FHAC:LoadScripts("scripts.iam.effects", {
	"zapperteller_lightning",
})

FHAC:LoadScripts("scripts.iam.familiars", {
	"snark",
})

FHAC:LoadScripts("scripts.iam.items", {
	"stinky mushroom",
})

FHAC:LoadScripts("scripts.iam.jokes", {
	"gaprrr",
})

FHAC:LoadScripts("scripts.iam.deadseascrolls", {
	"dssmain",
})

FHAC:LoadScripts("scripts.iam.characters", {
	"johannes",
	"pongon"
})

FHAC:LoadScripts("scripts.iam.challenges", {
	"therealbestiary",
})
else
	include("scripts.iam.misc.warning")
end
