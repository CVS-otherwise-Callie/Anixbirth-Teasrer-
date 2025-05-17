local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.WebbedCarcass.Var then
        mod:WebbedCarcassAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.WebbedCarcass.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.WebbedCarcass.Var then
        mod:WebbedCarcassRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.WebbedCarcass.ID)

local bsprite = Sprite()
bsprite:Load("gfx/monsters/webbedcarcass/webbedcarcass.anm2", true)


function mod:WebbedCarcassAI(npc, sprite, d)

    if not d.init then
        d.sprite = d.sprite or tostring(math.random(2))
        d.init = true
    end

    mod:SaveEntToRoom(npc)

    if not d.isDead then
        mod:spritePlay(sprite, "Idle" .. d.sprite)
    else
        mod:spritePlay(sprite, "Dead" .. d.sprite)
    end

    if npc.MaxHitPoints / npc.HitPoints > 2 and not d.isDead then
        d.isDead = true
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, npc.Position, Vector.Zero, npc)
        SFXManager():Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 2, false, 1, 0)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end

end

function mod:WebbedCarcassRenderAI(npc, sprite, d)

    if d.init and not d.isDead then
        bsprite:Render(Isaac.WorldToScreen(npc.Position), Vector.Zero, Vector.Zero)
        mod:spritePlay(bsprite, "Body" .. d.sprite)
    end
end


