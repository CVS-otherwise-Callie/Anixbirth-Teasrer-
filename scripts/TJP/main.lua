--chore: merge this by throwing it back into the constants file at the end
FHAC.TJPMonsters = {
    ClatterTeller = FHAC:ENT("Clatter Teller"),
    Dekatessera = FHAC:ENT("Dekatessera"),
    Roach = FHAC:ENT("Roach"),
    Weblet = FHAC:ENT("Weblet"),
    WebMother = FHAC:ENT("Web Mother"),
    StumblingNest = FHAC:ENT("Stumbling Nest"),
    TaintedWebMother = FHAC:ENT("Tainted Web Mother"),
    Yoyader = FHAC:ENT("Yoyader"),
    Hangeslip = FHAC:ENT("Hangeslip"),
    DetachedDried = FHAC:ENT("Detached Dried"),
    Fivedead = FHAC:ENT("Fivedead"),
    Onedead = FHAC:ENT("Onedead")
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
    "taintedwebmother",
    "yoyader",
    "hanges",
    "detacheddried",
    "fivedead",
    "onedead"
})

FHAC:LoadScripts("scripts.TJP.bosses", {
    "hop",
    "skip",
    "jump"
})

FHAC:LoadScripts("scripts.TJP.effects", {
	"clatterteller_target"
})

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FUNCTIOOOOOONSSSSSSAAH

local mod = FHAC
local rng = RNG()
local game = Game()

function mod:GetClosestPositionInArea(areacentrepos, arealimit, pos)
    return areacentrepos+(pos-areacentrepos):Resized(math.min(areacentrepos:Distance(pos), arealimit))--outdid myself with this one
end