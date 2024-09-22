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
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local projparams = ProjectileParams()
    local patienttypes = {
        {
            name = "Virus",
            speed = "1",
            behavior = "WanderShoot",
            shootoffset = "60",
            headStart = math.random(1, 10),
            wait = math.random(-5, 5),
            state = "Moving"
        }
    }

    if not d.init then
        local tab
        if npc.SubType == nil or npc.SubType == 0 then
            tab= patienttypes[math.random(1, #patienttypes)]
        else
            tab = patienttypes[npc.SubType]
        end
        for h, g in pairs(tab) do
            if not d[h] then
                d[h] = g
            end
        end
        d.rounds = 0
        d.newpos = npc.Position
        sprite:SetOverlayAnimation("head")
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    --movement
    if d.behavior == "WanderShoot" then

        npc.CollisionDamage = 2

        if npc.StateFrame > tonumber(d.headStart) and not d.headInit then
            sprite:PlayOverlay("head", true)
            d.headInit = true
        end

        if npc.StateFrame > 60 + tonumber(d.wait) and d.state ~= "EndShoot" 
        and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false)
        and npc.Position:Distance(d.newpos) < 300 then
            d.state = "Shoot"
        end

        if d.state == "Moving" then

            if npc.Position:Distance(d.newpos) < 5 then
                d.wait = math.random(-5, 5)
                d.newpos = mod:freeGrid(npc, false, 200, 100)
                npc.StateFrame = 0
            elseif npc.StateFrame >  10 + d.wait then
                if mod:isScare(npc) then
                    local targetvelocity = (d.newpos - npc.Position)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed)):Resized(-4)
                elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
                    local targetvelocity = (d.newpos - npc.Position)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, tonumber(d.speed)):Resized(4)
                else
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

            if sprite:IsOverlayFinished("head") or sprite:IsOverlayFinished("shoot") then
                sprite:PlayOverlay("head", true)
            end
    
        elseif d.state == "Shoot" then
            sprite:SetFrame("walk h", 0)
            sprite:PlayOverlay("shoot", true)

            npc:MultiplyFriction(0.1)
            npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
            local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                effect.SpriteOffset = Vector(0,-6)
                effect.DepthOffset = npc.Position.Y * 1.25
                effect:FollowParent(npc)
                npc:FireProjectiles(npc.Position, Vector(10, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()), 0, projparams)
            d.state = "EndShoot"
        end

        if sprite:IsOverlayFinished("shoot") then
            d.state = "Moving"
            npc.StateFrame = 7
        end
    end

    if target.Position.X < npc.Position.X then
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end
                        --finally animations
    if npc.Velocity:Length() > 2 then
        npc:AnimWalkFrame("walk h","walk v",0)
    else
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
        if math.random(2) == 2 then
            d.state = "Shoot" 
            npc:MultiplyFriction(0.7)
        end
    end
end

