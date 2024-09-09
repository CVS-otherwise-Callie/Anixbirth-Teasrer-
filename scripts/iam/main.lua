FHAC:LoadScripts("scripts.iam.monsters", {
	"fivehead",
	"floater",
	"neutralfly",
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
	"gassedfly"
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mod = FHAC
local rng = RNG()
local game = Game()
local player = Isaac.GetPlayer()
--this will get used at some point i swear


function mod.ShowFortuneDeath()
	if not mod.fortuneDeathChance == 0 then
		if rng:RandomInt(mod.fortuneDeathChance, 10) == 10 then 
			FHAC:ShowFortune()
		end 
	end
end