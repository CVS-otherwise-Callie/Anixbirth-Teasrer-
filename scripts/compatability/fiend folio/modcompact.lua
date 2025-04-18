local mod = FHAC
local game = Game()

function FHAC.FiendFolioCompat()
    if not FiendFolio then return false end

    mod.FiendFolioDungliveryEnts = {
        {FiendFolio.FF.Morsel.ID, FiendFolio.FF.Morsel.Var},
        {FiendFolio.FF.Limb.ID, FiendFolio.FF.Limb.Var},
        {FiendFolio.FF.PaleLimb.ID, FiendFolio.FF.PaleLimb.Var},
        {FiendFolio.FF.Drumstick.ID, FiendFolio.FF.Drumstick.Var},
        {FiendFolio.FF.Spooter.ID, FiendFolio.FF.Spooter.Var},
        {FiendFolio.FF.SuperSpooter.ID, FiendFolio.FF.SuperSpooter.Var},
        {FiendFolio.FF.Spark.ID, FiendFolio.FF.Spark.Var},
        {FiendFolio.FF.Buoy.ID, FiendFolio.FF.Buoy.Var},
        {FiendFolio.FF.Litling.ID, FiendFolio.FF.Litling.Var},
        {FiendFolio.FF.RolyPoly.ID, FiendFolio.FF.RolyPoly.Var},
        {FiendFolio.FF.Shiitake.ID, FiendFolio.FF.Shiitake.Var},
        {FiendFolio.FF.Smidgen.ID, FiendFolio.FF.Smidgen.Var},
        {FiendFolio.FF.RedSmidgen.ID, FiendFolio.FF.RedSmidgen.Var},
        {FiendFolio.FF.ErodedSmidgen.ID, FiendFolio.FF.ErodedSmidgen.Var},
        {FiendFolio.FF.ErodedSmidgenNaked.ID, FiendFolio.FF.ErodedSmidgenNaked.Var},
        {FiendFolio.FF.Frowny.ID, FiendFolio.FF.Frowny.Var},
        {FiendFolio.FF.Tot.ID, FiendFolio.FF.Tot.Var},
        {FiendFolio.FF.CreepyMaggot.ID, FiendFolio.FF.CreepyMaggot.Var},
        {FiendFolio.FF.Drop.ID, FiendFolio.FF.Drop.Var},
        {FiendFolio.FF.Offal.ID, FiendFolio.FF.Offal.Var},
        {FiendFolio.FF.DriedOffal.ID, FiendFolio.FF.DriedOffal.Var},
        {FiendFolio.FF.Glob.ID, FiendFolio.FF.Glob.Var},
        {FiendFolio.FF.Sternum.ID, FiendFolio.FF.Sternum.Var},
        {FiendFolio.FF.Blot.ID, FiendFolio.FF.Blot.Var},
        {FiendFolio.FF.SpicyDip.ID, FiendFolio.FF.SpicyDip.Var},
        {FiendFolio.FF.Magleech.ID, FiendFolio.FF.Magleech.Var},
        {FiendFolio.FF.Organelle.ID, FiendFolio.FF.Organelle.Var},
        {FiendFolio.FF.InnerEye.ID, FiendFolio.FF.InnerEye.Var},
    }

    mod.FiendFolioClatterTellerEnts = {
        {mod.FF.RedHorf.ID,mod.FF.RedHorf.Var,-1,true}, -- Ch1
	{mod.FF.Drumstick.ID,mod.FF.Drumstick.Var,-1,false},
	{mod.FF.ReheatedTickingFly.ID,mod.FF.ReheatedTickingFly.Var,-1,false},
	{mod.FF.FullSpider.ID,mod.FF.FullSpider.Var,-1,false},
	{mod.FF.Coby.ID,mod.FF.Coby.Var,-1,false},
	{mod.FF.Haunted.ID,mod.FF.Haunted.Var,-1,true},
	{mod.FF.Crotchety.ID,mod.FF.Crotchety.Var,-1,true},
	{mod.FF.Dim.ID,mod.FF.Dim.Var,-1,true},
	{mod.FF.Posssessed.ID,mod.FF.Posssessed.Var,-1,true},
	{mod.FF.Marge.ID,mod.FF.Marge.Var,-1,true},
	{mod.FF.Spitroast.ID,mod.FF.Spitroast.Var,-1,true},
	{mod.FF.Spitfire.ID,mod.FF.Spitfire.Var,-1,true},
	{mod.FF.Crisply.ID,mod.FF.Crisply.Var,-1,true},
	{mod.FF.Mullikaboom.ID,mod.FF.Mullikaboom.Var,-1,false},
	{mod.FF.Powderkeg.ID,mod.FF.Powderkeg.Var,-1,false},
	{mod.FF.BigSmoke.ID,mod.FF.BigSmoke.Var,-1,false},
	{mod.FF.Brisket.ID,mod.FF.Brisket.Var,-1,true},
	{mod.FF.Litling.ID,mod.FF.Litling.Var,-1,false},
	{mod.FF.Mayfly.ID,mod.FF.Mayfly.Var,-1,true}, -- Ch1.5
	{mod.FF.Mightfly.ID,mod.FF.Mightfly.Var,-1,true},
	{mod.FF.GoldenMightfly.ID,mod.FF.GoldenMightfly.Var,-1,true},
	{mod.FF.MiniMinMin.ID,mod.FF.MiniMinMin.Var,-1,true},
	{mod.FF.ShittyHorf.ID,mod.FF.ShittyHorf.Var,-1,true},
	{mod.FF.Trashbagger.ID,mod.FF.Trashbagger.Var,mod.FF.Trashbagger.Sub,true},
	{mod.FF.Globlet.ID,mod.FF.Globlet.Var,-1,true}, -- Ch2
	{mod.FF.Fathead.ID,mod.FF.Fathead.Var,-1,true},
	{mod.FF.FossilBoomFly.ID,mod.FF.FossilBoomFly.Var,-1,false},
	{mod.FF.Warhead.ID,mod.FF.Warhead.Var,-1,true},
	{mod.FF.Bunch.ID,mod.FF.Bunch.Var,-1,true},
	{mod.FF.Grape.ID,mod.FF.Grape.Var,-1,false},
	{mod.FF.MamaPooter.ID,mod.FF.MamaPooter.Var,-1,true},
	{mod.FF.Dribble.ID,mod.FF.Dribble.Var,-1,true},
	{mod.FF.BubbleBat.ID,mod.FF.BubbleBat.Var,-1,true},
	{mod.FF.Puffer.ID,mod.FF.Puffer.Var,-1,true},
	{mod.FF.Panini.ID,mod.FF.Panini.Var,-1,true},
	{mod.FF.Sizzle.ID,mod.FF.Sizzle.Var,-1,true}, -- Ch2.5
	{mod.FF.Blastcore.ID,mod.FF.Blastcore.Var,-1,true},
	{mod.FF.Rufus.ID,mod.FF.Rufus.Var,-1,true},
	{mod.FF.Ossularry.ID,mod.FF.Ossularry.Var,-1,true},
	{mod.FF.Scoop.ID,mod.FF.Scoop.Var,-1,true}, -- Ch3
	{mod.FF.Sundae.ID,mod.FF.Sundae.Var,-1,true},
	{mod.FF.SoftServe.ID,mod.FF.SoftServe.Var,-1,true},
	{mod.FF.Splodum.ID,mod.FF.Splodum.Var,-1,false}, 
	{mod.FF.Gravin.ID, mod.FF.Gravin.Var,-1,false}, 
	{mod.FF.Carrier.ID,mod.FF.Carrier.Var,-1,true},
	{mod.FF.Baro.ID,mod.FF.Baro.Var,-1,true},
	{mod.FF.Calzone.ID,mod.FF.Calzone.Var,-1,true},
	{mod.FF.Squidge.ID,mod.FF.Squidge.Var,-1,false},
	{mod.FF.Gunk.ID,mod.FF.Gunk.Var,-1,false},
	{mod.FF.Punk.ID,mod.FF.Punk.Var,-1,false},
	{mod.FF.Melty.ID,mod.FF.Melty.Var,-1,true},
	{mod.FF.TrashbaggerDank.ID,mod.FF.TrashbaggerDank.Var,mod.FF.TrashbaggerDank.Sub,true},
	{mod.FF.Empath.ID, mod.FF.Empath.Var,-1,true}, -- Ch3.5
	{mod.FF.ManicFly.ID, mod.FF.ManicFly.Var,-1}, 
	{mod.FF.Acolyte.ID,mod.FF.Acolyte.Var,-1,false},
	{mod.FF.Temptress.ID,mod.FF.Temptress.Var,-1,true},
	{mod.FF.DreadMaw.ID,mod.FF.DreadMaw.Var,-1,true},
	{mod.FF.Tagbag.ID,mod.FF.Tagbag.Var,-1,true},
	{mod.FF.Berry.ID,mod.FF.Berry.Var,-1,true}, -- Ch4
	{mod.FF.Warble.ID,mod.FF.Warble.Var,-1,true},
	{mod.FF.Glorf.ID,mod.FF.Glorf.Var,-1,true,false,true},
	{mod.FF.Globwad.ID,mod.FF.Globwad.Var,-1,true},
	{mod.FF.Heartbeat.ID,mod.FF.Heartbeat.Var,-1,true},
	{mod.FF.Jammed.ID,mod.FF.Jammed.Var,-1,true},
	{mod.FF.Trickle.ID,mod.FF.Trickle.Var,-1,true},
	{mod.FF.Dogmeat.ID,mod.FF.Dogmeat.Var,-1,true},
	{mod.FF.HeadHoncho.ID,mod.FF.HeadHoncho.Var,-1,true},
	{mod.FF.Facade.ID,mod.FF.Facade.Var,-1,true},
	{mod.FF.Cellulitis.ID,mod.FF.Cellulitis.Var,-1,-1,true,false},
	{mod.FF.Nailhead.ID,mod.FF.Facade.Var,-1,true},
	{mod.FF.Mouthful.ID,mod.FF.Mouthful.Var,-1,true},
	{mod.FF.Coconut.ID,mod.FF.Coconut.Var,-1,true}, -- Ch4.5
	{mod.FF.Nematode.ID,mod.FF.Nematode.Var,-1,true}, 
	{mod.FF.PsionLeech.ID,mod.FF.PsionLeech.Var,-1,false}, -- Ch 5
	{mod.FF.Accursed.ID,mod.FF.Accursed.Var,-1,true}, -- Ch7
    }

    mod:MixTables(mod.DungliveryEnts, FHAC.FiendFolioDungliveryEnts)
    mod:MixTables(mod.ClatterTellerWhitelist, FHAC.FiendFolioClatterTellerEnts)

    if FHAC.Nonmale then
    mod:MixTables(FiendFolio.Nonmale, FHAC.Nonmale)

    FHAC.FiendFolioCompactLoaded = true
    return true
    end
end