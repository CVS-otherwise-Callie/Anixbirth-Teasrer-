--chore: merge this by throwing it back into the constants file at the end
FHAC.TJPMonsters = {
    ClatterTeller = FHAC:ENT("Clatter Teller"),
    Dekatessera = FHAC:ENT("Dekatessera"),
    Roach = FHAC:ENT("Roach"),
    Weblet = FHAC:ENT("Weblet"),
    WebMother = FHAC:ENT("Web Mother"),
    StumblingNest = FHAC:ENT("Stumbling Nest"),
    TaintedWebMother = FHAC:ENT("Tainted Web Mother")
}

FHAC:MixTables(FHAC.Monsters, FHAC.TJPMonsters)

FHAC:LoadScripts("scripts.TJP.monsters", {
    "gobbo",
    "sho",
    "clatterteller",
    "dekatessera",
    "onehead",
    "roach",
    "weblet",
    "webmother",
    "stumblingnest",
    "taintedwebmother"
})

FHAC:LoadScripts("scripts.TJP.bosses", {
    "hop",
    "skip",
    "jump"
})

FHAC:LoadScripts("scripts.TJP.effects", {
	"clatterteller_target"
})