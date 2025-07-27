local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SpaarkerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        d.shootoffset = math.random(1, 25)
        d.init = true
    end

    npc.StateFrame = npc.StateFrame + 1

    path:MoveRandomly(false)
    npc:MultiplyFriction(0.65+(0.016))
    npc.Velocity = mod:Lerp(npc.Velocity, (targetpos - npc.Position):Resized(1), 0.1)

    if npc.StateFrame > 10 + d.shootoffset and not mod:isScareOrConfuse(npc) then
        mod:spritePlay(sprite, "Shoot")
    else
        mod:spritePlay(sprite, "Idle")
    end

    if sprite:IsEventTriggered("Shoot") then
        mod:ShootFire(npc.Position, (targetpos - npc.Position):Resized(15), {scale = 1, timer = 150, hp = 1, radius = 20})
    end

    if sprite:IsFinished("Shoot") then
        npc.StateFrame = 0
        d.shootoffset = math.random(1, 25)
    end

end

