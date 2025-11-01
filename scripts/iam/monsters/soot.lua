local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SootAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    npc.SplatColor = mod.Color.Invisible

    if not d.init then
        d.state = "idle"
        d.number = math.random(1, 6)
        d.trueRotation = Vector(math.random(-1, 1), math.random(-1, 1))
        d.falseRotation = math.random(0, 360)
        d.shouldFlipAnyway = math.random(1, 2)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
        path:MoveRandomly(false)
        npc:MultiplyFriction(0.65+(0.016))

        mod:spritePlay(sprite, "Idle" .. tostring(d.number))
        if npc.StateFrame > math.random(15, 20) then
            if math.random(0, 2) > 1 then
                d.newpos = targetpos
            else
                d.newpos = mod:freeGrid(npc, false, 300, 200) or mod:freeHole(npc, false, 300, 0)
            end
            d.rot = (targetpos - npc.Position):GetAngleDegrees()
            mod:spritePlay(sprite, "Move" .. tostring(d.number))
            d.state = nil
        end
    end

    npc:MultiplyFriction(0.9)

    if d.state == "move" then
        --sprite.Rotation = d.rot
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.9)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.9)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end
        d.state = nil
    end

    if d.shouldFlipAnyway == 1 then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    sprite.Scale = sprite.Scale * d.trueRotation
    --sprite.Rotation = d.falseRotation

    if sprite:IsEventTriggered("Move") then
        d.state = "move"
    end

    if sprite:IsFinished("Move" .. tostring(d.number)) then
        d.state = "idle"
        npc.StateFrame = 0
    end

    if npc:IsDead() then
        local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(0, -10),Vector.Zero, nil):ToEffect()
        ef:SetTimeout(10)
        ef.SpriteScale = Vector(0.07,0.07)
        ef:Update()
        ef.Color = Color(0.1, 0.1, 0.1, 1)
        ef:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)

    if npc.Type == mod.Monsters.Soot.ID and npc.Variant == mod.Monsters.Soot.Var then
        
        local d = npc:GetData()

        d.eyesVec = d.eyesVec or Vector(math.random(-1, 1), math.random(-1, 1))
        d.eyessprite = d.eyessprite or math.random(0, 1)

        local s = Sprite()

        s:Load("gfx/monsters/soot/soot.anm2", true)
        s:Play("Eyes", true)
        s:SetFrame(d.eyessprite)

        s:Render(Isaac.WorldToScreen(npc.Position))

        s.Scale = s.Scale * d.eyesVec

    end

end)
