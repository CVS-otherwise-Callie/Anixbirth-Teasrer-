local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    mod:MarketablePlushieAI(fam, fam:GetSprite(), fam:GetData())
end, mod.Familiars.MarketablePlushie.Var)

function mod:MarketablePlushieAI(fam, sprite, d)

	local player = fam.Player

    if not d.init then
        fam:AddToFollowers()
        d.state = "float"
        d.stateframe = 0
        d.init = true
    else
        fam.FireCooldown = fam.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		fam.FireCooldown = math.max(0, fam.FireCooldown)

        d.stateframe = d.stateframe + 1
    end

    local velocity = mod.GetFamiliarShootingDirection(fam):Resized(10)
    velocity = velocity + player:GetTearMovementInheritance(velocity)

	local direction = player:GetFireDirection()
    d.lastdirection = (d.lastdirection ~= nil and d.lastdirection) or direction
	d.lastdirection = (direction ~= Direction.NO_DIRECTION and direction) or d.lastdirection

    if d.state == "shoot" then
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, velocity, fam):ToTear()
        tear.Height = -35
        tear.FallingSpeed = -1
        tear.FallingAcceleration = 0.01 + (math.random() * 2 - 1) * 0.001
        tear.CollisionDamage = player.Damage/2
        tear.Scale = 0.7
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
            tear.CollisionDamage = 9
            tear.Scale = 1.0
        end
        d.stateframe= 0
        tear:AddTearFlags(TearFlags.TEAR_HOMING)
        local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
        tear.Color = tearcolor
        d.state = "float"

        if player.Luck > math.random(-1, 15) then
            tear:GetData().type = "marketableplushie"
            tear:SetDeadEyeIntensity(2)
        end
    end

    if fam.FireCooldown == 0 and mod.IsPlayerTryingToShoot(player) then
        d.state = "shoot"
        fam.FireCooldown = 20
    end

    --whatever ff stuff
    if d.state == "float" and fam.FireCooldown < 15 then
		if direction == Direction.LEFT and (sprite:GetAnimation() ~= "FloatSide") and sprite.FlipX == true then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = true
		elseif direction == Direction.RIGHT and (sprite:GetAnimation() ~= "FloatSide") and sprite.FlipX == false then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif direction == Direction.UP and sprite:GetAnimation() ~= "FloatUp" then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (direction == Direction.DOWN or direction == Direction.NO_DIRECTION) and sprite:GetAnimation() ~= "FloatDown" then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
	elseif d.state == "shoot" then

		if d.lastdirection == Direction.LEFT and (sprite:GetAnimation() ~= "FloatShootSide") then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatShootSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = true
		elseif d.lastdirection == Direction.RIGHT and (sprite:GetAnimation() ~= "FloatShootSide" and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatShootSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif d.lastdirection == Direction.UP and sprite:GetAnimation() ~= "FloatShootUp" then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatShootUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (d.lastdirection == Direction.DOWN or d.lastdirection == Direction.NO_DIRECTION) and sprite:GetAnimation() ~= "FloatShootDown" then
			local frame = sprite:GetFrame()
			mod:spritePlay(sprite, "FloatShootDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end

	end

    fam:FollowParent()
end

function mod:MarketablePlushieTearDeathAI(p, d)
    if d.type == "marketableplushie" and p:IsDead() then
        local rfit = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIFT, -1, p.Position, Vector.Zero, p):ToEffect()
        rfit.Scale = rfit.Scale * 0.5
        rfit:SetTimeout(50)
        d.type = nil
    end
end
