local mod = FHAC
local game = Game()

function mod:TheHamerActive(player)
  local ents = Isaac.GetRoomEntities()
  if #ents > 0 then
    local ent = ents[math.random(#ents)]

    if not ent:GetData().ishamerSmooshed and ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
      ent:GetData().ishamerSmooshed = true
      ent:TakeDamage(damage*(1+Isaac.GetPlayer():GetEffects():GetCollectibleEffectNum(mod.Collectibles.Items.TheHamer))*0.10, flag, EntityRef(Isaac.GetPlayer()), countdown)    
    end
  end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHamerActive, mod.Collectibles.Items.TheHamer)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
   local d = npc:GetData()
   if npc:GetData().ishamerSmooshed then
      d.thehamerVar = d.thehamerVar or Vector(0, 1.5)

      while d.thehamerVar.X < 0 do
        d.thehamerVar.X = d.thehamerVar.X + 0.01
        d.thehamerVar.Y = d.thehamerVar.Y - 0.005
      end

      if d.thehamerVar.X > 1 then
        d.thehamerVar = Vector(1, 1)
        d.ishamerSmooshed = false
      end
      npc:GetSprite().Scale = mod:Lerp(npc:GetSprite().Scale, d.thehamerVar, 1)
   end
end)
