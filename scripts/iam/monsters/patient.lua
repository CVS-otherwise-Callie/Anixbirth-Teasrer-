local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Patient.Var then
        mod:PatientAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Patient.ID)

function mod:PatientAI(npc, sprite, d)

    local path = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local projparams = ProjectileParams()
    rng:SetSeed(game:GetRoom():GetSpawnSeed(), 0)
    local patienttypes = {
        {
            name = "virus",
            speed = "1",
            size = 1,
            behavior = "WanderShoot",
            detectrange = "300",
            shootoffset = "50",
            shottypes = {"Blood"},
            shotdamage = 1,
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving",
            subtype = "1"
        },
        {
            name = "speed",
            speed = "2",
            size = 1,
            behavior = "Chase",
            submovebehavior = "ProAPI",
            shootoffset = "0",
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Chasing",
            subtype = "2",
            lerpnonsense = 0.08,
            coolaccel = 1.2
        },
        {
            name = "roid",
            speed = "1.3",
            size = 1,
            behavior = "WanderShoot",
            detectrange = "1000",
            submovebehavior = "Charge",
            shottypes = {"Homing"},
            shotdamage = 1,
            shootoffset = "60",
            headStart = math.random(1, 10),
            wait = math.random(-5, 0),
            state = "Moving",
            subtype = "3"
        },
        {
            name = "experimental",
            speed = "1.7",
            size = 1,
            behavior = "WanderShoot",
            detectrange = "210",
            submovebehavior = "ProAPI",
            shottypes = {"Inner Eye", "Poly", "Soy Milk", "Number One"},
            shotdamage = 1, --this is a placeholder for ex. since it's based on chosen shot type
            shootoffset = math.random(40, 70),
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving",
            subtype = "4",
            lerpnonsense = 0.06,
            coolaccel = 1
        },
        {
            name = "growth",
            speed = "0.6",
            size = 1.135,
            behavior = "ChaseShoot",
            detectrange = "400",
            shootoffset = "40",
            shottypes = {"Blood"},
            shotdamage = 2,
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Chasing",
            subtype = "5"
        },
        {
            name = "synthoil",
            speed = "0.8",
            size = 1,
            behavior = "WanderShoot",
            submovebehavior = "Neutral",
            detectrange = "1000",
            shootoffset = "70",
            shottypes = {"Blood"},
            shotdamage = 1,
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving",
            subtype = "6"
        },
        {
            name = "adrenaline",
            speed = "1",
            size = 1,
            behavior = "WanderShoot",
            subbehavior = "HealSpeed",
            submovebehavior = "ProAPI",
            gainedspeed = "0.1",
            detectrange = "300",
            shootoffset = "60",
            shottypes = {"Blood"},
            shotdamage = 1,
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving",
            subtype = "7",
            lerpnonsense = 0.1,
            coolaccel = 1.4
        },
        {
            name = "euthanasia",
            speed = "1",
            size = 1,
            behavior = "WanderShoot",
            detectrange = "300",
            shootoffset = "10",
            shottypes = {"Euthanasia"},
            shotdamage = 1,
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving",
            subtype = "8"
        },
    }

    if not d.init then
        local tab
        if npc.SubType == nil or npc.SubType == 0 then
            tab = patienttypes[rng:RandomInt(1, #patienttypes - 1)]
        else
            tab = patienttypes[npc.SubType]
        end
        if d.name == "euthanasia" and (npc.SubType == nil or npc.SubType == 0) then
            tab = patienttypes[1]
        end
        for h, g in pairs(tab) do
            if not d[h] then
                d[h] = g
            end
        end
        d.rounds = 0
        npc.Scale = d.size
        d.newpos = npc.Position
        sprite:SetOverlayAnimation("head" .. d.name)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    --movement
    if d.behavior == "WanderShoot" then

        if d.name == "virus" then
            npc.CollisionDamage = 2
        end

        if npc.StateFrame > tonumber(d.headStart) and not d.headInit then
            sprite:PlayOverlay("head" .. d.name, true)
            d.headInit = true
        end

        if npc.StateFrame > tonumber(d.shootoffset) + tonumber(d.wait) and d.state ~= "EndShoot" 
        and path:HasPathToPos(target.Position)
        and npc.Position:Distance(target.Position) < tonumber(d.detectrange) then
            d.state = "Shoot"
        end

        if sprite:IsOverlayFinished("shoot"  .. d.name) then
            d.state = "Moving"
            npc.StateFrame = 7
        end
    elseif d.behavior == "Chase" then

        if npc.StateFrame > tonumber(d.headStart) and not d.headInit then
            sprite:PlayOverlay("head" .. d.name, true)
            d.headInit = true
        end

    elseif d.behavior == "ChaseShoot" then

        if npc.StateFrame > tonumber(d.headStart) and not d.headInit then
            sprite:PlayOverlay("head" .. d.name, true)
            d.headInit = true
        end

        if npc.StateFrame > tonumber(d.shootoffset) + tonumber(d.wait) and d.state ~= "EndShoot" 
        and path:HasPathToPos(target.Position)
        and npc.Position:Distance(target.Position) < tonumber(d.detectrange) then
            d.state = "Shoot"
        end

        if sprite:IsOverlayFinished("shoot"  .. d.name) then
            d.state = "Chasing"
            npc.StateFrame = 7
        end

    end

    if d.state == "Moving" then

        if d.submovebehavior == "ProAPI" then

            if d.coolaccel and d.coolaccel < 5 then
                d.coolaccel = d.coolaccel + 0.1
            end
            if mod:isScare(npc) then
                local targetvelocity = (d.newpos - npc.Position):Resized(-4*tonumber(d.speed))
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            elseif path:HasPathToPos(d.newpos) then
                local targetvelocity = (d.newpos - npc.Position):Resized(4*tonumber(d.speed))
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                path:FindGridPath(d.newpos, 0.7, 1, true)
            end

            npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
            if npc:CollidesWithGrid() then
                d.coolaccel = 1
            end
            mod:CatheryPathFinding(npc, target.Position, {
                Speed = d.coolaccel,
                Accel = d.lerpnonsense,
                GiveUp = true
            })
            if rng:RandomInt(1, 2) == 2 then
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
            else
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
            end
        
        else

            if npc.Position:Distance(d.newpos) < 5 then
                d.wait = math.random(-5, 5)
                d.newpos = mod:freeGrid(npc, true, 200, 100)
                npc.StateFrame = 0
            elseif npc.StateFrame > 10 + d.wait then
                if mod:isScare(npc) then
                    local targetvelocity = (d.newpos - npc.Position):Resized(-4)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed))
                elseif path:HasPathToPos(d.newpos) then
                    local targetvelocity = (d.newpos - npc.Position):Resized(4)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed))
                else
                    d.newpos = mod:freeGrid(npc, true, 200, 100)
                    path:FindGridPath(d.newpos, 0.7, 1, true)
                end

                if npc.Velocity:Length() > 1 then
                
                mod:CatheryPathFinding(npc, d.newpos, {
                    Speed = tonumber(d.speed),
                    Accel = 0.2,
                    Interval = 1,
                    GiveUp = true
                })
                end

                if d.avoid then
                    path:EvadeTarget(d.avoid.Position)
                end
            else
                npc:MultiplyFriction(0.1)
            end
        
        end

        if sprite:IsOverlayFinished("head"  .. d.name) or sprite:IsOverlayFinished("shoot"  .. d.name) then
            sprite:PlayOverlay("head"  .. d.name, true)
        end

    elseif d.state == "Shoot" then

        if d.behavior ~= "ChaseShoot" then
            sprite:SetFrame("walk h", 0)
            npc:MultiplyFriction(0.1)
        end

        sprite:PlayOverlay("shoot"  .. d.name, true)

        local shot = d.shottypes[math.random(#d.shottypes)]
        local shotvar
        local shotparams
        local shotspeed

        if shot == "Blood" then
            shotvar = 0
        elseif shot == "Homing" then
            shotparams = {ProjectileFlags.SMART}
        end

        if d.name == "growth" then
            shotspeed = 12
        else
            shotspeed = 10
        end

        npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-6)
        effect.DepthOffset = npc.Position.Y * 1.25
        effect:FollowParent(npc)
        local realshot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(shotspeed, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        if shotparams and #shotparams > 0 then
            for k, v in ipairs(shotparams) do
                realshot:AddProjectileFlags(v)
            end
        end

        if d.name == "euthanasia" then
            realshot:GetData().type = "PatientEuthanasia"
        end

        if shot == "Homing" then
            realshot:GetData().type = "ForeverHoming"
        end

        d.state = "EndShoot"
    elseif d.state == "Chasing" then

        if d.submovebehavior == "ProAPI" then

            if d.coolaccel and d.coolaccel < 5 then
                d.coolaccel = d.coolaccel + 0.1
            end
            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-10*tonumber(d.speed))
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            elseif path:HasPathToPos(d.newpos) then
                local targetvelocity = (targetpos - npc.Position):Resized(10*tonumber(d.speed))
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                local targetvelocity = (targetpos - npc.Position):Resized(10*tonumber(d.speed))
                path:FindGridPath(targetpos, 0.7, 1, true)
            end
            npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
            if npc:CollidesWithGrid() then
                d.coolaccel = 1
            end
            mod:CatheryPathFinding(npc, target.Position, {
                Speed = d.coolaccel,
                Accel = d.lerpnonsense,
                GiveUp = true
            })
            if rng:RandomInt(1, 2) == 2 then
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
            else
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
            end

        else

            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-5)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed))
            elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(5)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber((d.speed)))
            else
                local targetvelocity = (targetpos - npc.Position):Resized(5)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed))
                path:FindGridPath(target.Position, 0.5, 1, true)
            end    
        
        end

        if sprite:IsOverlayFinished("head"  .. d.name) or sprite:IsOverlayFinished("shoot"  .. d.name) then
            sprite:PlayOverlay("head"  .. d.name, true)
        end
            
    end

    if d.name == "speed" then
        if math.random(175) == 1 then
            npc:PlaySound(165,1,0,false,2)
        end
    end

    if d.subbehavior == "HealSpeed" then
        if game.TimeCounter%30 == 0 and npc.HitPoints < npc.MaxHitPoints then
            npc:AddHealth(1.5)
            d.speed = d.speed + 0.3
            d.wait = d.wait - 0.5
            if tonumber(d.shootoffset) > 10 then
                d.shootoffset = tostring(tonumber(d.shootoffset) - 2)
            end
            d.wait = 0
        end
    end

    if target.Position.X < npc.Position.X then
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end
                        --finally animations
    if npc.Velocity:Length() > 1.3 then
        npc:AnimWalkFrame("walk h","walk v",0)
    else
        if sprite:GetOverlayAnimation() == "head" then sprite:SetOverlayFrame("head", 0) end
        sprite:SetFrame("walk h", 0)
    end
            
    sprite:Update()

end

function mod:PatientGetHurt(npc, damage, flag, source, countdown)
    local d = npc:GetData()
    local path = npc.Pathfinder
    if d.behavior == "WanderShoot" then
        d.wait = math.random(-5, 5)
        d.newpos = mod:freeGrid(npc, false, 300, 200)
        d.avoid = source
        if math.random(2) == 2 and not d.state == "EndShoot" then
            d.state = "Shoot" 
            npc:MultiplyFriction(0.7)
        end
    end
end

function mod:PatientShots(v, d)
    if d.type == "ForeverHoming" then
        if not d.init then
            d.height = v.Height
            d.init = true
        end
        if v.FrameCount < 500 then
            v.Height = d.height
        end
    elseif d.type == "PatientEuthanasia" then
        v.SpriteRotation = v.Velocity:GetAngleDegrees()
        local psprite = v:GetSprite()
        psprite:ReplaceSpritesheet(0, "gfx/projectiles/needle_projectile.png")
        psprite:LoadGraphics()
    end
end

function mod:PatientEuthInstaKill(player, collider, low)
	player = player:ToPlayer()
	if collider.Type == 9 and collider:GetData().type then
		if collider:GetData().type == "PatientEuthanasia" then
			player:Kill()
			for i = 36, 360, 36 do
				local proj = Isaac.Spawn(9, 0, 0, player.Position + Vector(0,9):Rotated(i), Vector(0,9):Rotated(i), player):ToProjectile();
				local psprite = proj:GetSprite()
				psprite:ReplaceSpritesheet(0, "gfx/needle_tears.png")
				psprite:LoadGraphics()
				proj:GetData().type = "PatientEuthanasia"
				proj:Update()
			end
		end
    end
end

