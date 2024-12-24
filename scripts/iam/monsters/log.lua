local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Log.Var then
        mod:LogAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Log.ID)

function mod:LogAI(npc, sprite, d)

    if npc.SubType >= 0 then
        if not d.spawnerinit and not d.hasbeenSpawned then
            if npc.SubType == 0 then npc.SubType = math.random(0, 2) end
            for i = 0, npc.SubType - 2 do
                local log = Isaac.Spawn(Isaac.GetEntityTypeByName("Log"),  Isaac.GetEntityVariantByName("Log"), 0, npc.Position + Vector(0, 10):Rotated(math.random(180)), Vector.Zero, npc)
                log:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                log:GetData().hasbeenSpawned = true
            end
            npc.SubType = 0
            d.spawnerinit = true
        end
        npc.SubType = 0
    end

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.leginit then

        d.state = "idle"
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/log/log" .. math.random(5))
        d.speed = math.random(50, 100)/math.random(100, 200)
        d.offset = math.random(0, 5)
        npc.SpriteOffset = Vector(0, -2)

        if math.random(2) == 2 then
            d.FlipX = false
        else
            d.FlipX = true
        end

        if targetpos.X < npc.Position.X then
            d.Xgreater = true
        else
            d.Xgreater = false
        end

        d.leginit = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if targetpos.X > npc.Position.X and d.Xgreater then
        if d.FlipX == true then
            d.FlipX = false
        else
            d.FlipX = true
        end    
        d.Xgreater = false
    elseif targetpos.X < npc.Position.X and d.Xgreater == false then
        if d.FlipX == true then
            d.FlipX = false
        else
            d.FlipX = true
        end
        d.Xgreater = true
    end

    sprite.FlipX = d.FlipX

    if d.state == "idle" then
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame > 10+d.offset then
            d.state = "squat"
        end
    elseif d.state == "squat" then
        if not d.squatinit == true then
            mod:spritePlay(sprite, "Squat")
        else
            mod:spritePlay(sprite, "SquatLoop")
        end
        if npc.StateFrame > 20+d.offset then
            d.state = "jump"
        end
    elseif d.state == "jump" then
        mod:spritePlay(sprite, "Jump")
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        else
            path:FindGridPath(target.Position, 0.5, 1, true)
        end    
    end

    if sprite:IsFinished("Squat") then
        d.squatinit = true
    end

    if sprite:IsEventTriggered("Land") then
        npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1,1, false, 1)
        d.offset = math.random(-1, 5)
        d.state = "idle"
        npc.StateFrame = 0
    end

end

