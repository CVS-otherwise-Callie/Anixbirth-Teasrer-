local mod = FHAC
local game = Game()
local rng = RNG()

function mod:HuoAI(npc, sprite, d)

    local animPre = ""
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local extraamt = 0

    if animPre == "Big" then
        extraamt = 1
    elseif animPre == "Huge" then
        extraamt = 2
    end

    if not d.init then

        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        local grid = Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, npc.Position, true)
        grid:ToPit():UpdateCollision()
        
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        d.waitTime = 30
        npc.MaxHitPoints = npc.HitPoints * 3
        d.state = "pre"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    d.waitTime = (30*(extraamt + 1))

    npc.SpriteOffset = Vector(0, 5)

    if d.state == "pre" then
        mod:spritePlay(sprite, animPre.. "Out")
    elseif d.state == "idle" then
        if npc.StateFrame > d.waitTime then
            mod:spritePlay(sprite, animPre.. "ReadyShoot")
        else
            mod:spritePlay(sprite, animPre.. "Idle")
        end
    elseif d.state == "shoot" then
        mod:spritePlay(sprite, animPre.. "Shoot")
    end

    if sprite:IsFinished() and string.find(sprite:GetAnimation(), "Out") then
        d.state = "idle"
    elseif sprite:IsFinished() and string.find(sprite:GetAnimation(), "ReadyShoot") then
        d.state = "shoot"
    elseif sprite:IsFinished() and string.find(sprite:GetAnimation(), "Shoot") then
        d.state = "idle"
        npc.StateFrame = 0
    end

    if sprite:IsEventTriggered("Shoot") then
        if animPre == "" then
            local turnAmt = math.random(-30, 30)
            for i = 1, 10 do
                mod:ShootFire(npc.Position + Vector(20, 0):Rotated(36 * i), (targetpos - npc.Position):Resized(7):Rotated(turnAmt + (36 * i)), {scale = 1 + (extraamt*0.2), timer = 50 + (extraamt*5), radius = 20 + (extraamt)})
            end
        end
    end

end

