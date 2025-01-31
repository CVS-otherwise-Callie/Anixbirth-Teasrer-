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

function mod:TaintedSillyStringAI(npc, sprite, d)
    local extraanim = ""

    --check block--
    if npc.Variant == mod.Monsters.TaintedSilly.Var then d.isSilly = true end
    if npc.Variant == mod.Monsters.TaintedString.Var then d.isString = true end
    if d.baby and d.baby.Type == 1 then d.targisPlayer = true end
    if d.baby and d.babyIsDead then extraanim = "Depressed_" end

    --local functions to silly and string --

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

    if not d.init then
        d.isRecieving = false
        d.state = "idle"
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.SpriteOffset = Vector(0, 20)
        findSillyStringBaby()
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    --states and stuff--

    if d.state == "idle" then
        sprite:Play(extraanim .. "Idle")
        mod:MakeVulnerable(npc)
        d.isRecieving = false
    elseif d.state == "recievestart" then
        sprite:Play("Recieve")
        d.isRecieving = true
        npc.StateFrame = 0
    elseif d.state == "recieved" then
        sprite:Play("RecieveIdle")
    elseif d.state == "hidingtime" then
        mod:MakeInvulnerable(npc)
        if sprite:IsFinished(extraanim .. "Leave") then
            npc.Velocity = mod:Lerp(npc.Velocity, d.newpos - npc.Position, 0.5)
            if npc.StateFrame > 50 then
                sprite:Play(extraanim .. "Appear")
                npc:PlaySound(SoundEffect.SOUND_SCAMPER,1,0,false,(math.random(1, 8))/10)
                npc.StateFrame = 0
            end
        end
    end

    --the real code--

    if not d.targisPlayer then
        d.baby:GetData().baby = npc  
        if d.isRecieving then
            extraanim = "Recive"
            if d.shottorecieve and d.shottorecieve.Position:Distance(npc.Position) < 10 then
                d.state = "recieving"
                sprite:Play("RecieveEnd")
                npc:PlaySound(SoundEffect.SOUND_VAMP_GULP,(math.random(2, 8))/10,0,false,(math.random(1, 8))/10)
                d.shottorecieve:Remove()
                d.shottorecieve = nil
                d.shot = nil
                d.baby:GetData().shot = nil
            end
            if sprite:IsFinished("RecieveEnd") then
                d.state = "recieved"
            end
            if npc.StateFrame >= 30 and not d.shot and d.state == "recieved" and d.baby:GetData().state ~= "hidingtime" then
                if d.baby.Type == 1 then d.baby = npc.Parent or npc:GetPlayerTarget() end
                d.shootinginit = true
                mod:spritePlay(sprite, "RecieveShoot")
                d.state = "shoot"
                npc.StateFrame = 0
            end
        else
            if npc.StateFrame >= 40 and not d.shot and not d.shootinginit then
                d.shootinginit = true
                mod:spritePlay(sprite, extraanim .. "Shoot")
                d.state = "shoot"
                npc.StateFrame = 0
            end
    
        end
        if sprite:IsEventTriggered("shoot") then
            d.isRecieving = false
            d.baby:GetData().state = "recievestart"
        end
    else
        if not d.babyIsDead then
            findSillyStringBaby()
        end
        if npc.StateFrame >= 60 then
            mod:spritePlay(sprite, extraanim .. "Shoot")
            d.state = "shoot"
            npc.StateFrame = 0
        end
    end

    --shooting--

    if sprite:IsEventTriggered("shoot") then
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-25 + npc.SpriteOffset.X)
        effect.DepthOffset = npc.Position.Y * 1.25
        effect:FollowParent(npc)
        npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,(math.random(4, 8))/10,0,false,1)
        d.shot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated((d.baby.Position - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        d.shot.Height = -40
        d.shot.Parent = npc
        if d.targisPlayer then
            d.shot:AddProjectileFlags(ProjectileFlags.WIGGLE)
            d.shot:GetData().type = "DeadSillyString"
        else
            d.shot:GetData().type = "SillyString"
            d.baby:GetData().shottorecieve = d.shot
            d.shot:GetData().Parent = npc
            d.shot:GetData().targ = d.baby
        end
        d.state = "isfinishedshooting"
    end

    --anims finished--

    if sprite:IsFinished(extraanim .. "Shoot") or sprite:IsFinished("RecieveShoot") then
        npc.StateFrame = 0
        d.newpos = sillyStringFindFreeGrid()
        d.state = "hidingtime"
        npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,(math.random(3, 8))/10,0,false,1)
        mod:spritePlay(sprite, extraanim .. "Leave")
    elseif sprite:IsFinished(extraanim .. "Appear") or sprite:IsFinished("DepressedInit") then
        d.state = "idle"
    end

    --check if its dead--

    if d.baby:IsDead() then
        d.baby = npc:GetPlayerTarget()
        extraanim = "Depressed_"
        if not d.targisPlayer then
            if not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Leave")) then
                sprite:Play(extraanim .. "Init")
            end
            d.state = "depressedinit"
            d.state = "idle"
            
            d.babyIsDead = true
        end
    end

    --actual movement--
    
    npc.Velocity = mod:Lerp(npc.Velocity, (d.baby.Position - npc.Position):Resized(40), 0.01)
    npc:MultiplyFriction(0.1)
end

-- extra --

function mod.SillyStringColl(npc, coll)
    if npc.Type == 161 and (npc.Variant == mod.Monsters.String.Var or npc.Variant == mod.Monsters.Silly.Var) then
        if coll.Type == 1 or (coll.Type == 2 and coll.Parent.Position:Distance(npc.Position) < 30) then
            return true
        end
    end
end

function mod.UpdateSillyStringProj(proj, coll, d)
    if proj.Parent and not proj.Parent:IsDead() then
    local pard = proj.Parent:GetData()
    if pard and d.type == "SillyString" and coll.Type == 1 then

        pard.state = "idle"
        pard.shot = nil
        pard.shootinginit = false

        if pard.baby then
            pard.baby:GetData().state = "idle"
            pard.baby:GetData().shot = nil
            pard.baby:GetData().shottorecieve = false
        end
    end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type == 161 and (npc.Variant == mod.Monsters.Silly.Var or npc.Variant == mod.Monsters.String.Var) and not npc:GetData().targisPlayer then
        if source.Type == 2 and mod:CheckForOnlyEntInRoom({
            mod:ENT("Silly"),
            mod:ENT("String")
        }) == false then
            --npc.HitPoints = npc.HitPoints + damage*0.01
            return {Damage = damage*0.01}
        else
            print( mod:CheckForOnlyEntInRoom({
                mod:ENT("Silly"),
                mod:ENT("String")
            }))
        end
    end
end)

function mod.SillyShot(p, d)
    if d.type == "SillyString" then
        if not d.shotinit then
            d.dist = p.Position:Distance(d.targ.Position)
            d.shotinit = true
        end
        if p.Height > -59 then p.Height = p.Height - 1 end
        p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    end
end