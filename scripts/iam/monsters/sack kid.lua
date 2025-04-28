local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SackKid.Var then
        mod:SackKidAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SackKid.ID)

function mod:SackKidAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()
    local playerpos = player.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.state = "idle"
        d.init = true
        d.icanMove = false
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        npc.Velocity = Vector.Zero
        if npc.StateFrame > 50 then
            d.state = "hop"
        end
    elseif d.state == "hop" then
        mod:spritePlay(sprite, "Jump")
    end

    if sprite:IsEventTriggered("Rise") then
        d.icanMove = true
    elseif sprite:IsEventTriggered("Fall") then
        d.icanMove = false
    end

    if sprite:IsFinished("Jump") then
        d.state = "idle"
    end

    if d.icanMove then
        if mod:isScare(npc) then
            local targetvelocity = (d.targetpos - d.originalpos):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,d.targetpos,0,1,false,false) then
            local targetvelocity = (d.targetpos - d.originalpos):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else

            path:FindGridPath(playerpos, 1.3, 1, true)

        end
    else
        d.targetpos = playerpos
        if npc.Velocity.X == 0 and  npc.Velocity.Y == 0 then
            d.originalpos = npc.Position
        end
        npc:MultiplyFriction(0.8)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.SackKid.Var and npc.HitPoints - dmg <= 0 then
        local room = Game():GetRoom()
        local gridEntity = room:GetGridEntityFromPos(npc.Position)
        local gridIndex = room:GetGridIndex(npc.Position)
        local gridType = nil
        if gridEntity then
            gridType = gridEntity:GetType()
        else
            gridType = 0
        end
        if gridType < 2 then
            room:SpawnGridEntity(gridIndex, 10, 0, math.random(1,4294967295), 0)
        end
        return true
    end
end, 161)