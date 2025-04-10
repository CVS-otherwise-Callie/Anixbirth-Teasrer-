-- goddamn you edmund 

local mod = FHAC
local game = Game()

function mod:TheHamerActive(_, _, player)
  --[[player = player:ToPlayer()
  local ents = Isaac.GetRoomEntities()
  if #ents > 0 then
    local ent = ents[math.random(#ents)]

    if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and ent.Type ~= 1 then
      ent:GetData().ishamerSmooshed = true
      ent:TakeDamage(player.Damage * 0.10, 0, EntityRef(Isaac.GetPlayer()), 1)
      ent:GetData().hamerOGScale = ent.SpriteScale
      ent.SpriteScale = Vector(10, 0.3)
      ent:ToNPC().Scale = 5
      ent:GetSprite():Update()
      return {ShowAnim = true}
    end
  end]]
end

--mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHamerActive, mod.Collectibles.Items.TheHamer)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
  --[[local d = npc:GetData()
  if npc:GetData().ishamerSmooshed then
    npc.SpriteScale = mod:Lerp(npc.SpriteScale, d.hamerOGScale, 0.1)
    if npc.SpriteScale:Distance(d.hamerOGScale) < 0.01 then
      npc:GetData().ishamerSmooshed = false
    end
  end]]

end)
