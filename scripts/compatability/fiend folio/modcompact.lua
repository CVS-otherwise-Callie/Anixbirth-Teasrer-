local game = Game()

function FHAC.FiendFolioCompat()
    if not FiendFolio then return false end

	FHAC:LoadScripts("scripts.compatability.fiend folio", {
		"music"
	})

    FHAC.FiendFolioDungliveryEnts = {
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

    FHAC.FiendFolioClatterTellerEnts = {
        {FiendFolio.FF.RedHorf.ID,FiendFolio.FF.RedHorf.Var,-1,true}, -- Ch1
	{FiendFolio.FF.Drumstick.ID,FiendFolio.FF.Drumstick.Var,-1,false},
	{FiendFolio.FF.ReheatedTickingFly.ID,FiendFolio.FF.ReheatedTickingFly.Var,-1,false},
	{FiendFolio.FF.FullSpider.ID,FiendFolio.FF.FullSpider.Var,-1,false},
	{FiendFolio.FF.Coby.ID,FiendFolio.FF.Coby.Var,-1,false},
	{FiendFolio.FF.Haunted.ID,FiendFolio.FF.Haunted.Var,-1,true},
	{FiendFolio.FF.Crotchety.ID,FiendFolio.FF.Crotchety.Var,-1,true},
	{FiendFolio.FF.Dim.ID,FiendFolio.FF.Dim.Var,-1,true},
	{FiendFolio.FF.Posssessed.ID,FiendFolio.FF.Posssessed.Var,-1,true},
	{FiendFolio.FF.Marge.ID,FiendFolio.FF.Marge.Var,-1,true},
	{FiendFolio.FF.Spitroast.ID,FiendFolio.FF.Spitroast.Var,-1,true},
	{FiendFolio.FF.Spitfire.ID,FiendFolio.FF.Spitfire.Var,-1,true},
	{FiendFolio.FF.Crisply.ID,FiendFolio.FF.Crisply.Var,-1,true},
	{FiendFolio.FF.Mullikaboom.ID,FiendFolio.FF.Mullikaboom.Var,-1,false},
	{FiendFolio.FF.Powderkeg.ID,FiendFolio.FF.Powderkeg.Var,-1,false},
	{FiendFolio.FF.BigSmoke.ID,FiendFolio.FF.BigSmoke.Var,-1,false},
	{FiendFolio.FF.Brisket.ID,FiendFolio.FF.Brisket.Var,-1,true},
	{FiendFolio.FF.Litling.ID,FiendFolio.FF.Litling.Var,-1,false},
	{FiendFolio.FF.Mayfly.ID,FiendFolio.FF.Mayfly.Var,-1,true}, -- Ch1.5
	{FiendFolio.FF.Mightfly.ID,FiendFolio.FF.Mightfly.Var,-1,true},
	{FiendFolio.FF.GoldenMightfly.ID,FiendFolio.FF.GoldenMightfly.Var,-1,true},
	{FiendFolio.FF.MiniMinMin.ID,FiendFolio.FF.MiniMinMin.Var,-1,true},
	{FiendFolio.FF.ShittyHorf.ID,FiendFolio.FF.ShittyHorf.Var,-1,true},
	{FiendFolio.FF.Trashbagger.ID,FiendFolio.FF.Trashbagger.Var,FiendFolio.FF.Trashbagger.Sub,true},
	{FiendFolio.FF.Globlet.ID,FiendFolio.FF.Globlet.Var,-1,true}, -- Ch2
	{FiendFolio.FF.Fathead.ID,FiendFolio.FF.Fathead.Var,-1,true},
	{FiendFolio.FF.FossilBoomFly.ID,FiendFolio.FF.FossilBoomFly.Var,-1,false},
	{FiendFolio.FF.Warhead.ID,FiendFolio.FF.Warhead.Var,-1,true},
	{FiendFolio.FF.Bunch.ID,FiendFolio.FF.Bunch.Var,-1,true},
	{FiendFolio.FF.Grape.ID,FiendFolio.FF.Grape.Var,-1,false},
	{FiendFolio.FF.MamaPooter.ID,FiendFolio.FF.MamaPooter.Var,-1,true},
	{FiendFolio.FF.Dribble.ID,FiendFolio.FF.Dribble.Var,-1,true},
	{FiendFolio.FF.BubbleBat.ID,FiendFolio.FF.BubbleBat.Var,-1,true},
	{FiendFolio.FF.Puffer.ID,FiendFolio.FF.Puffer.Var,-1,true},
	{FiendFolio.FF.Panini.ID,FiendFolio.FF.Panini.Var,-1,true},
	{FiendFolio.FF.Sizzle.ID,FiendFolio.FF.Sizzle.Var,-1,true}, -- Ch2.5
	{FiendFolio.FF.Blastcore.ID,FiendFolio.FF.Blastcore.Var,-1,true},
	{FiendFolio.FF.Rufus.ID,FiendFolio.FF.Rufus.Var,-1,true},
	{FiendFolio.FF.Ossularry.ID,FiendFolio.FF.Ossularry.Var,-1,true},
	{FiendFolio.FF.Scoop.ID,FiendFolio.FF.Scoop.Var,-1,true}, -- Ch3
	{FiendFolio.FF.Sundae.ID,FiendFolio.FF.Sundae.Var,-1,true},
	{FiendFolio.FF.SoftServe.ID,FiendFolio.FF.SoftServe.Var,-1,true},
	{FiendFolio.FF.Splodum.ID,FiendFolio.FF.Splodum.Var,-1,false}, 
	{FiendFolio.FF.Gravin.ID, FiendFolio.FF.Gravin.Var,-1,false}, 
	{FiendFolio.FF.Carrier.ID,FiendFolio.FF.Carrier.Var,-1,true},
	{FiendFolio.FF.Baro.ID,FiendFolio.FF.Baro.Var,-1,true},
	{FiendFolio.FF.Calzone.ID,FiendFolio.FF.Calzone.Var,-1,true},
	{FiendFolio.FF.Squidge.ID,FiendFolio.FF.Squidge.Var,-1,false},
	{FiendFolio.FF.Gunk.ID,FiendFolio.FF.Gunk.Var,-1,false},
	{FiendFolio.FF.Punk.ID,FiendFolio.FF.Punk.Var,-1,false},
	{FiendFolio.FF.Melty.ID,FiendFolio.FF.Melty.Var,-1,true},
	{FiendFolio.FF.TrashbaggerDank.ID,FiendFolio.FF.TrashbaggerDank.Var,FiendFolio.FF.TrashbaggerDank.Sub,true},
	{FiendFolio.FF.Empath.ID, FiendFolio.FF.Empath.Var,-1,true}, -- Ch3.5
	{FiendFolio.FF.ManicFly.ID, FiendFolio.FF.ManicFly.Var,-1}, 
	{FiendFolio.FF.Acolyte.ID,FiendFolio.FF.Acolyte.Var,-1,false},
	{FiendFolio.FF.Temptress.ID,FiendFolio.FF.Temptress.Var,-1,true},
	{FiendFolio.FF.DreadMaw.ID,FiendFolio.FF.DreadMaw.Var,-1,true},
	{FiendFolio.FF.Tagbag.ID,FiendFolio.FF.Tagbag.Var,-1,true},
	{FiendFolio.FF.Berry.ID,FiendFolio.FF.Berry.Var,-1,true}, -- Ch4
	{FiendFolio.FF.Warble.ID,FiendFolio.FF.Warble.Var,-1,true},
	{FiendFolio.FF.Glorf.ID,FiendFolio.FF.Glorf.Var,-1,true,false,true},
	{FiendFolio.FF.Globwad.ID,FiendFolio.FF.Globwad.Var,-1,true},
	{FiendFolio.FF.Heartbeat.ID,FiendFolio.FF.Heartbeat.Var,-1,true},
	{FiendFolio.FF.Jammed.ID,FiendFolio.FF.Jammed.Var,-1,true},
	{FiendFolio.FF.Trickle.ID,FiendFolio.FF.Trickle.Var,-1,true},
	{FiendFolio.FF.Dogmeat.ID,FiendFolio.FF.Dogmeat.Var,-1,true},
	{FiendFolio.FF.HeadHoncho.ID,FiendFolio.FF.HeadHoncho.Var,-1,true},
	{FiendFolio.FF.Facade.ID,FiendFolio.FF.Facade.Var,-1,true},
	{FiendFolio.FF.Cellulitis.ID,FiendFolio.FF.Cellulitis.Var,-1,-1,true,false},
	{FiendFolio.FF.Nailhead.ID,FiendFolio.FF.Facade.Var,-1,true},
	{FiendFolio.FF.Mouthful.ID,FiendFolio.FF.Mouthful.Var,-1,true},
	{FiendFolio.FF.Coconut.ID,FiendFolio.FF.Coconut.Var,-1,true}, -- Ch4.5
	{FiendFolio.FF.Nematode.ID,FiendFolio.FF.Nematode.Var,-1,true}, 
	{FiendFolio.FF.PsionLeech.ID,FiendFolio.FF.PsionLeech.Var,-1,false}, -- Ch 5
	{FiendFolio.FF.Accursed.ID,FiendFolio.FF.Accursed.Var,-1,true}, -- Ch7
    }

    FHAC:MixTables(FHAC.DungliveryEnts, FHAC.FiendFolioDungliveryEnts)
    FHAC:MixTables(FHAC.ClatterTellerWhitelist, FHAC.FiendFolioClatterTellerEnts)

    if FHAC.Nonmale then
    FHAC:MixTables(FiendFolio.Nonmale, FHAC.Nonmale)

    FHAC.FiendFolioCompactLoaded = true
    return true
    end
end