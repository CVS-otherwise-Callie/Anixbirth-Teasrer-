local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedSilly.Var then
        mod:TaintedSillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedSilly.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedString.Var then
        mod:TaintedSillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedString.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.andEntity.Var then
        mod:andSymbolAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.andEntity.ID)

function mod:TaintedSillyStringAI(npc, sprite, d)
    local extraanim = ""

    --check block--
    if npc.Variant == mod.Monsters.TaintedSilly.Var then d.isSilly = true end
    if npc.Variant == mod.Monsters.TaintedString.Var then d.isString = true end
    if d.baby and d.baby.Type == 1 then d.targisPlayer = true end
    if d.baby and d.babyIsDead then extraanim = "Depressed_" end

    local function findSillyStringBaby()
        if d.baby and d.baby.Type ~= 1 then
            d.baby.Parent = npc
            d.isRecieving = false
            d.baby:GetData().Par = npc
            d.baby:GetData().shootinginit = true
            d.baby:GetData().targisPlayer = false
            d.shootinginit = false
            d.targisPlayer = false
            d.shootinginit = false
            return
        end
        if d.isSilly then
            local targets = {}
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                if not ent:IsDead()
                and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
                and ent.Type == mod:ENT("Tainted String").ID and ent.Variant == mod:ENT("Tainted String").Var
                and (ent.Parent == nil or ent:GetData().targisPlayer == true)  then
                    table.insert(targets, ent)
                end
            end
            if (#targets == 0) then
                d.baby = npc:GetPlayerTarget()
            else
                d.baby = targets[math.random(1, #targets)]
                d.baby.Parent = npc
                d.baby:GetData().Par = npc
                d.baby:GetData().shootinginit = true
                d.baby:GetData().targisPlayer = false
            end
        else
            d.baby = npc.Parent
        end
        if not d.baby then
            d.baby = npc:GetPlayerTarget()
        end 
    end

    local function sillyStringFindFreeGrid()
        local pos = mod:freeGrid(d.baby, true, 1000000, 100)
        if game:GetRoom():CheckLine(pos,d.baby.Position,3,900,false,false) then
            return pos
        else
            return sillyStringFindFreeGrid()
        end
    end

    --init--

    local babydata = {}
    if d.baby then
        babydata = d.baby:GetData()
    end

    if not d.init then
        d.isRecieving = false
        d.state = "idle"
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        findSillyStringBaby()
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        babydata.state = "hiding"
        mod:spritePlay(sprite, "Idle")
        if npc.StateFrame > 20 and not d.andSymbol then
            d.state = "shoot"
        elseif npc.StateFrame > 50 then
            d.state = "leave"
        end
    elseif d.state == "shoot" then
        d.andSymbol = Isaac.Spawn(mod.Monsters.andEntity.ID, mod.Monsters.andEntity.Var, -1, npc.Position + Vector(0, -3), Vector.Zero, npc)
        d.andSymbol.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        d.state = "idle"
    elseif d.state == "leave" then
        mod:spritePlay(sprite, "Leave")
    elseif d.state == "hiding" then
        mod:MakeInvulnerable(npc)
        npc.Visible = false
    elseif d.state == "appear" then
        mod:MakeVulnerable(npc)
        mod:spritePlay(sprite, "Appear")
        npc.Visible = true
    end

    if sprite:IsFinished("Leave") then
        d.state = "hiding"
    end

    npc:MultiplyFriction(0.1)
end

function mod:andSymbolAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local function andSymbolFindGrid()
        local pos = mod:GetNewPosAligned(npc.Position, false)
        if pos:Distance(npc.Position) > 100 and pos:Distance(npc.Position) > 100 then
            return pos
        else
            return andSymbolFindGrid()
        end
    end

    if not d.init then
        d.newpos = andSymbolFindGrid()
        d.init = true
    end

    
    --[[if d.newpos then

        if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
            d.newpos.X = npc.Position.X
        else
            d.newpos.Y = npc.Position.Y
        end

    end]]

    if npc.Position:Distance(d.newpos) < 5 then
        d.newpos = andSymbolFindGrid()
        npc.StateFrame = 0
    elseif (sprite:GetFrame() > 2 and sprite:GetFrame() < 25) or (sprite:GetFrame() > 27 and sprite:GetFrame() < 48) then
        if mod:isScare(npc) then
            local targetvelocity = (d.newpos - npc.Position):Resized(-3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        elseif path:HasPathToPos(d.newpos) then
            local targetvelocity = (d.newpos - npc.Position):Resized(3)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        else
            path:FindGridPath(d.newpos, 0.7, 1, true)
        end

        if npc.Velocity:Length() > 1 then
        
        mod:CatheryPathFinding(npc, d.newpos, {
            Speed = 1,
            Accel = 0.2,
            Interval = 1,
            GiveUp = true
        })
        end

    end

    if npc.Velocity:Length() > 0.5 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
    else
        sprite:SetFrame("WalkVert", 0)
    end
            
    sprite:Update()
end