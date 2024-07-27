local mod = FHAC
local game = Game()

mod.isRepentance = REPENTANCE

--shit that's kinda all over the place, please put in alphabetical
FHAC.font = Font()
--needed rn, likely will delete later

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
}

FHAC.Jokes = {
    Gaperrr = mod:ENT("A gaper w/ three legs, why did we do this"),
}

FHAC.Savedata = {
    DeathFortunes = true,
}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COLOR --

-- i should make a section on colors, that'd be fun i told myself
-- some of these colors are from other mods or devs, fiend folio for the msot part as they have a really good colorpallate. If it's from a mod, I'll put the mod name and creator of color (if i can find who!) next to it. I.e.
FHAC.Color = {
    CrackleOrange = Color(1,1,1,1,1,0.3,0), --FIEND FOLIO; XALUM DONT USE THIS FOR SPLATS USE IT FOR CRACKLE
    FireJuicy = 	Color(0,0,0,1,1,0.5,0), -- also xalum?
    Charred =  Color(0.1,0.1,0.1,1,0,0,0) -- FIEND FOLIO; XALUM
}

StageAPI.AddEntities2Function(require("scripts.entities2"))

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FHAC.EnemyDeathShit = {}
--heehehehehhehehe fuck
FHAC.EnemyDeathShit.Anims = {
    --{ID = FHAC.Monsters.Dangler.ID, Var = FHAC.Monsters.Dangler.Var, Subtype = FHAC.Monsters.Dangler.Subtype, Anim = mod.danglerDeath }
}