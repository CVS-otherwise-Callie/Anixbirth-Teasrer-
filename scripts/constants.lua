local mod = FHAC
local game = Game()

mod.isRepentance = REPENTANCE

--shit that's kinda all over the place, please put in alphabetical
FHAC.font = Font()
--needed rn, likely will delete later

FHAC.Monsters = {
    Fivehead = {["ID"] = 161, ["Var"] = 0},
    Floater = {["ID"] = 161, ["Var"] = 1, ["Subtype"]= 1,},
    Dried = {["ID"] = 90, ["Var"] = 1,},
    Neutralfly = {["ID"] = 161, ["Var"] = 3, ["Subtype"]= 1,},
    Patient = {["ID"] = 200, ["Var"] = 0, ["Subtype"]= 0,},
    Erythorcyte = {["ID"] = 161, ["Var"] = 4, ["Subtype"] = 10,},
    Erythorcytebaby = {["ID"] = 161, ["Var"] = 4, ["Subtype"] = 11,},
    Wost = {["ID"] = 161, ["Var"] = 5, ["Subtype"] = 2,},
    Schmoot = {["ID"] = 161, ["Var"] = 6, ["Subtype"] = 0,},
    Snidge = {["ID"] = 161, ["Var"] = 27, ["Subtype"] = 6,},
    Dangler = {["ID"] = 161, ["Var"] = 7, ["Subtype"] = 0,},
}

FHAC.Jokes = {
    Gaperrr = {["ID"] = 10, ["Var"] = 5938}
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
    {ID = FHAC.Monsters.Dangler.ID, Var = FHAC.Monsters.Dangler.Var, Subtype = FHAC.Monsters.Dangler.Subtype, Anim = mod.danglerDeath }
}