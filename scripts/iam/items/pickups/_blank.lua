local mod = FHAC

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    mod:PostBlankPickupAI(pickup, pickup:GetSprite(), pickup:GetData())
end, mod.Collectibles.Pickups.Blank.Var)

function mod:PostBlankPickupAI(p, sprite, d) --usually checking sprites and stuff goes here
end