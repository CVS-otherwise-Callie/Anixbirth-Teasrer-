local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SackKid.Var then
        mod:SackKidAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SackKid.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.SackKid.Var then
        mod:SackKidRenderAI(npc)
    end
end, mod.Monsters.SackKid.ID)

local function FindIfSackKidsInRad(npc, rad)
    for k, v in ipairs(Isaac.FindInRadius(npc.Position, rad, EntityPartition.ENEMY)) do
        if v.Type == 161 and v.Variant == mod.Monsters.SackKid.Var then
            return true
        end
    end
    return false
end

function mod:SackKidAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()
    local playerpos = player.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    local function SackKidChoosePath()
        local num = 10
        if not path:HasDirectPath() then
            num = num - 2
        end
        if npc.HitPoints < npc.MaxHitPoints/2 then
            num = num - 2
        end
        if FindIfSackKidsInRad(npc, 100) then
            num = num - 2
        end

        if math.random(1, num) < 4 then
            return true
        else
            return false
        end
    end

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
        if npc.StateFrame > 20 then
            d.state = "hop"
            d.shouldShortHop = SackKidChoosePath()
        end
    elseif d.state == "hop" then

        if d.shouldShortHop then
            mod:spritePlay(sprite, "JumpSmall")
        else
            mod:spritePlay(sprite, "Jump")
        end
    end

    if sprite:IsEventTriggered("Rise") then
        d.icanMove = true
    elseif sprite:IsEventTriggered("Fall") then
        d.icanMove = false
    end

    if sprite:IsFinished("Jump") or sprite:IsFinished("JumpSmall") then
        d.state = "idle"
        npc.StateFrame = 0
    end

    if sprite:IsFinished("JumpSmall") then
        npc.StateFrame = 10
    end

    if d.shouldShortHop then
        targpos = mod:freeGrid(player, true, 100, 0, 0)
    else
        targpos = playerpos
    end

    if d.icanMove then
        if mod:isScare(npc) then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targpos,0,1,false,false) then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.6)
        else
            path:FindGridPath(playerpos, 1.3, 1, true)
        end
    else
        if mod:isScare(npc) then
            d.targetvelocity = (targpos - npc.Position):Resized(-7)
        elseif room:CheckLine(npc.Position,targpos,0,1,false,false) then
            d.targetvelocity = (targpos - npc.Position):Resized(7)
        end
        npc:MultiplyFriction(0.8)
    end

end

function mod:SackKidRenderAI(npc)
    if npc:IsDead() then
        Isaac.GridSpawn(GridEntityType.GRID_SPIDERWEB, 0, npc.Position, true)
    end
end