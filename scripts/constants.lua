local mod = FHAC
local game = Game()

mod.isRepentance = REPENTANCE

--shit that's kinda all over the place, please put in alphabetical
FHAC.font = Font()
--needed rn, likely will delete later

function FHAC:ENT(name)
	return {ID = Isaac.GetEntityTypeByName(name), Var = Isaac.GetEntityVariantByName(name), 0}
end


FHAC.Monsters = {
    Fivehead = mod:ENT("Fivehead"),
    Floater = mod:ENT("Floater"),
    Dried = mod:ENT("Dried"),
    Neutralfly = mod:ENT("Neutral Fly"),
    Patient = mod:ENT("Patient"),
    Erythorcyte = mod:ENT("Erythorcyte"),
    Erythorcytebaby = mod:ENT("Erythorcytebaby"),
    Wost = mod:ENT("Wost"),
    Schmoot = mod:ENT("Schmoot"),
    Snidge = mod:ENT("Snidge"),
    --Dangler = mod:ENT("Dangler"),
    Drosslet = mod:ENT("Drosslet"),
    PitPatSpawner = mod:ENT("Pit Pat Spawner"),
    PitPat = mod:ENT("Pit Pat"),
    MushLoom = mod:ENT("Mush Loom"),
    Pinprick = mod:ENT("Pinprick"),
    SyntheticHorf = mod:ENT("Synthetic Horf"),
    GassedFly = mod:ENT("Gassed Fly"),
    FlyveBomber = mod:ENT("Plier"),
    Pallun = mod:ENT("Pallun"),
    Silly = mod:ENT("Silly"),
    String = mod:ENT("String"),
    StickyFly = mod:ENT("Sticky Fly"),
    WispWosp = mod:ENT("Wisp Wosp"),
    Stuckpoot = mod:ENT("Stuckpoot"),
    RainMonger = mod:ENT("Rain Monger"),
    TechGrudge = mod:ENT("Tech Grudge"),
    ZapperTeller = mod:ENT("Zapper Teller"),
    Log = mod:ENT("Log"),
    Stoner = mod:ENT("Stoner"),
    LightPressurePlateEntNull = mod:ENT("Light Pressure Plate Null Entity"),
    LarryKingJr = mod:ENT("Larry King Jr."),
    Sixhead = mod:ENT("Sixhead"),
    Bottom = mod:ENT("Bottom"),
    Babble = mod:ENT("Babble"),
    Toast = mod:ENT("Toast"),
    TaintedSilly = mod:ENT("Tainted Silly"),
    TaintedString = mod:ENT("Tainted String"),
    andEntity = mod:ENT("&")
}

FHAC.Players = {
    Johannes = Isaac.GetPlayerTypeByName("Johannes"),
    Bohannes = Isaac.GetPlayerTypeByName("Johannes", true),
    Pongon = Isaac.GetPlayerTypeByName("Pongon")
}

FHAC.Grids = {
    GlobalGridSpawner = mod:ENT("HOPE Grid Spawner")
}

FHAC.Familiars = { --YOU HAVE NO IDEA HOW MANY FUCKING TIMES I SPELLED THIS WRONG LMAO
    Snark = mod:ENT("Snark (Half Life)"),
}

FHAC.Effects = {
    ZapperTellerLightning = mod:ENT("Zapper Teller Lightning"),
    BlackOverlayBox = mod:ENT("BlackOverlayBox"),
    NormalTextBox = mod:ENT("Text Box")
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
    AltTrapdoorBang = Isaac.GetSoundIdByName("alt_trapdoor_bang")
}

FHAC.Collectibles = {
    Items = {
        StinkyMushroom = Isaac.GetItemIdByName("Stinky Mushroom"),
        AnalFissure = Isaac.GetItemIdByName("Anal Fissure"),
        BigBowlOfSauerkraut = Isaac.GetItemIdByName("Big Ol' Bowl of Sauerkraut"),
        JokeBook = Isaac.GetItemIdByName("Joke Book"),
        StrawDoll = Isaac.GetItemIdByName("Straw Doll"),
        EmptyDeathCertificate = Isaac.GetItemIdByName("Empty Death Certificate")
    },
    Pickups = {
        BowlOfSauerkraut = mod:ENT("Bowl of Sauerkraut")
    },
    Trinkets = {
        MysteryMilk = Isaac.GetTrinketIdByName("Mystery Milk")
    }
}


if REPENTOGON then
FHAC.Unlocks = {
    Floater = Isaac.GetAchievementIdByName("Floater"),
    Fivehead = Isaac.GetAchievementIdByName("Fivehead"),
    Bohannes = Isaac.GetAchievementIdByName("JohannesB")
}
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COLOR --

-- i should make a section on colors, that'd be fun i told myself
-- some of these colors are from other mods or devs, fiend folio for the msot part as they have a really good colorpallate. If it's from a mod, I'll put the mod name and creator of color (if i can find who!) next to it. I.e.
FHAC.Color = {
    CrackleOrange = Color(1,1,1,1,1,0.3,0), --FIEND FOLIO; XALUM DONT USE THIS FOR SPLATS USE IT FOR CRACKLE
    FireJuicy = 	Color(0,0,0,1,1,0.5,0), -- also xalum?
    Charred =  Color(0.1,0.1,0.1,1,0,0,0), -- FIEND FOLIO; XALUM
    Invisible = Color(1,1,1,0,0,0,0),
    Color = Color(1, 1, 1, 1, 1, 1, 1),

    --colorixzed ones
    ColorDankBlackReal = Color(1,1,1,1,0,0,0),
}

--time to colorize
mod.Color.ColorDankBlackReal:SetColorize(1,1,1,1)
mod.Color.ColorDankBlackReal:SetTint(0.5,0.5,0.5,1)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function mod:SpecialEnt(name)
    return {Isaac.GetEntityTypeByName(name), Isaac.GetEntityVariantByName(name)} --no repentagon fuck it
end

FHAC.Nonmale = {
    {ID = FHAC:SpecialEnt("Floater"), Affliction = "Woman"},
    {ID = FHAC:SpecialEnt("Fivehead"), Affliction = "Trans"},
    {ID = FHAC:SpecialEnt("Neutral Fly"), Affliction = "Aeroace"},
    {ID = FHAC:SpecialEnt("Erythorcyte"), Affliction = "Woman"},
    {ID = FHAC:SpecialEnt("Wost"), Affliction = "Woman"},
    {ID = FHAC:SpecialEnt("Schmoot"), Affliction = "Woman"},
    {ID = FHAC:SpecialEnt("Drosslet"), Affliction = "Aeroace"}, --cus quaquao said to make everyone secretly aeroace lol
    {ID = FHAC:SpecialEnt("PitPat"), Affliction = "Woman"},
    {ID = FHAC:SpecialEnt("Patient"), Affliction = "Woman"},
}
