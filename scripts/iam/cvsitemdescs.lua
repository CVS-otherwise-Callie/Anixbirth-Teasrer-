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
    },
}

return CVS