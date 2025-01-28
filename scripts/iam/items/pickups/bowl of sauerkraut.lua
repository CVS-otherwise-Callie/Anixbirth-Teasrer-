local mod = FHAC

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    mod:BowlOfSauerkrautAI(pickup, pickup:GetSprite(), pickup:GetData())
end, mod.Collectibles.Pickups.BowlOfSauerkraut.Var)

function mod:BowlOfSauerkrautAI(p, sprite, d)
    
end