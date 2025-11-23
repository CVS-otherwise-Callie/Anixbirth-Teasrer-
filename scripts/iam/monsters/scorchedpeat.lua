local mod = FHAC
local game = Game()
local rng = RNG()

function mod:ScorchedPeatAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local playerpos = target.Position
    local room = game:GetRoom()
    local count = 0

    local function num(x)
        return (playerpos + Vector(100, 0):Rotated((npc.Position - playerpos):GetAngleDegrees() + x)):GetAngleDegrees()
    end

    --keep this here since i keep forgetting how to make the circles and capsules
    --DebugRenderer.Get():Circle(playerpos - Vector(50, 0):Rotated((npc.Position - playerpos):GetAngleDegrees()), 10)


    local function GetScaredPosition()
        local pos = mod:freeGrid(npc, false, 200, 100)

        local trueang = (pos - playerpos):GetAngleDegrees()
        local highang = (npc.Position - playerpos):GetAngleDegrees() + 70
        local lowang = (npc.Position - playerpos):GetAngleDegrees() - 70

        --[[Isaac.DebugString(count)

        DebugRenderer.Get():Circle(pos, 10)

        local capsule = Capsule(npc.Position,playerpos, 20)
        local capsule2 = Capsule(npc.Position,npc.Position + Vector(100, 0):Rotated(highang), 10)
        local capsule3 = Capsule(npc.Position,npc.Position + Vector(100, 0):Rotated(lowang), 10)

        DebugRenderer.Get():Capsule(capsule)
        DebugRenderer.Get():Capsule(capsule2)
        DebugRenderer.Get():Capsule(capsule3)]]

        if pos:Distance(playerpos) > 90 and trueang < highang and trueang > lowang  then
            return pos
        elseif game:GetRoom():IsPositionInRoom(playerpos - Vector(100, 0):Rotated((npc.Position - playerpos):GetAngleDegrees()), 10) and count < 10000 then
            count = count + 1
            return GetScaredPosition()
        else
            return playerpos + Vector(50, 0):Rotated((npc.Position - playerpos):GetAngleDegrees())
        end
    end

    if not d.init then
        d.state = "idle"
        npc.StateFrame = 70
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    if d.state == "idle" then
        
        if npc.StateFrame > 60 then
            local targetvelocity = ((mod:freeGrid(npc, false, 300, 200) or mod:freeHole(npc, false, 300, 0)) - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
            npc.StateFrame = 0
        end

        npc:MultiplyFriction(0.95)

        if npc.Position:Distance(playerpos) < 200 then
            d.state = "attack"
        end

        if npc.Velocity.X < 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

    end


    if d.state == "attack" then

        local percent = math.abs(math.ceil(300 - npc.Position:Distance(playerpos))/1000)

        local targpos

        if not d.missTarg then
            targpos = Vector((target.Position.X - npc.Position.X) * percent, (target.Position.Y - npc.Position.Y) * percent)
        else
            targpos = Vector((d.missTarg.X - npc.Position.X) * percent, (d.missTarg.Y - npc.Position.Y) * percent)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, targpos, 0.04)

        if npc.Position:Distance(playerpos) < 80 then
            d.missTarg = playerpos
        end

        if (d.missTarg and npc.Position:Distance(d.missTarg) < 30) or npc.StateFrame > 70 then
            d.missTarg = nil
            npc.StateFrame = 0
            d.state = "escape"
            d.NewPos = GetScaredPosition()
        end

        if target.Position.X < npc.Position.X then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    end

    if d.state == "escape" then

        --DebugRenderer.Get():Circle(d.NewPos, 10)


        local targpos = (d.NewPos - npc.Position):Resized(12)

        npc.Velocity = mod:Lerp(npc.Velocity, targpos, 0.1)

        if npc.StateFrame > 50 or npc.Position:Distance(d.NewPos) < 20 then
            npc.StateFrame = 0
            if math.random(2) == 1 then
                d.state = "attack"
            else
                d.state = "idle"
            end
        end 

        if npc.Velocity.X < 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    end

    mod:spritePlay(sprite, "Idle")

end

