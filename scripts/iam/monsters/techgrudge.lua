local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TechGrudge.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeLaser(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TechGrudge.ID)

function mod:TechGrudgeAI(npc, sprite, d)

    local function TechGrudgeEnt(pos)

        local tab = {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_BOMB, GridEntityType.GRID_ROCK_ALT, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT, GridEntityType.GRID_FIREPLACE,
        GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS, GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2,
        GridEntityType.GRID_ROCK_GOLD}
        --1 is right, 2 is up, 3 is left, 4 is down
        if pos == 2 or pos == 4 then
            local twoaxis = mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, 2*-90, tab)
            local fouraxis = mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, 4*-90, tab)

            if npc.Position:Distance(twoaxis.Position) < 30 and npc.Position:Distance(fouraxis.Position) < 30 then
                return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, d.direction*-90, tab, 30)
            end

            return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, d.direction*-90, tab)
        end

        if pos == 1 or pos == 3 then
            local oneaxis = mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, 1*-90, tab)
            local threeaixs = mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, 3*-90, tab)

            if npc.Position:Distance(oneaxis.Position) < 30 and npc.Position:Distance(threeaixs.Position) < 30 then
                return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, d.direction*-90, tab, 30)
            end

            return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, d.direction*-90, tab)        
        end

    end
    local room = game:GetRoom()
    mod:spritePlay(sprite, "FlySouth")

    local grid = d.grid
        
    if not d.init then
        d.state = "above"
        if npc.SubType >=1 and npc.SubType <= 4 then
            d.direction = npc.SubType
        else
            d.direction = math.random(1, 4)
        end
        d.oldtarget = Isaac.WorldToScreen(npc.Position)
        d.oldtrailend = npc.Position
        d.grid = TechGrudgeEnt(d.direction)
        d.dist = math.random(100, 200)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.init = true
    end

    d.grid = TechGrudgeEnt(d.direction)
    
    if d.state == "above" then

        npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 10):Rotated(-90*d.direction), 0.1)

        --this last part
        if not mod:GetClosestGridEntToPos(npc.Position, true, true) then return end

        if d.direction == 1 or d.direction == 3 then
            if grid and grid.Position:Distance(npc.Position) < d.dist then
                npc:MultiplyFriction(0.8)
                if d.direction >= 4 then
                    d.direction = 1
                else
                    d.direction = d.direction + 1
                end
                d.grid = TechGrudgeEnt(d.direction)
                d.dist = 50
            end
        else
            if grid and grid.Position:Distance(npc.Position) < d.dist then
                npc:MultiplyFriction(0.8)
                if d.direction >= 4 then
                    d.direction = 1
                else
                    d.direction = d.direction + 1
                end
                d.grid = TechGrudgeEnt(d.direction)
                d.dist = 50
            end
        end

        local bsprite = Sprite()
        bsprite:Load("gfx/007.002_thin red laser.anm2", true)
        bsprite:Play("Laser0", false)
        
        local beam = d.beam
        if not beam then
            d.beam = Beam(bsprite, "laser", false, false)
            beam = d.beam
        end 

        d.beam:GetSprite():Update()
        --endpoint:GetSprite():Update()
    end    
end

function mod:TechGrudgeLaser(npc, sprite, d)

    local room = game:GetRoom()


    if d.beam then

    local origin = Isaac.WorldToScreen(npc.Position) + Vector(0, -23)
    local target = mod:Lerp(d.oldtarget, Isaac.WorldToScreen(room:GetClampedPosition(npc.Position + Vector(0, 140):Rotated(-90*d.direction), 15)), 0.1)
    local tarilend = mod:Lerp(d.oldtrailend, room:GetClampedPosition(npc.Position + Vector(0, 140):Rotated(-90*d.direction), 15), 0.1)
    d.oldtarget = target
    d.oldtrailend = tarilend

    d.beam:Add(origin,0)
    d.beam:Add(target,64)

    local beamend
    for k, v in ipairs(d.beam:GetPoints()) do
        if k == #d.beam:GetPoints() then
            beamend = v:GetPosition()
        end
    end

    --[[if not d.endpoint or (d.endpoint:IsDead() and not d.endpoint:Exists()) then
        d.endpoint = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LASER_IMPACT, 0, beamend, Vector.Zero, npc)
    else
        d.endpoint:GetSprite():Update()
    end]]

    d.beam:Render()

    local capsule = Capsule(npc.Position,tarilend, 5)

    for _, player in ipairs(Isaac.FindInCapsule(capsule, EntityPartition.PLAYER)) do
        player:TakeDamage(1, 0, EntityRef(player), 0)

    end

    end
end
