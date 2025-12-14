local mod = FHAC
local game = Game()
local sfx = SFXManager()

function mod.ScattcomBombAI(bomb)

    if bomb.Variant ~= mod.Bombs.ScattcomBomb.Var then return end

    local sprite = bomb:GetSprite()
	local var = bomb.Variant

    if bomb.SubType == 1 and sprite:IsPlaying("Pulse") and sprite:GetFrame() == 57 then

        sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK)

        for k, v in ipairs(Isaac.FindInRadius(bomb.Position, 10, EntityPartition.PLAYER)) do
            v:TakeDamage(1/10, DamageFlag.DAMAGE_EXPLOSION, EntityRef(bomb), 0.1)
        end

        local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1, -1, bomb.Position, Vector.Zero, bomb):ToEffect()
        ef:GetSprite().Scale = Vector(0.3, 0.3)

        bomb:Remove()
    end

    if var == BombVariant.BOMB_TROLL and sprite:IsPlaying("Pulse") and sprite:GetFrame() == 57 then
        if mod:AnyPlayerHasTrinket(TrinketType.TRINKET_SAFETY_SCISSORS) then
            local newbomb = Isaac.Spawn(5, 40, FiendFolio.PICKUP.BOMB.COPPER, bomb.Position, bomb.Velocity, nil)
            newbomb:GetSprite():Play("Idle")
            newbomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            newbomb:Update()

            local poof = Isaac.Spawn(1000, 15, 0, bomb.Position, Vector.Zero, nil)
            poof.SpriteScale = poof.SpriteScale * 0.5
            poof:Update()

            bomb:Remove()
        end
    elseif sprite:IsPlaying("Pulse") and sprite:GetFrame() == 58 and bomb.SubType == 0 then
        local rand = 7
        for i = 1, rand do
            local tinybomb = Isaac.Spawn(4, mod.Bombs.ScattcomBomb.Var, 1, bomb.Position + Vector(20, 0):Rotated(i*(360/rand)), Vector(10, 0):Rotated(i*(360/rand)), bomb)
            tinybomb:GetSprite():Load("gfx/items/pick ups/scattcombomb1.anm2", true)
            tinybomb:GetSprite():LoadGraphics()
            tinybomb:ToBomb():SetExplosionCountdown(math.random(29, 39))
            tinybomb:ToBomb().RadiusMultiplier = tinybomb:ToBomb().RadiusMultiplier/1.5

            tinybomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            tinybomb:GetSprite():Play("Idle")
        end
    end
end