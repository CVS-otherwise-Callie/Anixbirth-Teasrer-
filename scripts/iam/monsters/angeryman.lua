local mod = FHAC
local game = Game()
local rng = RNG()

function mod:AngerymanAI(npc, sprite, d)

    local webHP = 20 + (10*(game:GetLevel():GetAbsoluteStage()-1))

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.state = "stuck"
        d.stuckdegradeNum = 0
        d.lerpnonsense = 0.08
        d.coolaccel = 1.2
        d.sped = math.random(3, 8)
        d.head = tostring(math.random(3))
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "stuck" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        if d.stuckdegradeNum > webHP then
            d.state = "awaken"
        end
        mod:spriteOverlayPlay(sprite, "HeadCalm" .. d.head)
        sprite:SetFrame(math.floor(3-math.ceil((webHP - d.stuckdegradeNum)/(webHP/3))))
    elseif d.state == "awaken" then
        mod:spriteOverlayPlay(sprite, "HeadTransition" .. d.head)
    elseif d.state == "charge" then

        mod:spriteOverlayPlay(sprite, "HeadMad" .. d.head)

        d.dir = d.dir or (targetpos - npc.Position):GetAngleDegrees()

        if not d.chargeIn then
            if mod:isScare(npc) then
                local targetvelocity = Vector(12, 0):Rotated(d.dir*180)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                local targetvelocity = Vector(12, 0):Rotated(d.dir)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            end
        else
            if npc.StateFrame > 10 then
                d.state = "chase"
            end
        end

        if npc:CollidesWithGrid() then

            if d.chargeIn == nil then
                npc.StateFrame = 0
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 1, false, 1.5)
                Game():ShakeScreen(5)
                d.chargeIn = true
            end

        end
    elseif d.state == "chase" then
        mod:spriteOverlayPlay(sprite, "HeadMad" .. d.head)

        if d.coolaccel and d.coolaccel < 5 then
            d.coolaccel = d.coolaccel + 0.1
        end
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-10 - d.sped)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(10 + d.sped)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        else
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

    end

    if sprite:IsOverlayFinished("HeadTransition" .. d.head) then
        d.state = "charge"
    end

    if not (d.state == "stuck" or d.state == "awaken") then
        if npc.Velocity:Length() > 1.3 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0.1)
        else
            sprite:SetFrame("WalkHori", 0)
        end
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type == mod.Monsters.AngeryMan.ID and npc.Variant == mod.Monsters.AngeryMan.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        if npc:GetData().state == "stuck" or npc:GetData().state == "awaken" then
            npc:GetData().stuckdegradeNum = npc:GetData().stuckdegradeNum + damage
            return false
        end
    end
end)

