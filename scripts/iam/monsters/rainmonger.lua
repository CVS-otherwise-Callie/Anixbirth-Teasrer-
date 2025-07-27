local mod = FHAC
local game = Game()
local rng = RNG()

function mod:RainMongerAI(npc, sprite, d)
    local room = Game():GetRoom()
    local path = npc.Pathfinder
    local target = npc:ToNPC():GetPlayerTarget()

    if not d.init then
        d.wait = 5
        d.state = "rainin"
        d.rounds = 0
        d.newpos = npc.Position
        sprite:SetOverlayAnimation("Head")
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > tonumber(0) and not d.headInit then
        d.headInit = true
    end

    for i = 1, 3 do
        if math.random(1, i*3) == i then
            local drip = Isaac.Spawn(1000, EffectVariant.RAIN_DROP, 0, room:GetClampedPosition(npc.Position + Vector(math.random(-100, 100), math.random(-100, 100)), 15)+ (Vector(10, 0)):Rotated((target.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20)), Vector.Zero, npc)
            local proj = Isaac.Spawn(9, 4, 0, drip.Position , Vector.Zero, npc):ToProjectile()
            proj.Height = -200
            proj.FallingAccel = 5
            proj.FallingSpeed = 10
        end
    end

    if d.newpos.X < npc.Position.X then
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end
                        --finally animations
    if npc.Velocity:Length() > 2 then
        sprite:SetOverlayFrame("HeadHori", 0)
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
    else
        sprite:SetOverlayFrame("Head", 0)
        sprite:SetFrame("WalkVert", 0)
    end

    --patient code for moving
    if npc.Position:Distance(d.newpos) < 5 then
        d.wait = math.random(-5, 5)
        d.newpos = mod:freeGrid(npc, false, 200, 100)
        npc.StateFrame = 0
    elseif npc.StateFrame >  10 + d.wait then
        if mod:isScare(npc) then
            local targetvelocity = (d.newpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1):Resized(-4)
        elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
            local targetvelocity = (d.newpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1):Resized(4)
        else
            path:FindGridPath(d.newpos, 0.7, 1, true)
        end

        if npc.Velocity:Length() > 1 then
            
        mod:CatheryPathFinding(npc, d.newpos, {
            Speed = 1,
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

    if sprite:IsOverlayFinished("HeadHori") then
        sprite:PlayOverlay("HeadHori", true)
    end

    sprite:Update()
end

