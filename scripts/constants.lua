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
    ZapperTeller = mod:ENT("Zapper Teller")
}

FHAC.Familiars = { --YOU HAVE NO IDEA HOW MANY FUCKING TIMES I SPELLED THIS WRONG LMAO
    Snark = mod:ENT("Snark (Half Life)"),
}

FHAC.Effects = {
    ZapperTellerLightning = mod:ENT("Zapper Teller Lightning")
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


if REPENTOGON then
FHAC.Unlocks = {
    Floater = Isaac.GetAchievementIdByName("Floater"),
    Fivehead = Isaac.GetAchievementIdByName("Fivehead")
}
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COLOR --

-- i should make a section on colors, that'd be fun i told myself
-- some of these colors are from other mods or devs, fiend folio for the msot part as they have a really good colorpallate. If it's from a mod, I'll put the mod name and creator of color (if i can find who!) next to it. I.e.
FHAC.Color = {
    CrackleOrange = Color(1,1,1,1,1,0.3,0), --FIEND FOLIO; XALUM DONT USE THIS FOR SPLATS USE IT FOR CRACKLE
    FireJuicy = 	Color(0,0,0,1,1,0.5,0), -- also xalum?
    Charred =  Color(0.1,0.1,0.1,1,0,0,0) -- FIEND FOLIO; XALUM
}
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
