local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Jokes.Willowalker.Var then
        mod:WillowalkerAI(npc, npc:GetSprite(), npc:GetData())
	  end
end, mod.Jokes.Willowalker.ID)

function mod:WillowalkerAI(npc, sprite, d)
    local room = game:GetRoom()

    local player = npc:GetPlayerTarget()

    if not d.init then
        npc.EntityCollisionClass = 0
        npc.GridCollisionClass = 0
        d.targetheight = npc.Position.Y
        if player.Position.X > npc.Position.X then
            d.targetposdir = "Left"
        else
            d.targetposdir = "Right"
        end
        if npc.Parent then
            if d.targetposdir == "Right" then
                _, npc.Position = room:CheckLine(npc.Position,npc.Position + Vector(1000,0),2,1,false,false)
                npc.Position = room:FindFreeTilePosition (npc.Position, 0) - Vector(20,0)

                _, d.newwillospawnpos = room:CheckLine(npc.Position,npc.Position + Vector(-1000,0),2,1,false,false)
                d.newwillospawnpos = room:FindFreeTilePosition (d.newwillospawnpos, 0) - Vector(-20,0) + Vector(32,-32)
            else
                _, npc.Position = room:CheckLine(npc.Position,npc.Position + Vector(-1000,0),2,1,false,false)
                npc.Position = room:FindFreeTilePosition (npc.Position, 0) - Vector(-20,0)

                _, d.newwillospawnpos = room:CheckLine(npc.Position,npc.Position + Vector(1000,0),2,1,false,false)
                d.newwillospawnpos = room:FindFreeTilePosition (d.newwillospawnpos, 0) - Vector(20,0) + Vector(-32,-32)
            end
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc.CanShutDoors = false
            d.state = "bell"
            mod:spritePlay(sprite, "BellInit")
        else
            d.bell = Isaac.Spawn(137, 3939, 0, npc.Position, npc.Velocity, npc):ToNPC()
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            d.bell.Parent = npc
            npc.Child = d.bell
            d.bell = npc.Child:GetData()
            d.state = "spawned"
        end
        d.init = true
    end

    if math.abs(player.Position.X - npc.Position.X) < 25 and not (sprite:GetFrame() > 20) then
        d.dir = "Front"
    elseif player.Position.X > npc.Position.X then
        d.dir = "Right"
    else
        d.dir = "Left"
    end

    if d.state == "spawned" then
        mod:spritePlay(sprite, "Spawn")
        if sprite:IsFinished() then
            mod:spritePlay(sprite, "IdleFront")
            d.state = "idle"
        end
    end

    if d.state == "idle" then
        if d.targetposdir == "Left" then
            d.targetposX = player.Position.X + 200
        else
            d.targetposX = player.Position.X - 200
        end
        if npc.Position.X > d.targetposX then
            npc.Velocity = Vector(npc.Velocity.X - 1, 0)
        else
            npc.Velocity = Vector(npc.Velocity.X + 1, 0)
        end
        npc.Position.Y = d.targetheight
        npc.Velocity = npc.Velocity:Resized(math.min(npc.Velocity:Length(), 10))
        sprite:SetAnimation( "Idle"..d.dir, false)
        if d.bell.bonged then
            npc.CanShutDoors = false
            Isaac.Spawn(163, 2, 0, d.bell.newwillospawnpos, Vector.Zero, npc):ToNPC()
            npc.Velocity = Vector.Zero
            d.state = "fall"
        end
    end

    if d.state == "fall" then
        mod:spritePlay(sprite, "Fall")
        if sprite:IsFinished() then
            d.state = "roll"
        end
    end

    if d.state == "roll" then
        if npc.Position:Distance(player.Position) < 20 and not d.stolen then
            npc:PlaySound(SoundEffect.SOUND_DIMEPICKUP,1,2,false,1)
            local closeplayer = game:GetNearestPlayer(npc.Position)
            closeplayer:AddCoins(40)
            closeplayer:AnimateHappy()
            print("HEY GIVE THAT BACK")
            d.stolen = true
        end
        npc.StateFrame = npc.StateFrame + 1
        mod:spritePlay(sprite, "Roll")
        npc.Position = npc.Position + Vector(3,0)
        if npc.StateFrame > 1000 then
            npc:Remove()
        end
    end

    if sprite:IsEventTriggered("Attack") then
       -- npc:PlaySound(SoundEffect.cvscookherepls,1,2,false,math.random(9,11)/10)
        for i = 1, 3, 1 do
            local projectile = Isaac.Spawn(9, 0, 0, (npc.Position + Vector(0,-100)), (player.Position - (npc.Position + Vector(0,-100))):Resized(10):Rotated(-30 + (i-1)*30) , npc):ToProjectile();
            projectile:GetData().isWillowalker = true
            projectile:GetData().targ = npc:GetPlayerTarget()
            projectile.FallingAccel = -0.1
            projectile.FallingSpeed = 0
            projectile:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
        end
    end

    if d.state == "bell" then
        if not d.bonged then
            mod:spritePlay(sprite, "BellInit")
            if npc.Position:Distance(player.Position) < 20 then
                d.bonged = true
            end
        else
            mod:spritePlay(sprite, "BellBonggg")
        end
    end
end

function mod.WillowalkerProj(v, d)
    if d.isWillowalker then

        local sprite = v:GetSprite()

        if not d.init then
            sprite:Load("gfx/projectiles/willowalkertear.anm2", true)
            sprite:Update()
            d.init = true
        end

        v.FallingAccel = v.FallingAccel + 0.00005

        mod:spritePlay(sprite, sprite:GetDefaultAnimation())
    end
end