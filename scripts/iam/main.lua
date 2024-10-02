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
	"sillystring"
})

FHAC:LoadScripts("scripts.iam", {
	"levelreplaceshit"
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
	if mod.fortuneDeathChance == nil then mod.fortuneDeathChance = 5 end
	if mod.fortuneDeathChance ~= 0 then
		if rng:RandomInt(mod.fortuneDeathChance, 10) == 10 then 
			FHAC:ShowFortune()
		end 
	end
end