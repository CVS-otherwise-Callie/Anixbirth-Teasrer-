local mod = FHAC
local game = Game()

function FHAC.FiendFolioCompat()
    if not FiendFolio then return false end

    if FHAC.Nonmale then
    mod:MixTables(FiendFolio.Nonmale, FHAC.Nonmale)

    FHAC.FiendFolioCompactLoaded = true
    print("Anixbirth Fiend Folio Compact Loaded! Hooray!")
    return true
    end
end