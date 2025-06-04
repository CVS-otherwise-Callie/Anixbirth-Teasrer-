local mod = FHAC
local game = Game()

mod.isRepentance = REPENTANCE

--shit that's kinda all over the place, please put in alphabetical
FHAC.font = Font()
--needed rn, likely will delete later

function FHAC:ENT(name)
    return { ID = Isaac.GetEntityTypeByName(name), Var = Isaac.GetEntityVariantByName(name), Sub = Isaac.GetEntitySubTypeByName(name) }
end

FHAC.Monsters = {
}

FHAC.Bosses = {
    Hop = mod:ENT("Hop"),
    Skip = mod:ENT("Skip"),
    Jump = mod:ENT("Jump")
}

FHAC.MiniBosses = {
    Narcissism = mod:ENT("Narcissism"),
    Chomb = mod:ENT("Chomb")
}

FHAC.Players = {
    Johannes = Isaac.GetPlayerTypeByName("Johannes"),
    Bohannes = Isaac.GetPlayerTypeByName("Johannes", true),
    Pongon = Isaac.GetPlayerTypeByName("Pongon")
}

FHAC.Grids = {
    GlobalGridSpawner = mod:ENT("HOPE Grid Spawner")
}

FHAC.Familiars = {
    Snark = mod:ENT("Snark (Half Life)"),
    MarketablePlushie = mod:ENT("Marketable Plushie Familiar"),
    LilAna = mod:ENT("Lil' Ana")
}

FHAC.Effects = {

}

FHAC.NPCS = {
    Skeleton = mod:ENT("Skeleton NPC"),
}

FHAC.Jokes = {
    Gaperrr = mod:ENT("A gaper w/ three legs, why did we do this"),
}

FHAC.Savedata = {
    DeathFortunes = true,
}

FHAC.Challenges = {
    Bestiary = Isaac.GetChallengeIdByName("[ANIX] The Real Bestiary")
}

mod.Sounds = {
    TombstoneMove = Isaac.GetSoundIdByName("tombstone_move"),
    AltTrapdoorBang = Isaac.GetSoundIdByName("alt_trapdoor_bang"),
    SpinSound = Isaac.GetSoundIdByName("yoyaderspinsound"),
    SpinSoundEnd = Isaac.GetSoundIdByName("yoyaderspinsoundend")
}

FHAC.Collectibles = {
    Items = {
        StinkyMushroom = Isaac.GetItemIdByName("Stinky Mushroom"),
        BigBowlOfSauerkraut = Isaac.GetItemIdByName("Big Ol' Bowl of Sauerkraut"),
        JokeBook = Isaac.GetItemIdByName("Joke Book"),
        StrawDoll = Isaac.GetItemIdByName("Straw Doll"),
        EmptyDeathCertificate = Isaac.GetItemIdByName("Empty Death Certificate"),
        MarketablePlushie = Isaac.GetItemIdByName("Marketable Plushie"),
        StinkySocks = Isaac.GetItemIdByName("Stinky Socks"),
        MoldyBread = Isaac.GetItemIdByName("Moldy Bread"),
	    CorruptedFile = Isaac.GetItemIdByName("Corrupted File"),
	    TheBell = Isaac.GetItemIdByName("The Bell"),
    	LilAna = Isaac.GetItemIdByName("Lil Ana"),
    },
    PickupsEnt = {
        BowlOfSauerkraut = mod:ENT("Bowl of Sauerkraut"),
        BirthdaySlice = mod:ENT("Birthday Slice")
    },
    Pickups = {
        BirthdaySlice = Isaac.GetCardIdByName("Birthday Slice")
    },
    Trinkets = {
        MysteryMilk = Isaac.GetTrinketIdByName("Mystery Milk"),
	    TheLeftBall = Isaac.GetTrinketIdByName("The Left Ball")
    }
}

FHAC.Grids = {
    Pits = {
        Basement = "gfx/grid/pit_basement.png",
        Catacombs = "gfx/grid/pit_catacombs.png"
    },
    GlobalGridSpawner = mod:ENT("HOPE Grid Spawner")
}

mod.FloorGrids = {
    mod.BasementGrid
}

mod.ClatterTellerWhitelist = { --pretty much just the skullitsit whitelist LMAO
	{EntityType.ENTITY_GLOBIN,-1,-1,true,true},
	{EntityType.ENTITY_MOTER,-1,-1,true,true},
	{EntityType.ENTITY_BLACK_BONY,-1,-1,true,true},
    {29,2,-1,true,true},
	{EntityType.ENTITY_BOOMFLY,-1,-1,true,true}, 
	{EntityType.ENTITY_SUCKER,2,-1,true}, --Soul Sucker
	{EntityType.ENTITY_SUCKER,-1,-1,false}, 
	{EntityType.ENTITY_FULL_FLY,-1,-1,false}, 
	{EntityType.ENTITY_BLACK_BONY,-1,-1,false,true},
	{EntityType.ENTITY_POOFER,-1,-1,true}, 
	{EntityType.ENTITY_MIGRAINE,-1,-1,true,true},
	{EntityType.ENTITY_DUKE,-1,-1,true}, 
	{EntityType.ENTITY_MULLIGAN,-1,-1,true,true},
	{EntityType.ENTITY_NEST,-1,-1,true,true},
	{EntityType.ENTITY_HIVE,-1,-1,true,true},
	{EntityType.ENTITY_PREY,-1,-1,true,true},
	{EntityType.ENTITY_MEMBRAIN,-1,-1,true,true},
	{EntityType.ENTITY_SQUIRT,-1,-1,true,true},
	{EntityType.ENTITY_TICKING_SPIDER,-1,-1,false,true},
	{EntityType.ENTITY_MAW,1,-1,false,true}, --Red Maw
	{EntityType.ENTITY_MRMAW,3,-1,false,true}, --Mr. Red Maw's Head (why is it a seperate entity?)
    {37, 3, -1, true, true},
    {161, 84, -1, true, true},
    {161, 91, -1, true, true},
}


FHAC.DirectionToVector = {
    [Direction.DOWN]  = Vector(0, 1),
    [Direction.UP]    = Vector(0, -1),
    [Direction.LEFT]  = Vector(-1, 0),
    [Direction.RIGHT] = Vector(1, 0),
}


if REPENTOGON then
    FHAC.Unlocks = {
        Floater = Isaac.GetAchievementIdByName("Floater"),
        Fivehead = Isaac.GetAchievementIdByName("Fivehead"),
        Bohannes = Isaac.GetAchievementIdByName("JohannesB")
    }
end

mod.TempestFont = Font()
mod.TempestFont:Load("font/pftempestasevencondensed.fnt")

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COLOR --

-- i should make a section on colors, that'd be fun i told myself
-- some of these colors are from other mods or devs, fiend folio for the msot part as they have a really good colorpallate. If it's from a mod, I'll put the mod name and creator of color (if i can find who!) next to it. I.e.
FHAC.Color = {
    CrackleOrange = Color(1, 1, 1, 1, 1, 0.3, 0), --FIEND FOLIO; XALUM DONT USE THIS FOR SPLATS USE IT FOR CRACKLE
    FireJuicy = Color(0, 0, 0, 1, 1, 0.5, 0), -- also xalum?
    Charred = Color(0.1, 0.1, 0.1, 1, 0, 0, 0), -- FIEND FOLIO; XALUM
    Invisible = Color(1, 1, 1, 0, 0, 0, 0),
    Color = Color(1, 1, 1, 1, 1, 1, 1),

    --colorixzed ones
    ColorDankBlackReal = Color(1, 1, 1, 1, 0, 0, 0),
}

--time to colorize
mod.Color.ColorDankBlackReal:SetColorize(1, 1, 1, 1)
mod.Color.ColorDankBlackReal:SetTint(0.5, 0.5, 0.5, 1)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function mod:SpecialEnt(name)
    return { Isaac.GetEntityTypeByName(name), Isaac.GetEntityVariantByName(name) } --no repentagon fuck it
end

FHAC.Nonmale = {
    { ID = FHAC:SpecialEnt("Floater"),     Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Fivehead"),    Affliction = "Trans" },
    { ID = FHAC:SpecialEnt("Neutral Fly"), Affliction = "Aeroace" },
    { ID = FHAC:SpecialEnt("Erythorcyte"), Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Wost"),        Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Schmoot"),     Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Drosslet"),    Affliction = "Aeroace" }, --cus quaquao said to make everyone secretly aeroace lol
    { ID = FHAC:SpecialEnt("PitPat"),      Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Patient"),     Affliction = "Woman" },
    { ID = FHAC:SpecialEnt("Pinprick"),    Affliction = "Dreamsexual" },
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GRIDS --

mod.BasementGrid = StageAPI.GridGfx()
mod.BasementGrid:SetPits(mod.Grids.Pits.Basement, mod.Grids.Pits.Basement, true)
--mod.BasementGrid:SetBridges("gfx/grid/rocks_basement.png")

mod.CatacombsbGrid = StageAPI.GridGfx()
mod.CatacombsbGrid:SetPits(mod.Grids.Pits.Catacombs, mod.Grids.Pits.Catacombs, true)
--mod.BasementGrid:SetBridges("gfx/grid/rocks_basement.png")

mod.BasementBackdrop = StageAPI.RoomGfx(nil, mod.BasementGrid, nil, nil)
mod.CatacombsBackdrop = StageAPI.RoomGfx(nil, mod.CatacombsbGrid, nil, nil)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
