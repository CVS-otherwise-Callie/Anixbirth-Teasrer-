local mod = FHAC
local game = Game()

function mod:TheHamerActive()
  local ents = Isaac.GetRoomEntities()
  if #ents > 0 then
    local ent = ents[math.random(#ents)]

    ent:TakeDamage(damage*(1+Isaac.GetPlayer():GetEffects():GetCollectibleEffectNum(mod.Collectibles.Items.TheHamer))*0.10, flag, EntityRef(Isaac.GetPlayer()), countdown)    
  end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHamerActive, mod.Collectibles.Items.TheHamer)
