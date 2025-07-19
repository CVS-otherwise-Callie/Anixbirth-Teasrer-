local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.ScorchedPeat.Var then
        mod:ScorchedPeatAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.ScorchedPeat.ID)

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
        d.state = "attack"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    if d.state == "attack" then

        local percent = math.abs(math.ceil(300 - npc.Position:Distance(playerpos))/1000)

        local targpos = Vector((target.Position.X - npc.Position.X) * percent, (target.Position.Y - npc.Position.Y) * percent)

        npc.Velocity = mod:Lerp(npc.Velocity, targpos, 0.06)

        if npc.Position:Distance(playerpos) < 80 or npc.StateFrame > 70 then
            npc.StateFrame = 0
            d.state = "escape"
            d.NewPos = GetScaredPosition()
        end
    end

    if d.state == "escape" then

        --DebugRenderer.Get():Circle(d.NewPos, 10)


        local targpos = (d.NewPos - npc.Position):Resized(12)

        npc.Velocity = mod:Lerp(npc.Velocity, targpos, 0.1)

        if npc.StateFrame > 50 or npc.Position:Distance(d.NewPos) < 20 then
            npc.StateFrame = 0
            d.state = "attack"
        end 
    end

end

