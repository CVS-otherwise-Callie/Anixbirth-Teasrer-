local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Weblet.Var then
        mod:WebletAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Weblet.ID)

function mod:WebletAI(npc, sprite, d)
    local path = npc.Pathfinder
    local room = game:GetRoom()
    local player = npc:GetPlayerTarget()
    local params = ProjectileParams()
    params.HeightModifier = 10
    params.Scale = 0.3
    params.FallingSpeedModifier = -0.1
    params.FallingAccelModifier = 0


    if not d.init then

        d.speed = 10
        d.init = true
        d.emotion = "Excited"
        d.randomtimer = math.random(25,50)
        d.shootcooldown = 0
        d.holdshoot = 10
        if npc.Parent then
            d.zvel = -2
        else
            d.zvel = 0
        end

        if npc.Parent then
            npc.EntityCollisionClass = 0
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            if npc.Parent.Type == 161 and npc.Parent.Variant == mod.Monsters.WebMother.Var then
                npc.Position = Vector(npc.Parent.Position.X + math.random(-20,15), npc.Position.Y)
                npc.DepthOffset = 1
                npc.SpriteOffset = Vector(0,math.random(-10,10))
            end
            d.state = "escapingappear"
        else
            npc.HitPoints = 6
            d.state = "chase"
        end
    else
        npc.StateFrame = npc.StateFrame + 1
        d.shootcooldown = d.shootcooldown - 1
    end

    if npc.StateFrame%3 == 0 then
        d.faceframe = npc.StateFrame%2
    end

    if d.state == "escapingappear" then
        if npc.Parent:GetData().state == "dead" then
            npc:Kill()
        end
        mod:spritePlay(sprite, "HeadAppear")
        if sprite:IsFinished() then
            d.state = "escapingidle"
        end
    end

    if d.state == "escapingidle" then
        if npc.Parent:GetData().state == "dead" then
            npc:Kill()
        end
        sprite:SetFrame("HeadDown"..d.emotion, d.faceframe)
        if npc.StateFrame > d.randomtimer then
            if npc.Parent.Type == 161 and npc.Parent.Variant == mod.Monsters.WebMother.Var then
                d.state = "escape"
            end
        end
    end

    if d.state == "escape" then
        if npc.Parent:GetData().state == "dead" then
            npc:Kill()
        end
        mod:spritePlay(sprite, "Escape")
        if sprite:IsFinished() then
            npc.Velocity = Vector(math.random(-5,5)/5,math.random(1,5)/5)
            d.state = "chase"
        end
    end


    if d.state == "chase" then
        if npc.SpriteOffset.Y < 0 or d.zvel < 0 then
            npc.SpriteOffset = npc.SpriteOffset + Vector(0,d.zvel)
            d.zvel = d.zvel + 0.2
        else
            npc.EntityCollisionClass = 4
            d.playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
            if player.Position then
                if mod:GetClosestMinisaacAttackPos(npc.Position, player.Position, 150, true, 75) then
                    d.speed = 10
                    d.targetpos = mod:GetClosestMinisaacAttackPos(npc.Position, player.Position, 150, true, 75)
                else
                    d.speed = 7
                    d.targetpos = player.Position
                end
                local _, direction = mod:GetClosestMinisaacAttackPos(npc.Position, player.Position, 150, true, 75)
                if direction == nil then
                    d.direction = "Down"
                else
                    d.direction = direction
                end
            end

            if npc.Position:Distance(d.playerpos) < 20 then
                path:EvadeTarget(d.playerpos)
            elseif npc.Position:Distance(d.targetpos) > 5 then
                if room:CheckLine(npc.Position,d.targetpos,0,1,false,false) then
                    local targetvelocity = (d.targetpos - npc.Position):Resized(d.speed)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
                else
                    path:FindGridPath(d.targetpos, d.speed/7, 0, false)
                end
            else
                if npc.Velocity:Length() < 0.01 then
                    npc.Velocity = npc.Velocity*0
                else
                    npc.Velocity = npc.Velocity*0.75
                end
            end

            if npc.Parent and not npc.Parent:GetData().state == "dead" then
                if npc.Parent:GetData().comeback == true then
                    if math.random(10) == 1 then
                        npc.StateFrame = 0
                        d.randomtimer = math.random(25)
                        d.state = "getbored"
                    end
                end
            end
        end

    end

    if d.state == "getbored" then
        mod:spriteOverlayPlay(sprite, "SwitchToBored")
        if sprite:IsOverlayFinished() then
            d.emotion = "Bored"
            if npc.StateFrame > d.randomtimer then
                d.speed = 3
                d.state = "return"
            end
        end
        npc:MultiplyFriction(0.8)
    end

    if d.state == "return" then
        if npc.Parent and not npc.Parent:GetData().state == "dead" then
            d.targetpos = npc.Parent.Position
                if npc.Position:Distance(d.targetpos) > 5 then
                    if room:CheckLine(npc.Position,d.targetpos,0,1,false,false) then
                        local targetvelocity = (d.targetpos - npc.Position):Resized(d.speed)
                        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
                    else
                        path:FindGridPath(d.targetpos, d.speed/7, 0, false)
                    end
                else
                    if npc.Velocity:Length() < 0.01 then
                        npc.Velocity = npc.Velocity*0
                    else
                        npc.Velocity = npc.Velocity*0.75
                    end
                end
        else
            d.emotion = "Excited"
            d.state = "chase"
        end
    end

    if d.state == "disappear" then
        sprite:RemoveOverlay()
        mod:spritePlay(sprite, "Disappear")
        if sprite:IsFinished() then
            npc:Remove()
        end
    end

    if d.state == "chase" or d.state == "return" then
        --head
        if npc.Velocity:Length() > 1 then
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    sprite:SetOverlayFrame("HeadRight"..d.emotion,d.faceframe)
                else
                    sprite:SetOverlayFrame("HeadLeft"..d.emotion,d.faceframe)
                end
            else
                if npc.Velocity.Y > 0 then
                    sprite:SetOverlayFrame("HeadDown"..d.emotion,d.faceframe)
                else
                    sprite:SetOverlayFrame("HeadUp"..d.emotion,d.faceframe)
                end
            end
        else
            sprite:SetOverlayFrame("HeadDown"..d.emotion, d.faceframe)
        end
        --body
        if npc.Velocity:Length() > 1 then
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    mod:spritePlay(sprite, "WalkRight")
                else
                    mod:spritePlay(sprite, "WalkLeft")
                end
            else
                if npc.Velocity.Y > 0 then
                    mod:spritePlay(sprite, "WalkDown")
                else
                    mod:spritePlay(sprite, "WalkUp")
                end
            end
        else
            sprite:SetFrame("WalkDown",0)
        end

        --shooting
        if d.targetpos then
            if npc.Position:Distance(d.targetpos) < 30 then
                sprite:SetOverlayFrame("Head"..d.direction..d.emotion,d.faceframe)
            end

            if mod:canshoot(npc.Position, d.targetpos, d.shootcooldown) and d.holdshoot > 0 then
                if not d.hasshot then
                    d.hasshot = true
                    npc:FireProjectiles(npc.Position, mod:convertWordDirectionToVector(d.direction):Resized(5), 0, params)
                end
                sprite:SetOverlayFrame("Head"..d.direction..d.emotion,2)
                d.holdshoot = d.holdshoot - 1
            else
                d.holdshoot = 10
                d.hasshot = false
            end
            if d.holdshoot <= 0 and d.shootcooldown <= 0 then
                d.shootcooldown = math.random(100,150)
            end
        end
    end
end

function mod:canshoot(position, targetposition, cooldown)
    if position:Distance(targetposition) < 30 and cooldown <= 0 then
        return true
    else
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider, low)
    if npc.Type == mod.Monsters.Weblet.ID and npc.Variant == mod.Monsters.Weblet.Var and npc:GetData().state == "return" then
        if collider.InitSeed == npc.Parent.InitSeed then
            npc.Velocity = Vector.Zero
            npc.EntityCollisionClass = 0
            npc.Position = mod:Lerp(npc.Position, npc.Parent.Position, 0.4)
            npc:GetData().state = "disappear"
        end
    end
end, 161)