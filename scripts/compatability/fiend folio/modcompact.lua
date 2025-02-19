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

    mod:MixTables(mod.DungliveryEnts, FHAC.FiendFolioDungliveryEnts)

    if FHAC.Nonmale then
    mod:MixTables(FiendFolio.Nonmale, FHAC.Nonmale)

    FHAC.FiendFolioCompactLoaded = true
    return true
    end
end