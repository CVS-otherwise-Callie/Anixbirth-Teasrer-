local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Wost.Var then
        mod:WostAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Wost.ID)

function mod:WostAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local targetvelocity = (targetpos - npc.Position)
    local roomTears = room:GetEntities(EntityType.ENTITY_TEAR)
    for i = 0, #roomTears - 1 do
        local entity = roomTears:Get(i)
        if entity.Type == EntityType.ENTITY_TEAR then
        if (entity.Position - npc.Position):Length() < 40 and not entity:IsDead() and rng:RandomInt(1, 20) == 3 then
            d.StateFrame = 0
            mod:spritePlay(sprite, "hiding")
            d.state = "veryscaredhiding"
        end
        end
    end

    if not d.init then
        d.state = "idle"
        --heehee wailer code go brr
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        --end of wailer
        npc.SpriteOffset = Vector(0,-5)
        d.otherstateframe = 0
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.SplatColor = Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)
        d.params = ProjectileParams()
        d.params.BulletFlags = ProjectileFlags.GHOST
        npc.StateFrame = 20
        d.init = true
    end

    npc.Velocity = mod:Lerp(npc.Velocity, Vector(rng:RandomInt(-5, 5), rng:RandomInt(-5, 5)), -0.25)
    npc.Velocity = npc.Velocity:Resized(1/5)

    --noticing
    if (target.Position - npc.Position):Length() < 300 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then 
        if target.Position.X < npc.Position.X then --future me pls don't fuck this up
		    sprite.FlipX = true
	        else
		    sprite.FlipX = false
	    end
    else
        d.otherstateframe = d.otherstateframe + 1
        if d.otherstateframe > 70 then --future me pls don't fuck this up
            if rng:RandomInt(1, 2) == 2 then
		    sprite.FlipX = true
	        else
		    sprite.FlipX = false
            end
            d.otherstateframe = 0
	    end
    end
    --shooting
    if d.state == "idle" and (target.Position - npc.Position):Length() < 150 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) and not room:IsClear() then
        npc.StateFrame = npc.StateFrame + 1
        if npc.StateFrame >= 40 then
            d.state = "shoot"
            npc.StateFrame = 0
            mod:spritePlay(sprite, "Shoot")
        end
    end
    --dissapearing
    if d.state == "idle" and ((target.Position - npc.Position):Length() < 100 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false)) then 
        mod:spritePlay(sprite, "hiding")
        if rng:RandomInt(1, 2) == 1 then
            d.state = "veryscaredhiding"
            npc.StateFrame = 0
        else
            d.state = "kindascaredhiding"
            npc.StateFrame = 0
        end
    end

    if d.state == "idle" then
        sprite:Play("Idle")
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if sprite:IsFinished("Shoot") then
            d.state = "idle"
    end

    function mod:wostFind(far, close)
        local tab = {}
        for i = 0, room:GetGridSize() do
            if room:GetGridPosition(i):Distance(npc.Position) < far and room:GetGridPosition(i):Distance(npc.Position) > close and room:GetGridEntity(i) == nil and room:IsPositionInRoom(room:GetGridPosition(i), 0) and not room:CheckLine(room:GetGridPosition(i), target.Position, 1) then
                table.insert(tab, room:GetGridPosition(i))
            end
        end
        if #tab == 0 then
            return npc.Position + npc.Position
        end
        return tab[rng:RandomInt(1, #tab - 1)]
    end


    if d.state == "veryscaredhiding" then
        npc.StateFrame = npc.StateFrame + 1
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE  
        if npc.StateFrame >= 10 then
                    npc.Position = mod:wostFind(250, 300)
                    npc.StateFrame = 0
                d.state = "idle"
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                mod:spritePlay(sprite, "appear")
                if rng:RandomInt(1, 5) == 5 then
                    d.state = "shoot"
                    npc.StateFrame = 0
                    mod:spritePlay(sprite, "Shoot")
                end
        end
    end

    if d.state == "kindascaredhiding" then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            if targetpos:Distance(npc.Position) > 100 or d.entitytearinrange == false then
                npc.StateFrame = npc.StateFrame + 1
                if npc.StateFrame >= 20 then
                    npc.StateFrame = 0
                d.state = "idle"
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                mod:spritePlay(sprite, "appear")
                if rng:RandomInt(1, 5) == 5 then
                    d.state = "shoot"
                    npc.StateFrame = 0
                    mod:spritePlay(sprite, "Shoot")
                end
            else
                d.state = "kindascaredhiding"
            end
        end
    end

--all shooty shit
    if sprite:IsEventTriggered("shoot") then
        d.projectile = Isaac.Spawn(9, 4, 0, npc.Position, Vector.Zero, npc):ToProjectile()
        d.projectile.Color = Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)
        d.projectile.ChangeTimeout = d.projectile.ChangeTimeout * 13.4
        d.projectile.Scale = d.projectile.Scale * 0.2
        d.projectile.Velocity = mod:Lerp(d.projectile.Velocity, targetpos - npc.Position, targetpos:Distance(d.projectile.Position) * 0.00001)
        d.projectile.FallingAccel = 0.15
        d.projectile.FallingSpeed = -3
        d.projectile.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.GHOST | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
    end

    if d.projectile then
        local targetvelocity = (targetpos - d.projectile.Position)
        d.projectile.Velocity = mod:Lerp(d.projectile.Velocity, targetvelocity, 0.00175)
        if d.projectile.FallingAccel >= 0.15 and d.projectile.FallingSpeed >= 0 and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or 
        npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) or not room:IsClear() or not npc:IsDead() or d.projectile.FrameCount < 400 then
			d.projectile.FallingSpeed = 0
			d.projectile.FallingAccel = -0.1
        else
            d.projectile:Remove()
		end
        if not room:IsPositionInRoom(d.projectile.Position, 1) then
            d.projectile.ProjectileFlags = (d.projectile.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.GHOST | ProjectileFlags.CONTINUUM)
        else
            if d.projectile:HasProjectileFlags(ProjectileFlags.CONTINUUM) then
            d.projectile:ClearProjectileFlags(ProjectileFlags.CONTINUUM)
            end
        end
        if d.projectile.Velocity:Length() > 4 then
            d.projectile.Velocity = d.projectile.Velocity * 0.8
        end
        if (d.projectile.FrameCount > 400 and d.projectile.FallingSpeed == 0) or room:IsClear() or npc:IsDead() then
            d.projectile.ChangeTimeout = 0
            d.projectile:Remove()
        end
        function mod:RemoveWostProj(proj, collider)
            if proj.SpawnerVariant ~= nil and collider.Type == EntityType.ENTITY_PLAYER and proj.SpawnerVariant == mod.Monsters.Wost.Var and proj.SpawnerEntity.SubType == mod.Monsters.Wost.Subtype then
                proj:Remove()
            end
        end
        mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.RemoveWostProj)
    end
end

