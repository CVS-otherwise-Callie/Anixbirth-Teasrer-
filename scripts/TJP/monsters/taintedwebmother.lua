local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedWebMother.Var then
        mod:TaintedWebMotherAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedWebMother.ID)

function mod:TaintedWebMotherAI(npc, sprite, d)
    local directions = {
                "Up",
                "Down",
                "Left",
                "Right"
            }

    if not d.init then
        npc.EntityCollisionClass = 0
        npc.GridCollisionClass = 0

        if not npc.Parent then
            d.direction = directions[math.random(4)]
            npc.Color = mod.Color.Invisible
            npc.Visible = false
            d.state = "hidden"

            local backlegs = Isaac.Spawn(mod.Monsters.TaintedWebMother.ID, mod.Monsters.TaintedWebMother.Var, mod.Monsters.TaintedWebMother.Sub, npc.Position, Vector.Zero, npc)
            backlegs.Parent = npc
            backlegs:GetData().legstatus = "Back"

            local middlelegs = Isaac.Spawn(mod.Monsters.TaintedWebMother.ID, mod.Monsters.TaintedWebMother.Var, mod.Monsters.TaintedWebMother.Sub, npc.Position, Vector.Zero, npc)
            middlelegs.Parent = npc
            middlelegs:GetData().legstatus = "Middle"
            npc.Child = middlelegs

            local frontlegs = Isaac.Spawn(mod.Monsters.TaintedWebMother.ID, mod.Monsters.TaintedWebMother.Var, mod.Monsters.TaintedWebMother.Sub, npc.Position, Vector.Zero, npc)
            frontlegs.Parent = npc
            frontlegs:GetData().legstatus = "Front"
        else
            d.state = "leg"
        end

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.Parent then
        d.parentdirection = npc.Parent:GetData().direction
    end

    if d.state == "hidden" then
        --print(npc.StateFrame)
        npc.Visible = false
        print(npc.Child:GetSprite():GetFrame())
        if npc.Child:GetSprite():GetFrame() >= 119 then
            d.reset = true
            if d.direction == "Up" or d.direction == "Down" then
                npc.Position = npc.Position + mod:ConvertWordDirectionToVector(d.direction):Resized(6)
            else
                npc.Position = npc.Position + mod:ConvertWordDirectionToVector(d.direction):Resized(9)
            end
            d.direction = directions[math.random(4)]
            npc.StateFrame = 0
        else
            d.reset = false
        end
    end

    if d.state == "leg" then

        if npc.Parent:GetData().reset then
            sprite:SetFrame(0)
            sprite:Update()
        end

        mod:spritePlay(sprite, d.legstatus.."Legs"..d.parentdirection)


        if d.legstatus == "Back" then
            npc.Position = npc.Parent.Position + Vector(0,-20)
        elseif d.legstatus == "Middle" then
            print(d.legstatus.."Legs"..d.parentdirection)
            print(npc.Parent:GetData().reset)
            print(sprite:GetFrame())
            npc.Position = npc.Parent.Position
        else
            npc.Position = npc.Parent.Position + Vector(0,20)
        end
    end

end

--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
--    if npc.Type == mod.Monsters.TaintedWebMother.ID and npc.Variant == mod.Monsters.TaintedWebMother.Var and npc.HitPoints - dmg <= 0 then
--        npc:GetData().state = "dead"
--        return false
--    end
--end, 161)