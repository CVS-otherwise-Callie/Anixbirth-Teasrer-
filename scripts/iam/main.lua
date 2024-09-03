local mod = FHAC
local rng = RNG()
local game = Game()
local player = Isaac.GetPlayer()
--this will get used at some point i swear
FHAC.Scripts = {
    Monsters = {
		Fivehead = include("scripts.iam.monsters.fivehead"),
		Floater = include("scripts.iam.monsters.floater"),
		Neutralfly = include("scripts.iam.monsters.neutralfly"),
		Dried = include("scripts.iam.monsters.dried"),
		Erythorcyte = include("scripts.iam.monsters.erythorcyte"),
		Wost = include("scripts.iam.monsters.wost"),
		Schmoot = include("scripts.iam.monsters.schmoot"),
		Snidge = include("scripts.iam.monsters.snidge"),
		Drosslet = include("scripts.iam.monsters.drosslet"),
		PitPat = include("scripts.iam.monsters.pitpat"),
		MushLoom = include("scripts.iam.monsters.mushloom"),
		Pinprick = include("scripts.iam.monsters.pinprick"),
		SyntheticHorf = include("scripts.iam.monsters.synthetichorf"),
	},

	Familiars = {
		Snark = include("scripts.iam.familiars.snark")
	},

	Items = {
		StinkyMushroom = include("scripts.iam.items.stinky mushroom"),
	},

	Jokes = {
		Gaperrr = include("scripts.iam.jokes.gaprrr"),
	},

    DSS = {
		DeadSeaScrolls = include("scripts.iam.deadseascrolls.dssmain")
	},
    
    Characters = {
        Johannes = include("scripts.iam.characters.johannes"),
		Pongon = include("scripts.iam.characters.pongon")
    },

	Config = {
		include("scripts.iam.levelreplaceshit")
	},
	Challenges = {
	include("scripts.iam.challenges.therealbestiary")
	}
}

function mod.ShowFortuneDeath()
	if not mod.fortuneDeathChance == 0 then
		if rng:RandomInt(mod.fortuneDeathChance, 10) == 10 then 
			FHAC:ShowFortune()
		end 
	end
end