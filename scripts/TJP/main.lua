--chore: merge this by throwing it back into the constants file at the end


FHAC.TJPBosses = {
    Hop = FHAC:ENT("Hop"),
    Skip = FHAC:ENT("Skip"),
    Jump = FHAC:ENT("Jump")
}

FHAC.TJPJokes = {
    Willowalker = FHAC:ENT("Willowalker")
}

FHAC:MixTables(FHAC.Monsters, FHAC.TJPMonsters)
FHAC:MixTables(FHAC.Effects, FHAC.TJPEffects)
FHAC:MixTables(FHAC.Bosses, FHAC.TJPBosses)
FHAC:MixTables(FHAC.Jokes, FHAC.TJPJokes)

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
    "taintedyoyader",
    "hanges",
    "detacheddried",
    "firehead",
    "fivedead",
    "onedead"
})

FHAC:LoadScripts("scripts.TJP.bosses", {
    "hop",
    "skip",
    "jump"
})

FHAC:LoadScripts("scripts.TJP.effects", {
	"clatterteller_target",
    "ogwillowalkerbox",
    "ogwillowalkerfont"
})

FHAC:LoadScripts("scripts.TJP.jokes", {
    "willowalker"
})

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--FUNCTIOOOOOONSSSSSSAAH

local mod = FHAC
local rng = RNG()
local game = Game()

function mod:GetClosestPositionInArea(areacentrepos, arealimit, pos)
    return areacentrepos+(pos-areacentrepos):Resized(math.min(areacentrepos:Distance(pos), arealimit))--outdid myself with this one
end

function FHAC:TJPProjStuff(v)
	local d = v:GetData();

	FHAC.WillowalkerProj(v, d)
end