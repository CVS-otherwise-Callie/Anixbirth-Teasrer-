local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SixheadbottomAI(npc, sprite, d)

    local rng = npc:GetDropRNG()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local params = ProjectileParams()
    params.HeightModifier = -1
    params.Scale = 1

    if not d.init then
        d.tilt = -2
        d.state = "Appear"
        d.Anim = "Shake"
        d.num = 0
        d.randomAng = rng:RandomInt(-180, 180)
        npc.Velocity = mod:Lerp(npc.Velocity, Vector(10, 0):Rotated(d.randomAng), 1)
        npc:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if sprite:IsFinished("Appear") then
        d.state = "idle"
        d.Anim = "Shake"
    elseif sprite:IsFinished("Shoot") then
        d.state = "idle"
    end

    if d.state == "shoot" then
        d.Anim = "Shoot"
        npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(15), 0, params)
    elseif d.state == "idle" then
        d.Anim = "Shake"
    end

    if d.state ~= "Appear" then
        sprite:Play(tostring(d.Anim) .. tostring(d.num))
    end

    local targvel = mod:diagonalMove(npc, 8, 1)
    local tiltCalc = Vector(targvel.X, 0):Resized(-1) * d.tilt
    targvel = (targvel + tiltCalc):Resized(5)

    if npc:CollidesWithGrid() then
        d.tilt = d.tilt * -1
    end
    
    if npc.StateFrame % 2 == 0 then
        npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.5)
    end

    if npc.Velocity.X < 0 then
        d.secondnum = -1
    else
        d.secondnum = 1
    end

    local var = (math.ceil(npc.Velocity:Length()-3))
    if var <= 0 then var = (var*-1)+1 end

    if npc.StateFrame%var > 0 and sprite:GetFilename() ~= "gfx/jokes/shhhh go away/disk.anm2" then
        d.num = d.num + 1*d.secondnum
        local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
        creep.Scale = 0.6
        creep:SetTimeout(creep.Timeout - 45)
        creep:Update()
        if d.num > 12 then
            d.num = 0
        elseif d.num < 0 then
            d.num = 12
        end
    end

    local roomBounds = {
        Vector(70, 150),
        Vector(570, 150),
        Vector(570, 410),
        Vector(70, 410)
    }

    if sprite:GetFilename() == "gfx/jokes/shhhh go away/disk.anm2" then
        for i = 1, #roomBounds do
            if npc.Position:Distance(roomBounds[i]) < 3 then
                local grid = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, Game():GetRoom():GetCenterPos(), true)
                grid.VarData = 1
                local spr = grid:GetSprite()
                spr:Load("gfx/grid/voidtrapdoor.anm2", true)
            end
        end        
    end
end

