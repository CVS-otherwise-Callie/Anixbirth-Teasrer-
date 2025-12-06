local mod = FHAC
local game = Game()
local rng = RNG()

function mod:HuoAI(npc, sprite, d)

    local animPre = ""
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local extraamt = 0


    if not d.init then

        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        --local grid = Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, npc.Position, true)
        --grid:ToPit():UpdateCollision()
        
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        d.waitTime = 30
        d.gLev2 = npc.HitPoints * 2
        d.gLev3 = npc.HitPoints * 3
        npc.MaxHitPoints = d.gLev3
        d.state = "pre"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    d.growth = d.growth or npc.HitPoints

    if d.growth > d.gLev3 then
        animPre = "Huge"
        extraamt = 2
    elseif d.growth > d.gLev2 then
        animPre = "Big"
        extraamt = 1
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

    if (d.growth > (d.gLev2 - (d.gLev2*0.1)) and animPre ~= "Big") or (d.growth > (d.gLev3 - (d.gLev3*0.1)) and animPre ~= "Huge") then
        mod:spritePlay(sprite, animPre.. "In")
        d.state = nil
        d.growth = d.growth + (d.growth*0.1) + 1
    end 

    if sprite:IsFinished() and string.find(sprite:GetAnimation(), "Out") then
        d.state = "idle"
    elseif sprite:IsFinished() and string.find(sprite:GetAnimation(), "ReadyShoot") then
        d.state = "shoot"
    elseif sprite:IsFinished() and string.find(sprite:GetAnimation(), "Shoot") then
        d.state = "idle"
        npc.StateFrame = 0
    elseif sprite:IsFinished() and string.find(sprite:GetAnimation(), "In") then
        d.state = "pre"
    end

    if sprite:IsEventTriggered("Shoot") then
        local turnAmt = math.random(-30, 30)
        for i = 1, 10 do
            print("a")
            mod:ShootFire(npc.Position + Vector(5, 0):Rotated(36 * i), (targetpos - npc.Position):Resized(9):Rotated(turnAmt + (36 * i)), {scale = 1 + (extraamt*0.2), timer = 50 + (extraamt*5), radius = 20 + (extraamt)})
        end
    end

end

