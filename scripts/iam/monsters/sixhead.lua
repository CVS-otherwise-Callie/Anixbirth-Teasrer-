local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Sixhead.Var then
        mod:SixheadAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Sixhead.ID)

function mod:SixheadAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    
    if not d.init then
        d.rngshoot = Vector(100, 100):GetAngleDegrees() 
        d.wait = 1
        mod:spritePlay(sprite, "Appear")
        d.init = true
    elseif d.init then
        npc.StateFrame = npc.StateFrame + 1
    end

    if not d.ent or d.ent:IsDead() or not d.ent:Exists() or d.ent.Type == 1 or d.ent.Position:Distance(npc.Position) < 75 then
        d.ent = mod:GetSpecificEntInRoom("Bottom", npc, 75)
    else
        d.ent = target
    end

    local params = ProjectileParams()    
    params.Scale = 1
    params.BulletFlags = params.BulletFlags | ProjectileFlags.BOOMERANG | ProjectileFlags.CURVE_LEFT

    if d.state == "shake" then

        if (targetpos:Distance(npc.Position) < 150 or d.ent.Position:Distance(npc.Position) < 75) and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            mod:spritePlay(sprite, "AttackStart")
            d.state = "nullstate"
        else
            if not sprite:IsFinished("Shake") then
                mod:spritePlay(sprite, "Shake")
            end
        end

    elseif d.state == "attacking" then
    
        if sprite:IsEventTriggered("Shoot") then
            if d.wait%3 < math.random() then
                    if npc.Position:Distance(targetpos) <= npc.Position:Distance(d.ent.Position) then
                        for i = 0, 5 do
                            d.typeofShooting = "player"
                            local proj = Isaac.Spawn(9, 0, 0, npc.Position, Vector(5, 0):Rotated((60*i+d.rngshoot)), npc):ToProjectile()
                            proj:AddProjectileFlags(ProjectileFlags.BOOMERANG)
                            if d.shootleft then
                                proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                            else
                                proj:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
                            end
                            proj.Height = 0
                            proj.FallingSpeed = -10
                            proj.FallingAccel = 0.5
                            proj:Update()
                        end
                    else
                        local proj = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.random(4, 7), 0):Rotated((d.ent.Position - npc.Position):GetAngleDegrees()), npc):ToProjectile()
                        d.typeofShooting = "bottom"
                        proj:GetData().type = "GoToBottom"
                        proj:GetData().ent = d.ent
                        proj:GetData().target = target
                        proj:GetData().rngshoot = d.rngshoot
                        proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                        proj.Parent = npc
                        proj.Scale = 2
                        proj.FallingSpeed = -30
                        proj.FallingAccel = 1
                        proj:Update()
                end
                d.rngshoot = d.rngshoot + 30
                d.wait = 1
            else
                if d.shootleft then
                    d.shootleft = false
                else
                    d.shootleft = true
                end
                d.wait = d.wait + 1
            end
        end

        if ((targetpos:Distance(npc.Position) > 150 and d.typeofShooting == "player") or (d.ent.Position:Distance(npc.Position) > 75) and d.typeofShooting == "bottom") then
            d.state = "shake"
            npc.StateFrame = 0
            d.wait = 1
            d.typeofShooting = nil
        end
        mod:spritePlay(sprite, "Attack")

    end

    if sprite:IsFinished("Appear") and not d.state then
        d.state = "shake"
    elseif sprite:IsFinished("AttackStart") and d.state == "nullstate" then
        d.state = "attacking"
    end
end

function mod:SixheadShot(p, d)
    if d.type == "FromBottomToPlayer" then

        p:GetData().offyourfuckingheadset = 70 + math.random(-10, 10)
        p:GetData().StateFrame = 0
        p:GetData().Baby = d.ent
        p:GetData().Player = d.target
        p:GetData().type = "SyntheticHorf"

    elseif d.type == "GoToBottom" then
        
        if not d.init then
            d.mult = math.random(80, 120)/100
            d.mult2 = math.random(60, 80)/100
            d.randVec = Vector(math.random(-50, 50), math.random(-50, 50))
            d.init = true
        end

        d.targetpos = d.ent.Position
        local truepos = (d.targetpos - p.Position) + (d.targetpos - p.Position):Normalized()*d.mult
        d.randVec = mod:Lerp(d.randVec, Vector(math.random(-50, 50), math.random(-50, 50)), 0.05)
        p.Velocity = mod:Lerp(Vector.Zero, truepos + d.randVec, d.mult2*100/1500)

        if p.Height > 0 then
            for i = 0, 5 do
                local proj = Isaac.Spawn(9, 0, 0, p.Position, Vector(4, 0):Rotated((60*i+d.rngshoot)), p):ToProjectile()
                proj:GetData().ent = d.ent
                proj:GetData().num = i
                proj:GetData().rngshoot = d.rngshoot
                proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                proj.Parent = p
                proj:GetData().type = "FromBottomToPlayer"
                proj.FallingSpeed = -15
                proj.FallingAccel = 0.5
                proj:GetData().moveit = i*36
                proj:GetData().shouldFall = 70
            end
            p:Kill()
        end

    end
end

