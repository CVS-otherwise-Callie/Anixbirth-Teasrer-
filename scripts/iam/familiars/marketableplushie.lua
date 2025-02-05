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

    if d.state == "shoot" then
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, velocity, fam):ToTear()
        tear.Height = -30
        tear.FallingSpeed = -1
        tear.FallingAcceleration = 0.01 + (math.random() * 2 - 1) * 0.01
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

        if player.Luck > math.random() then
            tear:GetData().type = "marketableplushie"
            tear:SetDeadEyeIntensity(0.5)
        end
    end

    if fam.FireCooldown == 0 and mod.IsPlayerTryingToShoot(player) then
        d.state = "shoot"
        fam.FireCooldown = 20
    end

    local ents = Isaac.GetRoomEntities()
    for k, v in ipairs(ents) do
        if v.Type == 2  then
            print(v:GetSprite():GetFilename())
        end
    end

    --whatever ff stuff
    if d.state == "float" then
		if direction == Direction.LEFT and not (sprite:IsPlaying("FloatSide") and sprite.FlipX == true) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = true
		elseif direction == Direction.RIGHT and not (sprite:IsPlaying("FloatSide") and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif direction == Direction.UP and not sprite:IsPlaying("FloatUp") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (direction == Direction.DOWN or direction == Direction.NO_DIRECTION) and not sprite:IsPlaying("FloatDown") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
	elseif d.state == "shoot" then
		if d.lastdirection == Direction.LEFT and not (sprite:IsPlaying("FloatShootSide") and sprite.FlipX == true) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = true
		elseif d.lastdirection == Direction.RIGHT and not (sprite:IsPlaying("FloatShootSide") and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootSide", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif d.lastdirection == Direction.UP and not sprite:IsPlaying("FloatShootUp") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootUp", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif (d.lastdirection == Direction.DOWN or d.lastdirection == Direction.NO_DIRECTION) and not sprite:IsPlaying("FloatShootDown") then
			local frame = sprite:GetFrame()
			sprite:Play("FloatShootDown", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
	end

    fam:FollowParent()
end

function mod:MarketablePlushieTearDeathAI(p, d)
    if d.type == "marketableplushie" and d:IsDead() then
        local rfit = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIFT, -1, p.Position, Vector.Zero, p):ToEffect()
        rfit.Scale = rfit.Scale * 0.8
    end
end
