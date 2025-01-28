local mod = FHAC

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    mod:BlankPickupAI(pickup, pickup:GetSprite(), pickup:GetData())
end, mod.Collectibles.Pickups.Blank.Var)

function mod:BlankPickupAI(p, sprite, d)
end