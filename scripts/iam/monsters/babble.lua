local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Babble.Var then
        mod:BabbleAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Babble.ID)

function mod:BabbleAI(npc, sprite, d)

    local path = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local projparams = ProjectileParams()
    rng:SetSeed(game:GetRoom():GetSpawnSeed(), 32)
    local num = game:GetLevel():GetAbsoluteStage()
    local isFlood = (room:GetBackdropType() == BackdropType.FLOODED_CAVES) or (room:GetBackdropType() == BackdropType.DOWNPOUR) 

    if num > 5 then
        num = 5
    end

    if not d.init then
        d.name = "Head"
        d.chargeup = math.random(120, 200) - 10*num
        d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
        d.wait = math.random(20, 40) - 3*num
        d.lerpnonsense = 0.06
        d.coolaccel = 1
        d.state = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "wander" then
        if npc.StateFrame <= d.CoolDown then
            if mod:isCharm(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
                else
                    path:FindGridPath(targetpos, 0.85, 1, true)
                end
            elseif mod:isScare(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                else
                    path:FindGridPath(targetpos, -0.85, 1, true)
                end
            else
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:MoveRandomly(false)
            end
        end
        if npc.StateFrame > d.CoolDown+d.wait then
            d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
            d.wait = math.random(20, 40) - 3*num
        end
        npc:MultiplyFriction(0.65+(0.04*num))

        if npc.StateFrame > d.chargeup then
            d.state = "chargeup"
            npc.StateFrame = 0
        end

    elseif d.state == "chargeup" then

        if not room:CheckLine(targetpos,npc.Position,3,900,false,false) then
            if mod:isCharm(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
                else
                    path:FindGridPath(targetpos, 0.85, 1, true)
                end
            elseif mod:isScare(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                else
                    path:FindGridPath(targetpos, -0.85, 1, true)
                end
            else
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:FindGridPath(targetpos, 0.7, 1, true)
            end
            d.dir = nil
        end

        if not d.chargingup then
            sprite:PlayOverlay("ChargeUpInit")
        else
            if npc.StateFrame <= 30 - d.wait then
                sprite:PlayOverlay("ChargeUp1")
            elseif npc.StateFrame <= 60 - d.wait then
                sprite:PlayOverlay("ChargeUp2")
            else
                sprite:PlayOverlay("ChargeUp3")
            end
            if npc.StateFrame > 70 then
                d.state = "charge"
                d.chargingup = false
                npc.StateFrame = 0
            end
        end
        npc:MultiplyFriction(0.85)
    elseif d.state == "charge" then
        if not d.charginginit then
            sprite:PlayOverlay("ChargeInit")
        else
            sprite:PlayOverlay("Charge")
            if npc:IsChampion() or game.Difficulty == 1 and npc.StateFrame < 10 then
                npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            else
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end

            if not d.PlayRoar then
                npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_A, 1, 1, false, 1)
                d.PlayRoar = true
            end

            d.dir = d.dir or (targetpos - npc.Position):GetAngleDegrees()

            if d.coolaccel and d.coolaccel < 5 then
                d.coolaccel = d.coolaccel + 0.1
            end
            if mod:isScare(npc) then
                local targetvelocity = Vector(8*num, 0):Rotated(d.dir*180)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                local targetvelocity = Vector(8*num, 0):Rotated(d.dir)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
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

            local projtype = 0

            if isFlood then
                projtype = ProjectileVariant.PROJECTILE_TEAR
            end

            if npc.StateFrame%(10-num) == 0 and npc.Velocity:Length() > 2 then
                for i = 1, 2 do
                    local realshot = Isaac.Spawn(9, projtype, 0, npc.Position + Vector(10, 0):Rotated(d.dir), npc.Velocity:Rotated(45+(90*i)), npc):ToProjectile()
                    realshot.FallingAccel = 0.6 - (0.1*num)
                end
            end

            if npc:CollidesWithGrid() then
                d.state = "slam"
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 1, false, 1)
                Game():ShakeScreen(3)
                d.PlayRoar = false
                npc.StateFrame = 0
                d.charginginit = false
            end
        end
    elseif d.state == "slam" then
        if not d.slaminit then
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            sprite:PlayOverlay("SlamInit")
        else
            if npc.StateFrame < 20 + d.wait then
                sprite:PlayOverlay("Slammed")

                if mod:isCharm(npc) then
                    if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                        npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
                    else
                        path:FindGridPath(targetpos, 0.85, 1, true)
                    end
                elseif mod:isScare(npc) then
                    if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                        npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                    else
                        path:FindGridPath(targetpos, -0.85, 1, true)
                    end
                else
                    npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                    path:MoveRandomly(false)
                end

                npc:MultiplyFriction(0.7)

            elseif not sprite:IsOverlayPlaying("HeadInit") then
                sprite:PlayOverlay("HeadInit")
                if npc.StateFrame%2 == 0 then
                    npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0, 1, 1, false, 1)
                end
            end
        end
    else
        if path:HasPathToPos(targetpos) then
            d.state = "wander"
        end
    end

    -- animation ending --

    if sprite:IsOverlayFinished("ChargeUpInit") then
        d.name = "ChargeUp1"
        d.chargingup = true
    end

    if sprite:IsOverlayFinished("ChargeInit") then
        d.charginginit = true
    end

    if sprite:IsOverlayFinished("SlamInit") then
        d.slaminit = true
    end

    if sprite:IsOverlayFinished("HeadInit") and d.state == "slam" then
        d.slaminit = false
        npc.StateFrame = 0
        d.dir = nil
        d.CoolDown = npc.StateFrame + math.random(50, 70)
        d.wait = math.random(10, 20)
        d.state = "idle"
    end

    -- animations --

    if targetpos.X < npc.Position.X then
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end

    if npc.Velocity:Length() > 1.3 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
    else
        if not sprite:IsOverlayPlaying() then sprite:SetOverlayFrame("Head", 0) end
        sprite:SetFrame("WalkVert", 0)
    end
            
    sprite:Update()

end

