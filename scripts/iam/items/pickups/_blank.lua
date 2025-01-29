local mod = FHAC
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    mod:PostBlankPickupAI(pickup, pickup:GetSprite(), pickup:GetData())
end, mod.Collectibles.Pickups.Blank.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider.Type == 1 and collider.Variant == 0 then
        collider = collider:ToPlayer()
        mod.CollectBlankPickup(collider, pickup)
        return true
    else
        return true
    end
end, mod.Collectibles.Pickups.Blank.Vae)

function mod:PostBlankPickupAI(p, sprite, d) --usually checking sprites and stuff goes here
end

function mod.CollectBlankPickup(player, pickup)
    local sprite = pickup:GetSprite()
    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        pickup.Touched = true
        sprite:Play("Collect")
    end
end