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