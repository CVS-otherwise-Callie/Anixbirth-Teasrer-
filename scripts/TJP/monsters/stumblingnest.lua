local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.StumblingNest.Var then
        mod:StumblingNestAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.StumblingNest.ID)

function mod:StumblingNestAI(npc, sprite, d)

    --just tech grudge movement ai

    local function StumblingNestEntAI(pos)

        local room = game:GetRoom()

        local tab = {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKB, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_BOMB, GridEntityType.GRID_ROCK_ALT, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT, GridEntityType.GRID_FIREPLACE,
        GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS, GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2,
        GridEntityType.GRID_ROCK_GOLD, GridEntityType.GRID_POOP, GridEntityType.GRID_PIT, GridEntityType.GRID_SPIKES}

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
        d.state = "idle"
        if npc.SubType >=1 and npc.SubType <= 4 then
            d.direction = npc.SubType
        else
            d.direction = math.random(1, 4)
        end
        d.oldtarget = Isaac.WorldToScreen(npc.Position)
        d.oldtrailend = npc.Position
        d.grid = StumblingNestEntAI(d.direction)
        d.dist = 50
        d.frame = 0
        d.webletcooldown = math.random(50,75)
        --npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        d.frame = d.frame + 1
        d.webletcooldown = d.webletcooldown - 1
    end

    d.grid = StumblingNestEntAI(d.direction)
    local grid = d.grid

    if d.state == "idle" then

        npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 5):Rotated(-90*d.direction), 0.1)

        --this last part
        if not mod:GetClosestGridEntToPos(npc.Position, true, true) then return end


        if d.direction == 1 or d.direction == 3 then
            if grid and grid.Position:Distance(npc.Position) < d.dist then

                if npc.SubType >= 10 then
                    if d.direction >= 4 then
                        d.direction = 1
                    elseif d.direction == 3 then
                        d.direction = d.direction - 1
                    else
                        d.direction = 4
                    end
                else
                    if d.direction >= 4 then
                        d.direction = 1
                    else
                        d.direction = d.direction + 1
                    end
                end
                --npc:MultiplyFriction(0.8)
                d.grid = StumblingNestEntAI(d.direction)
            end
        else
            if grid and grid.Position:Distance(npc.Position) < d.dist then
                npc.StateFrame = 11

                if npc.SubType >= 10 then
                    if d.direction >= 4 then
                        d.direction = 1
                    else
                        d.direction = d.direction - 1
                    end    
                else
                    if d.direction >= 4 then
                        d.direction = 1
                    else
                        d.direction = d.direction + 1
                    end
                end
                --npc:MultiplyFriction(0.8)
                d.grid = StumblingNestEntAI(d.direction)
            end
        end

        d.targetvelocity = npc.Velocity:Resized(2)
        npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.1)
        mod:spritePlay(sprite, "Walk"..mod:GetMoveString(npc.Velocity, false, false))
        if d.webletcooldown <= 0 then
            d.weblet = Isaac.Spawn(mod.Monsters.Weblet.ID, mod.Monsters.Weblet.Var, mod.Monsters.Weblet.Sub, npc.Position, Vector.Zero, npc)
            d.weblet.Parent = npc
            d.webletsprite = d.weblet:GetSprite()
            d.webletsprite:Play("HeadAppear")
            d.weblet.EntityCollisionClass = 0
            d.weblet:GetData().shotvectormult = 6
            d.webletcooldown = math.random(100,200)
        end
    end

end

