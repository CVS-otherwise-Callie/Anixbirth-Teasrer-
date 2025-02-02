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
                and ent.Type == mod:ENT(extraanim .. "Tainted String").ID and ent.Variant == mod:ENT(extraanim .. "Tainted String").Var
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
        d.newpos = sillyStringFindFreeGrid()
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if not d.babyIsDead then

        if not d.isRecieving then

            if d.state == "idle" then
                babydata.state = "leave"
                mod:spritePlay(sprite, extraanim .. "Idle")
                if npc.StateFrame > 30 then
                    if d.isPickingUpChild then
                        d.state = "leavesecond"
                    end
                end
                if npc.StateFrame > 50 and not d.andSymbol then
                    d.state = "shoot"
                elseif npc.StateFrame > 120 then
                    d.state = "leave"
                    d.baby:GetData().state = "leave"
                end
            elseif d.state == "shoot" then
                d.andSymbol = Isaac.Spawn(mod.Monsters.andEntity.ID, mod.Monsters.andEntity.Var, -1, npc.Position + Vector(0, 10), Vector.Zero, npc)
                d.andSymbol.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                d.andSymbol.Parent = npc
                local dat = d.andSymbol:GetData()
                dat.baby = d.baby
                d.baby:GetData().andSymbol = d.andSymbol
                d.state = "idle"
            elseif d.state == "leave" then
                mod:spritePlay(sprite, "Leave")
                d.newpos = sillyStringFindFreeGrid()
            elseif d.state == "hiding" then
                mod:MakeInvulnerable(npc)
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos - npc.Position, 0.5)
                npc.Visible = false
            elseif d.state == "appear" then
                mod:MakeVulnerable(npc)
                mod:spritePlay(sprite, "Appear")
                npc.Visible = true
            elseif d.state == "babyPickup" then
                npc.Velocity = mod:Lerp(npc.Velocity, d.andSymbol.Position - npc.Position, 0.5)
                if npc.Position:Distance(d.andSymbol.Position) < 10 then
                    d.state = "appear"
                end                
            elseif d.state == "leavesecond" then
                mod:spritePlay(sprite, "Leave")
                d.newpos = sillyStringFindFreeGrid()
            elseif d.state == "hidemove" then
                mod:MakeInvulnerable(npc)
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos - npc.Position, 0.5)
                npc.Visible = false
                if npc.Position:Distance(d.newpos) < 10 then
                    d.state = "appear"
                    d.isPickingUpChild = false
                end
            elseif d.state == "waitforintroooutroednthendepressed" then
                npc.Visible = true
                if sprite:IsFinished(extraanim .. "Appear") then
                    sprite:Play(extraanim .. "Init")
                    d.babyIsDead = true
                else
                    sprite:Play(extraanim .. "Init")
                end
            end
    
            if sprite:IsFinished(extraanim .. "Leave") and d.state == "leave" then
                d.state = "hiding"
            elseif sprite:IsFinished(extraanim .. "Leave") and d.state == "leavesecond" then
                d.state = "hidemove"
            elseif sprite:IsFinished(extraanim .. "Appear") or sprite:IsFinished(extraanim .. "DepressedInit") then
                if d.andSymbol and d.andSymbol:Exists() and not d.andSymbol:IsDead() then
                    d.andSymbol:GetData().state = "dissapear"
                    d.andSymbol = nil
                end
                npc.StateFrame = 0
                d.state = "idle"
            end

        else

            if d.state == "idle" then
                mod:spritePlay(sprite, extraanim .. "Idle")
                if npc.StateFrame > 50 then
                    d.state = "leave"
                end
            elseif d.state == "leave" then
                mod:spritePlay(sprite, "Leave")
                d.newpos = sillyStringFindFreeGrid()
            elseif d.state == "hiding" then
                mod:MakeInvulnerable(npc)
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos - npc.Position, 0.5)
                npc.Visible = false
            elseif d.state == "appear" then
                mod:MakeVulnerable(npc)
                mod:spritePlay(sprite, "Appear")
                npc.Visible = true
            elseif d.state == "babyPickup" then
                npc.Velocity = mod:Lerp(npc.Velocity, d.andSymbol.Position - npc.Position, 0.5)
                if npc.Position:Distance(d.andSymbol.Position) < 10 then
                    d.state = "appear"
                end
            elseif d.state == "waitforintroooutroednthendepressed" then
                if sprite:IsFinished(extraanim .. "Appear") then
                    sprite:Play(extraanim .. "Init")
                    d.babyIsDead = true
                elseif sprite:IsPlaying(extraanim .. "Leave") then
                    sprite:Play(extraanim .. "Appear")
                end
            end
    
            if sprite:IsFinished(extraanim .. "Leave") and d.state == "leave" then
                d.state = "hiding"
            elseif sprite:IsFinished(extraanim .. "Appear") or sprite:IsFinished(extraanim .. "DepressedInit") then
                if d.andSymbol and d.andSymbol:Exists() and not d.andSymbol:IsDead() then
                    d.andSymbol:GetData().state = "dissapear"
                    d.andSymbol = nil
                end
                npc.StateFrame = 0
                d.state = "leavesecond"
                d.baby:GetData().isRecieving = true
                d.isRecieving = false
            end

            if d.andSymbol:IsDead() then
                npc.Position = d.andSymbol.Position
                mod:spritePlay(sprite, "Appear")
            end

        end

    else

        if d.state == "depressedidle" then
        elseif d.state == "depressedappear" then
            mod:MakeVulnerable(npc)
            mod:spritePlay(sprite, extraanim .. "Appear")
            npc.Visible = true
        elseif d.state == "depressedleave" then
        end

        if sprite:IsPlaying(extraanim .. "Leave") or d.state == "babyPickup" then
            d.state = "depressedappear"
        end

    end

    if d.targisPlayer then
        findSillyStringBaby()
    end

    if d.baby:IsDead() then
        d.babyIsDead = true
        d.baby = npc:GetPlayerTarget()

    end

    npc:MultiplyFriction(0.1)
end

function mod:andSymbolAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not npc.Parent or (npc.Parent and (not npc.Parent:Exists() or npc.Parent:IsDead())) then
        if d.baby and d.baby.Type ~= 1 then
            npc.Parent = d.baby
        end
    end

    local function andSymbolFindGrid()
        local pos
        if math.random(3) == 3 then
            pos = targetpos
        else
            pos = mod:freeGrid(npc, true, 1000000, 100)
        end

        if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            pos.X = npc.Position.X
        else
            pos.Y = npc.Position.Y
        end

        return pos
    end

    if not d.init then
        d.newpos = andSymbolFindGrid()
        sprite:SetFrame(0)
        d.state = "appear"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "appear" then
        
        mod:spritePlay(sprite, "Appear")

    elseif d.state == "walk" then

        if npc.Position:Distance(d.newpos) < 5 then
            d.newpos = andSymbolFindGrid()
        elseif (sprite:GetFrame() > 2 and sprite:GetFrame() < 25) or (sprite:GetFrame() > 27 and sprite:GetFrame() < 48) then

            if mod:isScare(npc) then
                local targetvelocity = (d.newpos - npc.Position):Resized(-6)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            elseif path:HasPathToPos(d.newpos) then
                local targetvelocity = (d.newpos - npc.Position):Resized(6)
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
            sprite:SetFrame( "WalkVert", 0)
        end
            
        sprite:Update()

        if npc.StateFrame > 200 and sprite:GetFrame() > 48 then
            d.state = "pickup"
        end

    elseif d.state == "pickup" then

        if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
            local dat = d.baby:GetData()
            dat.newpos = npc.Position
            dat.state = "babyPickup"
            dat.isPickingUpChild = true
            d.state = nil
        elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
            local dat = npc.Parent:GetData()
            dat.newpos = npc.Position
            dat.state = "babyPickup"
            dat.isPickingUpChild = true
            d.state = nil
        else
            d.state = "dissapear"
        end

    elseif d.state == "dissapear" then

        mod:spritePlay(sprite, "Dissapear")

    elseif not d.state then

        sprite:SetFrame("WalkVert", 0)

        if npc.Parent:IsDead() or npc.Parent:GetData().babyIsDead then
            d.state = "pickup"
        end
    end

    if sprite:IsFinished( "Appear") then
        d.state = "walk"
    elseif sprite:IsFinished("Dissapear") then
        npc:Remove()
    end

    local projtype = 0

    if sprite:IsEventTriggered("shoot") then
        for i = 1, 3 do
            local realshot = Isaac.Spawn(9, projtype, 0, npc.Position, npc.Velocity:Rotated(-30+ (15*i)):Resized(10), npc):ToProjectile()
            realshot.FallingAccel = 0.3
            realshot.Height = -30
            realshot:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
        end
    end

    if d.newpos.X < npc.Position.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    if d.state ~= "walk" then
        npc:MultiplyFriction(0.3)
    end

end