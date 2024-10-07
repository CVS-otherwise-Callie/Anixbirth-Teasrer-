local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Silly.Var then
        mod:SillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Silly.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.String.Var then
        mod:SillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.String.ID)

function mod:SillyStringAI(npc, sprite, d)
    if npc.Variant == mod.Monsters.Silly.Var then d.isSilly = true end
    if npc.Variant == mod.Monsters.String.Var then d.isString = true end

    local projparams = ProjectileParams()
    local extraanim = ""

    if not d.init then
        d.isRecieving = false
        d.state = "idle"
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.SpriteOffset = Vector(0, 10)
        if d.isSilly then
            local targets = {}
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                if not ent:IsDead()
                and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
                and ent.Type == mod:ENT("String").ID and ent.Variant == mod:ENT("String").Var and ent.SubType == mod:ENT("String").Sub
                and ent.Parent == nil  then
                    table.insert(targets, ent)
                end
            end
            if (#targets == 0) then
                d.baby = npc:GetPlayerTarget()
                d.targisPlayer = true
            else
                d.baby = targets[math.random(1, #targets)]
            end
            d.baby.Parent = npc
            d.baby:GetData().Par = npc
            d.baby:GetData().shootinginit = true
            d.baby:GetData().targisPlayer = false
        else
            d.baby = npc.Parent
        end
        if not d.baby then
            d.baby = npc:GetPlayerTarget()
            d.targisPlayer = true
        end    
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.baby:IsDead() then
        d.baby = npc:GetPlayerTarget()
        d.state = "idle"
        d.targisPlayer = true
    end

    if d.state == "idle" then
        sprite:Play("Idle")
    elseif d.state == "recievestart" then
        sprite:Play("Recieve")
        d.isRecieving = true
        npc.StateFrame = 0
    elseif d.state == "recieved" then
        sprite:Play("RecieveIdle")
    end

    npc.Velocity = mod:Lerp(npc.Velocity, (d.baby.Position - npc.Position):Resized(40), 0.01)

    if not d.targisPlayer then
            
        if d.isRecieving then
            extraanim = "Recive"
            if d.shottorecieve and d.shottorecieve.Position:Distance(npc.Position) < 10 then
                d.state = "recieving"
                sprite:Play("RecieveEnd")
                d.shottorecieve:Remove()
                d.shottorecieve = nil
                d.shot = nil
                d.baby:GetData().shot = nil
            end

            if sprite:IsFinished("RecieveEnd") then
                d.state = "recieved"
            end

            if npc.StateFrame >= 30 and not d.shot and d.state == "recieved" then
                if d.baby.Type == 1 then d.baby = npc.Parent or npc:GetPlayerTarget() end
                d.shootinginit = true
                mod:spritePlay(sprite, "RecieveShoot")
                d.state = "shoot"
                npc.StateFrame = 0
            end
        else
            if npc.StateFrame >= 40 and not d.shot and not d.shootinginit then
                d.shootinginit = true
                mod:spritePlay(sprite, "Shoot")
                d.state = "shoot"
                npc.StateFrame = 0
            end
    
        end

        if sprite:IsEventTriggered("shoot") then
            d.isRecieving = false
            d.baby:GetData().state = "recievestart"
        end

    else

        if npc.StateFrame >= 60 then
            mod:spritePlay(sprite, "Shoot")
            d.state = "shoot"
            npc.StateFrame = 0
        end
    end

    if sprite:IsEventTriggered("shoot") then
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-25 + npc.SpriteOffset.X)
        effect.DepthOffset = npc.Position.Y * 1.25
        effect:FollowParent(npc)
        d.shot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated((d.baby.Position - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        d.shot.SpriteOffset = Vector(0,-25 + npc.SpriteOffset.X)
        d.shot:GetData().type = "SillyString"
        d.baby:GetData().shottorecieve = d.shot
        d.shot:GetData().Parent = npc
        d.shot.Height = -10
        if d.targisPlayer then
            d.shot:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE | ProjectileFlags.ACCELERATE)
        end
        d.state = "isfinishedshooting"
    end

    if sprite:IsFinished("Shoot") or sprite:IsFinished("RecieveShoot")  then
        d.state = "idle"
    end

    npc:MultiplyFriction(0.1)
end

function mod.SillyStringColl(npc, coll)
    if npc.Type == 161 and (npc.Variant == mod.Monsters.String.Var or npc.Variant == mod.Monsters.Silly.Var) then
        if coll.Type == 1 or (coll.Type == 2 and coll.Parent.Position:Distance(npc.Position) < 30) then
            return true
        end
    end
end

function mod.UpdateSillyStringProj(proj, coll, d)
    if d.type == "SillyString" and coll.Type == 1 then
        local pard = d.Parent:GetData()

        pard.state = "idle"
        pard.baby:GetData().state = "idle"
        pard.isRecieving = false
        pard.baby:GetData().isRecieving = false
        pard.shottorecieve = false
        pard.baby:GetData().shottorecieve = false
        pard.shootinginit = false
        pard.baby:GetData().shootinginit = false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Silly.Var or npc.Variant == mod.Monsters.String.Var and not npc:GetData().targisPlayer then
        if source.Type == 2 and mod:CheckForOnlyEntInRoom({
            mod:ENT("Silly"),
            mod:ENT("String")
        }) == false then
            return {Damage=0.05}
        end
    end
end)

function mod.SillyShot(p, d)
    if d.type == "SillyString" then
        p.Height = -10
        p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    end
end


