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

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.andEntity.Var then
        mod:andSymbolRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.andEntity.ID)

function mod:TaintedSillyStringAI(npc, sprite, d)
    local extraanim = ""
    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

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
        local pos = mod:freeGrid(npc, true, 1000000, 100)
        if d.baby and not d.baby:IsDead() and d.andSymbol then
            pos = mod:freeGrid(d.baby, true, 1000, 100)
        end
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
                d.newpos = sillyStringFindFreeGrid()
                npc.Position = d.newpos
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
                d.newpos = sillyStringFindFreeGrid()
                npc.Position = d.newpos
                npc.Visible = false
                if npc.Position:Distance(d.newpos) < 20 then
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
            elseif d.state == "pickuptime" then
                npc.Position = d.newpos
                d.state = "appear"
            elseif d.state == "youcanleavenow" then
                d.state = "leavesecond"
                d.baby:GetData().isRecieving = true
                d.isRecieving = false
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

            d.baby:GetData().isRecieving = true

        else

            if d.state == "idle" then
                mod:spritePlay(sprite, extraanim .. "Idle")
                if npc.StateFrame > 50 and not d.isPickingUpChild then
                    d.state = "leave"
                end
                if d.andSymbol and d.andSymbol:Exists() and not d.andSymbol:IsDead() and d.andSymbol.Position:Distance(npc.Position) < 5 then
                    d.andSymbol:GetData().state = "dissapear"
                    d.andSymbol = nil
                    d.state = nil
                end
            elseif d.state == "leave" then
                mod:spritePlay(sprite, "Leave")
                d.newpos = sillyStringFindFreeGrid()
            elseif d.state == "hiding" then
                mod:MakeInvulnerable(npc)
                npc.Position = d.newpos
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
            elseif d.state == "pickuptime" then
                npc.Position = d.newpos
                d.state = "appear"
            elseif d.state == "youcanleavenow" then
                d.state = "leavesecond"
                d.baby:GetData().isRecieving = true
                d.isRecieving = false
            end
    
            if sprite:IsFinished(extraanim .. "Leave") and d.state == "leave" then
                d.state = "hiding"
            elseif sprite:IsFinished(extraanim .. "Appear") or sprite:IsFinished(extraanim .. "DepressedInit") then
                d.state = "idle"
                npc.StateFrame = 0
            end

            if d.andSymbol and d.andSymbol:IsDead() then
                npc.Position = d.andSymbol.Position
                mod:spritePlay(sprite, "Appear")
            end

        end

        d.sadInit = false

    else

        if not d.sadInit then
            npc:AddHealth(npc.MaxHitPoints)
            d.sadInit = true
        end

        if d.state == "idle" then
            mod:spritePlay(sprite, extraanim .. "Idle")

            if not d.andSymbol or d.andSymbol:IsDead() then
                d.andSymbol = Isaac.Spawn(mod.Monsters.andEntity.ID, mod.Monsters.andEntity.Var, -1, npc.Position + Vector(0, 10), Vector.Zero, npc)
                d.andSymbol.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                d.andSymbol.Parent = npc
                d.andSymbol:GetData().isAggressive = true
                local dat = d.andSymbol:GetData()
                dat.baby = d.baby
                d.baby:GetData().andSymbol = d.andSymbol
                d.state = "idle"
            end

            if npc.FrameCount % 5 == 0 then
                d.rngshoot = math.random(100)
                for i = 0, 3 do
                    d.typeofShooting = "player"
                    local proj = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position + Vector(math.random(30, 120), 0):Rotated((60*i+d.rngshoot)), Vector(1, 0):Rotated((60*i+d.rngshoot)), npc):ToProjectile()
                    proj.Height = -5
                    proj.FallingSpeed = -20
                    proj.FallingAccel = 1
                    proj:Update()
                    d.rngshoot = d.rngshoot + 30
                end
            end

        elseif d.state == "appear" then
            mod:MakeVulnerable(npc)
            mod:spritePlay(sprite, extraanim .. "Appear")
            npc.Visible = true
        elseif d.state == "leave" then
            mod:spritePlay(sprite, extraanim .. "Leave")
        elseif d.state== "hiding" then
            d.state = "appear"
        end

        if sprite:IsPlaying(extraanim .. "Leave") or d.state == "babyPickup" then
            d.state = "appear"
        elseif sprite:IsFinished(extraanim .. "Appear") then
            d.state = "idle"
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

    if npc.Parent or (d.baby and (not d.baby:IsDead() and d.baby.Type ~= 1)) then
        npc:AddHealth(npc.MaxHitPoints)
    end

    if not npc.Parent or (npc.Parent and (not npc.Parent:Exists() or npc.Parent:IsDead())) then
        if d.baby and d.baby.Type ~= 1 then
            npc.Parent = d.baby
        end
    end

    local function andSymbolFindGrid()
        local pos
        if d.isAggressive or math.random(3) == 3 then
            pos = targetpos
        else
            pos = mod:freeGrid(npc, true, 200, 100)
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

    local num = 5
    if d.isAggressive then
        num = 8
    end

    if d.isAggressive and (not npc.Parent or npc.Parent:IsDead()) then
        d.isAggressive = false
    end

    if d.state == "appear" then
        
        mod:spritePlay(sprite, "Appear")

    elseif d.state == "walk" then

        if not d.walkinit then
            if mod:isScare(npc) then
                local targetvelocity = (d.newpos - npc.Position):Resized(-1 * num)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            elseif path:HasPathToPos(d.newpos) then
                local targetvelocity = (d.newpos - npc.Position):Resized(num)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            else
                path:FindGridPath(d.newpos, 0.7, 1, true)
            end

            d.walkinit = true
        end

        npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, Vector(0, 0), 0.01)

        if (npc.Position:Distance(d.newpos) < 10 or game:GetRoom():CheckLine(d.newpos,npc.Position,3,900,false,false) == false) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0) then
            if d.gettingPickedUp then
                if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
                    d.newpos = d.baby.Position
                elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
                    d.newpos = npc.Parent.Position
                elseif not d.isAggressive then
                    d.state = "dissapear"
                end
            else
                d.newpos = andSymbolFindGrid()
            end
        elseif (sprite:GetFrame() < 2 or (sprite:GetFrame() > 25 and sprite:GetFrame() < 27) or sprite:GetFrame() > 48) then
            local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
            creep.Scale = creep.Scale * 1.15
            creep:SetTimeout(creep.Timeout - 20)
            creep:Update() 
        else

            if mod:isScare(npc) then
                local targetvelocity = (d.newpos - npc.Position):Resized(-1 * num)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            elseif path:HasPathToPos(d.newpos) then
                local targetvelocity = (d.newpos - npc.Position):Resized(num)
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

    elseif d.state == "pickup" then

        if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
            local dat = d.baby:GetData()
            dat.newpos = npc.Position
            --dat.state = "babyPickup"
            dat.isPickingUpChild = true
            d.state = nil
        elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
            local dat = npc.Parent:GetData()
            dat.newpos = npc.Position
            --dat.state = "babyPickup"
            dat.isPickingUpChild = true
            d.state = nil
        elseif not d.isAggressive then
            d.state = "dissapear"
        end

    elseif d.state == "dissapear" then

        sprite:Play("Disappear")
        mod:spritePlay(sprite, "Disappear")
        sprite:Update()

    elseif not d.state then

        if npc.Parent:IsDead() or npc.Parent:GetData().babyIsDead then
            d.state = "pickup"
        end

        if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
            d.newpos = d.baby.Position
        elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
            d.newpos = npc.Parent.Position
        elseif not d.isAggressive then
            d.state = "dissapear"
        end

        if mod:isScare(npc) then
            local targetvelocity = (d.newpos - npc.Position):Resized(-1 * num)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        elseif path:HasPathToPos(d.newpos) then
            local targetvelocity = (d.newpos - npc.Position):Resized(num)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        else
            path:FindGridPath(d.newpos, 0.7, 1, true)
        end
    end
    
    if sprite:IsFinished( "Appear") then
        d.state = "walk"
    elseif sprite:IsFinished("Disappear") then
        local dat
        if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
            dat= d.baby:GetData()
            dat.state = "youcanleavenow"
            --dat.state = "babyPickup"
        elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
            dat = npc.Parent:GetData()
            dat.state = "youcanleavenow"
            --dat.state = "babyPickup"
        end
        npc:Remove()
    end

    local projtype = 0

    if sprite:IsEventTriggered("shoot") and not d.isAggressive then
        for i = 1, 3 do
            local realshot = Isaac.Spawn(9, projtype, 0, npc.Position, Vector(5, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() -40+ (20*i)):Resized(10), npc):ToProjectile()
            realshot.FallingAccel = 0.3
            realshot:GetData().type = "andSymbol"
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

    if npc.StateFrame > 150 and not d.gettingPickedUp then
        local dat = nil

        if d.baby and not d.baby:IsDead() and d.baby.Type ~= 1 and not npc.Parent:GetData().babyIsDead then
            dat= d.baby:GetData()
            d.newpos = d.baby.Position
            --dat.state = "babyPickup"
        elseif npc.Parent and not npc.Parent:IsDead() and not npc.Parent:GetData().babyIsDead then
            dat = npc.Parent:GetData()
            d.newpos = npc.Parent.Position
            --dat.state = "babyPickup"
        elseif not d.isAggressive then
            d.state = "dissapear"
        end

        if dat then
            dat.state = "pickuptime"
            dat= d.baby:GetData()
            dat.newpos = mod:freeGrid(npc, true, 500, 200)
            --dat.state = "babyPickup"
            dat.isPickingUpChild = true
            d.gettingPickedUp = true
        end
        
    end

end

function mod:andSymbolRenderAI(npc, sprite, d)
    local function andEntityAppear()
        d.var1 = d.var1 or 1
        d.xvel = d.xvel or 20
        d.yvel = d.yvel or 0
        d.var1 = d.var1 + 0.1
        if npc.FrameCount % 18 == 0 then
            local random = math.random(1)

            if random == 1 then
                d.xvel = math.random(-20, -10)
            else
                d.xvel = math.random(10, 20)
            end
            random = math.random(1)
            if random == 1 then
                d.yvel = math.random(-20, -10)
            else
                d.yvel = math.random(10, 20)
            end
        end
        npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, (npc.SpriteOffset - Vector(npc.SpriteOffset.X + (math.cos(d.var1)*5), npc.SpriteOffset.Y + (math.cos(d.var1+90)*5))), 1)
        npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, (npc.SpriteOffset - Vector(d.xvel, d.yvel)), 0.5)
        d.xvel = d.xvel + ((d.xvel + (0 - npc.SpriteOffset.X))-((d.xvel + (0 - npc.SpriteOffset.X))*2))*0.2
        d.yvel = d.yvel + ((d.yvel + (0 - npc.SpriteOffset.Y))-((d.yvel + (0 - npc.SpriteOffset.Y))*2))*0.2
    end
    if sprite:IsPlaying("Appear") or sprite:IsPlaying("Dissapear") then
        andEntityAppear()
    end
end

function mod.andShot(p, d)
    if d.type == "andSymbol" and p:IsDead() then
        local creep = Isaac.Spawn(1000, 22,  0, game:GetRoom():GetClampedPosition(p.Position, 15), Vector(0, 0), p):ToEffect()
        creep.Scale = creep.Scale * 0.5
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.andEntity.Var then
        return false
    end
end, mod.Monsters.andEntity.ID )
