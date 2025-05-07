-- goddamn you edmund 

local mod = FHAC
local game = Game()

function mod:TheHamerActive(_, _, player)
  player = player:ToPlayer()
  local ents = Isaac.GetRoomEntities()
  if #ents > 0 then
    local ent = ents[math.random(#ents)]

    if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and ent.Type ~= 1 then
      ent:GetData().ishamerSmooshed = true
      ent:TakeDamage(player.Damage * 0.10, 0, EntityRef(Isaac.GetPlayer()), 1)
      ent:GetData().hamerOGScale = ent.SpriteScale
      ent.SpriteScale = Vector.One * Vector(10, 0.5)
      ent:GetSprite():Update()
      return {ShowAnim = true}
    end
  end
end

--mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.TheHamerActive, mod.Collectibles.Items.TheHamer)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
  local d = npc:GetData()
  if not d.istheBigBoythatComicWantsItToBe then 
    local num = (1+(npc.FrameCount/25))
    npc.SpriteScale = Vector.One * num
    if npc.SpriteScale.X > 1.3 then
        d.istheBigBoythatComicWantsItToBe = true
    end
else
    npc.SpriteScale = Vector.One * 1.3
end

end)
