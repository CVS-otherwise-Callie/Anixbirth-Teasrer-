local CVS = {}
--[[
-- Specific strings that will be replaced with something else. This is used to convert Shortcuts into internal markup.
EID.TextReplacementPairs = {
	{"!!!", "{{Warning}}"}, -- Turn 3 Exclamations into Warning
	{"↑", "{{ArrowUp}}"}, -- Up Arrow
	{"↓", "{{ArrowDown}}"}, -- Down Arrow
	{"\1", "{{ArrowUp}}"}, -- Legacy Up Arrow
	{"\2", "{{ArrowDown}}"}, -- Legacy Down Arrow
	{"\3", "{{Warning}}"}, -- Legacy Warning
	{"\6", "{{Heart}}"}, -- Legacy Heart
	{"\5", "{{Key}}"}, -- Legacy Key
	{"\015", "{{Coin}}"}, -- Legacy Coin
	{"\8\189", "{{Bomb}}"}, -- Legacy BOMB
	{"{{Hashtag}}", "ǂ"}, -- Hashtag
	{"{{CR}}", "{{ColorReset}}"}, -- Shortcut for Color Resetting
	{"{{EthernalHeart}}", "{{EternalHeart}}"}, -- fix spelling error
	{"{{CONFIG_BoC_Toggle}}", function(_) return EID.ButtonToIconMap[EID.Config["BagOfCraftingToggleKey" or "{{ButtonSelect}}" end},
	-- more common/official names
	{"{{MimicChest}}", "{{TrapChest}}"},
	{"{{EternalChest}}", "{{HolyChest}}"},
	{"{{BombChest}}", "{{StoneChest}}"},
	{"{{OldChest}}", "{{DirtyChest}}"},
	{"{{CurseRoom}}", "{{CursedRoom}}"},
	{"{{Crawlspace}}", "{{LadderRoom}}"},
	{"{{GoldHeart}}", "{{GoldenHeart}}"},
}]]

CVS.ExDescs = {
	COLLECTIBLES = {
		{
			ID = FHAC.Collectibles.Items.BigOlBowlofSauerkraut,
			EID = {
				Desc = "Spawns 1-3 Bowls of Sauerkraut in a active room#\1Bowls of Sauerkraut give compounding damage for the floor#Spawns 1-3 Bowls on Pickup"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.StinkySocks,
			EID = {
				Desc = "\1+0.1 speed#A poison cloud follows Isaac#Standing in the same place for a elongated period of time will make the cloud grow incrementally#Moving again will reset it"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.LetterToMyself,
			EID = {
				Desc = "Spawns a mailed letter on new floor#Letter has certain pickups inside based on floor#If not picked up, will appear on the next floor with increasingly better pickups#{{Warning}}Disappears and teleports away from floor after a bit"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.GrosMichel,
			EID = {
				Desc = "\1 1.5x Damage Multiplier #{{Warning}}Has a 15% chance to expire in a new room"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.Tums,
			EID = {
				Desc = "Whenever Isaac eats a pill, heals 1 red heart. #Whenever Isaac takes a red heart from off the ground, 25% chance to spawn a random pill."
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.CorruptedFile,
			EID = {
				Desc = "Don't use this#I am being serious#\2 \2 \2"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.JokeBook,
			EID = {
				Desc = "On use, gives all enemies fear for a couple seconds#\1Isaac gets a temporary small tear boost based on enemy amount#Tells a bad joke"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
		{
			ID = FHAC.Collectibles.Items.StrawDoll,
			EID = {
				Desc = "On use, makes it a nerfed damage is applied to all enemies when one is hit#Isaac passively will deal 40 damage to all enemies when hit"
			},
			Encyclopedia = Encyclopedia and {
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
				}
			},
		},
    },
}

return CVS
