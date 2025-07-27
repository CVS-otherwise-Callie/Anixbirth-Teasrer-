local mod = FHAC
local game = Game()
local rng = RNG()

function mod:FlyveBomberAI(npc, sprite, d) --thanks euan lmaooooooooooo

    if not d.init then
        d.state = "idle"
        d.count = 0
        d.newpos = mod:freeGrid(npc, true, 200, 100)        
        d.FlyveBomberoffset = math.random(-5, 10)
        npc.StateFrame = 20 + d.FlyveBomberoffset
        d.funnyasslerp = 0.06
        d.coolaccel = 0.5
        --mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/plier/tiny plier", 0)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > 40 + d.FlyveBomberoffset and d.state == "idle" then
        if d.count >= 3 then
            d.state = "spawnpre"
        else
            d.count = d.count + 1
            npc.StateFrame = 0
            d.newpos = mod:freeGrid(npc, true, 200, 100)
        end
    end

    if not d.newpos then
        d.newpos = mod:freeGrid(npc, true, 200, 100)
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")

        if d.coolaccel and d.coolaccel < 5 then
            d.coolaccel = 0.5
            d.coolaccel = d.coolaccel + 0.1
        end
        if d.coolaccel and d.coolaccel < 20 then
            d.coolaccel = d.coolaccel + 0.5
        end
        mod:CatheryPathFinding(npc, d.newpos, {
            Speed = d.coolaccel,
            Accel = d.funnyasslerp,
            GiveUp = true
        })
        if rng:RandomInt(1, 2) == 2 then
            d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.04, 0.05)
        else
            d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.01, 0.02)
        end
        if mod:isScare(npc) then
            local targetvelocity = (d.newpos - npc.Position):Resized(-15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.funnyasslerp)
        else
            local targetvelocity = (d.newpos - npc.Position):Resized(15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.funnyasslerp)
        end
        if npc:CollidesWithGrid() then
            d.coolaccel = 1
        end
        npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.funnyasslerp):Resized(5)
    end

    if d.state == "spawnpre" then
        mod:spritePlay(sprite, "Up")
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        if not d.spawnPreInit then
            npc.StateFrame = 0
            d.spawnPreInit = true
        end
        if (npc.Position:Distance(npc:GetPlayerTarget().Position) < 3 or npc.StateFrame > 40 + d.FlyveBomberoffset) then
            npc.StateFrame = 0
            d.state = "spawn"
        end
    end

    if sprite:IsFinished("Up") then
        npc.Velocity = Vector.Zero
        d.newpos = npc:GetPlayerTarget().Position-- - npc.Position
        npc.Position = mod:Lerp(npc.Position, npc:GetPlayerTarget().Position, 0.2)--:Resized(10)
    end

    if d.state == "spawn" then
        mod:spritePlay(sprite, "Down")
        npc.Velocity = npc.Velocity * 0.1
    end

    if sprite:IsEventTriggered("spawn") then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        local bug = EntityNPC.ThrowSpider(npc.Position, npc, Vector(npc.Position.X+math.random(-30,30), npc.Position.Y+math.random(-30,30)), false, 4)
    end

    if sprite:IsFinished("Down") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        d.state = "idle"
        d.count = 0
        d.spawnPreInit = false
        npc.StateFrame = 0
    end

end

