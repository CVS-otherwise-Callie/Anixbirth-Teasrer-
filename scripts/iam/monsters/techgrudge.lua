local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TechGrudge.ID)

function mod:TechGrudgeAI(npc, sprite, d)

    local techgrudgedirtabs = {
        "South",
        "East",
        "North",
        "West"
    }
    local function TechGrudgeEnt(pos)
        --1 is right, 2 is up, 3 is left, 4 is down
        if pos == 2 or pos == 4 then
           return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "Y", true, true, d.direction*-90)
        end

        if pos == 1 or pos == 3 then
            return mod:GetClosestGridEntAlongAxisDirection(npc.Position, "X", true, true, d.direction*-90)
        end

    end
    local function TechGrudgeSwitchDirs(dir)
        if dir == 1 then
            return 3
        end
        if dir == 2 then
            return 4
        end
        if dir == 3 then
            return 1
        end
        if dir == 4 then
            return 2
        end
    end
    local room = game:GetRoom()
    mod:spritePlay(sprite, "FlySouth")

    if not d.init then
        d.state = "above"
        if npc.SubType >=1 and npc.SubType <= 4 then
            d.direction = npc.SubType
        else
            d.direction = math.random(1, 4)
        end
        d.spaceaway = 30
        d.newpos = npc.Position
        d.init = true
    end

    if d.state == "above" then

        npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, 10):Rotated(-90*d.direction), 0.1)

        if d.spaceaway <= 0 then d.spaceaway = 40 else d.spaceaway = d.spaceaway - 1 end

        --this last part
        if not mod:GetClosestGridEntToPos(npc.Position, true, true) then return end

        if d.direction == 1 or d.direction == 3 then
            local grid = TechGrudgeEnt(d.direction)
            if grid and grid.Position:Distance(npc.Position) < 100 then
                npc:MultiplyFriction(0.9)
                    if d.direction >= 4 then
                        d.direction = 1
                    else
                        d.direction = d.direction + 1
                    end
            end
        else
            local grid = TechGrudgeEnt(d.direction)
            if grid and grid.Position:Distance(npc.Position) < 100 then
                npc:MultiplyFriction(0.9)
                    if d.direction >= 4 then
                        d.direction = 1
                    else
                        d.direction = d.direction + 1
                    end
            end
        end
    end
end

