local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TechGrudge.ID)

if REPENTOGON then
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeLaser(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TechGrudge.ID)
end

function mod:TechGrudgeAI(npc, sprite, d)

    local function TechGrudgeEnt(pos)

        local room = game:GetRoom()

        local tab = {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_BOMB, GridEntityType.GRID_ROCK_ALT, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT, GridEntityType.GRID_FIREPLACE,
        GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS, GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2,
        GridEntityType.GRID_ROCK_GOLD}

        --local tab = {GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR}
        --1 is right, 2 is up, 3 is left, 4 is down
        if pos == 2 or pos == 4 then
            return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, d.direction*-90, tab, nil, room)
        end

        if pos == 1 or pos == 3 then
            return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, d.direction*-90, tab, nil, room)        
        end

    end

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
        d.dist = 60
        d.frame = 0
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        d.frame = d.frame + 1
    end

    d.grid = TechGrudgeEnt(d.direction)
    local grid = d.grid

    if d.state == "above" then

        npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 8.5):Rotated(-90*d.direction), 0.35)

        --this last part
        if not mod:GetClosestGridEntToPos(npc.Position, true, true) then return end


        if d.direction == 1 or d.direction == 3 then
            if d.direction == 3 then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end
            if grid and grid.Position:Distance(npc.Position) < d.dist then
                npc:MultiplyFriction(0.8)
                if d.direction >= 4 then
                    d.direction = 1
                else
                    d.direction = d.direction + 1
                end
                d.grid = TechGrudgeEnt(d.direction)
            end
            if grid and grid.Position:Distance(npc.Position) < d.dist*2 then
                if d.direction == 1 then
                    mod:spritePlay(sprite, "FlyNorthFlySide")
                elseif d.direction == 4 then
                    mod:spritePlay(sprite, "FlySouthFlySide")
                end
                npc.StateFrame = 0
            else
                mod:spritePlay(sprite, "FlySide")
            end
        else
            if grid and grid.Position:Distance(npc.Position) < d.dist then
                npc.StateFrame = 11
                npc:MultiplyFriction(0.8)
                if d.direction >= 4 then
                    d.direction = 1
                else
                    d.direction = d.direction + 1
                end
                d.grid = TechGrudgeEnt(d.direction)
            end
            if grid and grid.Position:Distance(npc.Position) < d.dist*2 then
                if d.direction == 2 then
                    mod:spritePlay(sprite, "FlyNorthFlySide")
                    sprite.FlipX = true
                elseif d.direction == 4 then
                    mod:spritePlay(sprite, "FlySouthFlySide")
                    sprite.FlipX = false
                end
                npc.StateFrame = 0
            else
                if d.direction == 2 then
                    mod:spritePlay(sprite, "FlyNorth")
                else
                    mod:spritePlay(sprite, "FlySouth")
                end
            end
        end

        if d.frame > 10 and REPENTOGON then

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
        --npc.GridCollisionClass = 5

        end
    end
end

function mod:TechGrudgeLaser(npc, sprite, d)

    local room = game:GetRoom()


    if d.beam and REPENTOGON then

        local origin
        if d.direction ~= 4 then
            origin = Isaac.WorldToScreen(npc.Position) + Vector(0, -23)
        else
            origin = Isaac.WorldToScreen(npc.Position) + Vector(0, -14)
        end
        local target
        local tarilend

        if game:GetRoom():CheckLine(npc.Position,npc.Position + Vector(0, 140):Rotated(-90*d.direction),3,900,false,false) then
            target = mod:Lerp(d.oldtarget, Isaac.WorldToScreen(room:GetClampedPosition(npc.Position + Vector(0, 140):Rotated(-90*d.direction), 15)), 0.1)
            tarilend = mod:Lerp(d.oldtrailend, room:GetClampedPosition(npc.Position + Vector(0, 140):Rotated(-90*d.direction), 15), 0.1)
            if d.endpoint then d.endpoint:GetSprite().Rotation = 0 end
        else
            target = mod:Lerp(d.oldtarget, Isaac.WorldToScreen(room:GetClampedPosition(d.grid.Position, 15)), 0.1)
            tarilend = mod:Lerp(d.oldtrailend, room:GetClampedPosition(d.grid.Position, 15), 0.1)
            if d.endpoint then d.endpoint:GetSprite().Rotation = d.direction*-90 end
        end

        if not d.beaminit then
            target = Isaac.WorldToScreen(npc.Position)
            tarilend = npc.Position
            d.beaminit = true
        end

        d.oldtarget = target
        d.oldtrailend = tarilend

        d.beam:Add(origin,0)
        d.beam:Add(Isaac.WorldToScreen(tarilend),64)

        if d.endpoint == nil or (d.endpoint:IsDead() and not d.endpoint:Exists()) == true then
            d.endpoint = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LASER_IMPACT, 0, tarilend, Vector.Zero, npc):ToEffect()
            d.endpoint.Parent = npc
        else
            d.endpoint.Position = tarilend
        end

        d.beam:Render()

        local capsule = Capsule(npc.Position,tarilend, 5)

        for _, player in ipairs(Isaac.FindInCapsule(capsule, EntityPartition.PLAYER)) do
            player:TakeDamage(1, 0, EntityRef(player), 0)
        end

    end
end
