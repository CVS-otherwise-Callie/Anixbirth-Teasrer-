local mod = FHAC
local game = Game()
local rng = RNG()

function mod:EnflamedCrazySpider(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.slamCooldown = 80
        d.state = "wanderFast"
        d.wanderCooldown = 5
        d.chaseOff = 0
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "wanderFast" then
        if npc.StateFrame > d.wanderCooldown then
            d.wanderCooldown = d.wanderCooldown + 5
        end

        mod:spritePlay(sprite, "Walk")

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-10)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
        elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(10)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
        else
            path:FindGridPath(targetpos, 0.7, 1, true)
        end

        if npc.StateFrame > 80 then
            d.state = "slammingTime"
        end
    elseif d.state == "slammingTime" then
        npc:MultiplyFriction(0.1)
        d.wanderCooldown = 5
        d.animName = d.animName or "Start"

        mod:spritePlay(sprite, "SlamQuick" .. d.animName)

        if d.animName == "" and npc.StateFrame > 20 then
            d.animName = "End"
        end
    end

    if sprite:IsFinished("SlamQuickStart") then
        d.animName = ""
        npc.StateFrame = 0
    elseif sprite:IsFinished("SlamQuickEnd") then
        d.animName = nil
        d.state = "wanderFast"
        npc.StateFrame = 0
    end

    if sprite:IsEventTriggered("Slam") then
        for i = 6, 13 do
            local proj = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.random(2, 7), 0):Rotated(math.random(1, 360)), npc):ToProjectile()
            proj.Height = -5
            proj.FallingSpeed = -20
            proj.FallingAccel = math.random(50, 300)/100
            proj:Update()
        end
    end

end

