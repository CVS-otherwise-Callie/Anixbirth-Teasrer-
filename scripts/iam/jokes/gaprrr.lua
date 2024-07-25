local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Jokes.Gaperrr.Var then
        mod:GaperrrAI(npc, npc:GetSprite(), npc:GetData())
	end
end, EntityType.ENTITY_GAPER)

function mod:GaperrrAI(npc, sprite, d)
  if not d.init then
    mod:spriteOverlayPlay(sprite, "Head")
    print("ew")
    d.init = true
  end
end