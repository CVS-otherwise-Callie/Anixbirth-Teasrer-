
local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()


mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, ef)
    if ef.Variant == mod.Effects.GunslingerGun.Var then
        mod:GunslingerGunAI(ef, ef:GetSprite(), ef:GetData())
    end
end)

function mod:GunslingerGunAI(ef, sprite, d)

    if not d.init then
        ef.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.num = 0
        d.state = "idle"
        d.StateFrame = 0
        d.tilt = 2
        d.init = true
    else
        d.StateFrame = d.StateFrame + 1
    end

    local targetpos = mod:confusePos(ef, d.target.Position, 5, nil, nil)


    if d.state == "idle" then

        local xvel = 6
        local yvel = 6
        if ef.Velocity.X < 0 then
            xvel = xvel * -1
        end
        if ef.Velocity.Y < 0 then
            yvel = yvel * -1
        end
    
        if ef:CollidesWithGrid() then
            d.num = d.num + 1
            d.tilt = d.tilt * -1
        end
    
        local targvel = Vector(xvel, yvel)
        local tiltCalc = Vector(xvel, 0):Resized(-1) * d.tilt
        local targetvel = (targvel + tiltCalc):Resized(8)
    
        ef.Velocity = mod:Lerp(ef.Velocity, targetvel, 0.5)
    
        mod:spritePlay(sprite, "Idle")

        if d.num > 2 then
            if d.StateFrame > 10 then
                d.state = "idletogun"
            end
        else
            d.StateFrame = 0
        end
    elseif d.state == "idletogun" then
        mod:spritePlay(sprite, "IdleToGun")
        sprite.Rotation = (ef.Position - targetpos):GetAngleDegrees()
        ef:MultiplyFriction(0.75)
    elseif d.state == "wait" then
        sprite.Rotation = (ef.Position - targetpos):GetAngleDegrees()

        if d.StateFrame > 30 then
            d.state = "shoot"
        end
    elseif d.state == "shoot" and not d.hasShot then
        sprite.Rotation = (ef.Position - targetpos):GetAngleDegrees()
        mod:spritePlay(sprite, "Shoot")
    end

    --"contact damage"
    local par = EntityRef(ef.Parent) or ef
    
    for k, v in ipairs(Isaac.FindInRadius(ef.Position, 30, EntityPartition.PLAYER)) do
        v:TakeDamage(1, 0, par, 1)
    end

    if sprite:IsFinished("IdleToGun") and d.state == "idletogun" then
        d.state = "wait"
        d.StateFrame = 0
    end

    if sprite:IsFinished("Shoot") then
        ef:Remove()
    end

    if sprite:IsEventTriggered("shoot") then
        d.hasShot = true
        sfx:Play(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 2)
        local realshot = Isaac.Spawn(9, 0, 0, ef.Position + Vector(0, 5):Rotated(sprite.Rotation), Vector(20, 0):Rotated((targetpos - ef.Position):GetAngleDegrees()), ef):ToProjectile()
        realshot.FallingAccel = 0.01
        realshot.FallingSpeed = 0.1
        realshot:GetData().type = "sheriff"
            d.Trail = Isaac.Spawn(1000,166,0,ef.Position,Vector.Zero,realshot):ToEffect() -- to learn how to do trails specifically like this, i consulted erfly and he told me to check the tricko code
            d.Trail:FollowParent(realshot)
            d.Trail.ParentOffset = Vector(0,-32)
            local color = Color(1,1,1,1,0.6,0.5,0.05)
            ef.SplatColor = color
            color:SetColorize(1, 0.8, 0.1, 3)
            d.Trail.Color = color
    end

end

