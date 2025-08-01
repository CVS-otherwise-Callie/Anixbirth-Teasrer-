local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SyntheticHorfAI(npc, sprite, d)

    local function SyntheticHorfShot()
        local p = Isaac.Spawn(9, 0, 0, npc.Position, Vector(1, 0):Rotated((d.target.Position - npc.Position):GetAngleDegrees()):Resized(1), npc):ToProjectile()
        p.Parent = npc
        p.ChangeTimeout = p.ChangeTimeout * 13.4
        p:GetData().type = "SyntheticHorf"
        p:GetData().offyourfuckingheadset = 70 + math.random(-10, 10)
        p:GetData().StateFrame = 0
        p:GetData().Baby = d.target
        p:GetData().Player = npc:GetPlayerTarget()

        d.target:GetData().shoties = d.target:GetData().shoties or {}
        table.insert(d.target:GetData().shoties, p)
        p:GetData().moveit = (d.target:GetData().shoties[1]:GetData().moveit or 0) + ((360/(360/d.max))* d.target:GetData().rotShots)
    end

    if not d.init then
        d.target = mod:GetEntInRoom(npc, true, npc)
        d.target:GetData().rotShots = d.target:GetData().rotShots or 0
        d.state = "idle"
        d.max = math.random(4, 6)
        d.shootoffset = 20 + rng:RandomInt(1, 20)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Shake")
    end

    if d.target then

        if d.state == "idle" and npc.StateFrame > d.shootoffset and d.target and
        (d.target.Position - npc.Position):Length() < 300 and d.target:GetData().rotShots and d.target:GetData().rotShots < d.max then
            d.state = "attacking"
            npc.StateFrame = 0
        end 

        if d.state == "attacking" then
            sprite:Play("Attack", true)
            npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
            local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
            effect.SpriteOffset = Vector(0,-6)
            effect.DepthOffset = npc.Position.Y * 1.25
            d.shootoffset = 20 + rng:RandomInt(1, 10)
            SyntheticHorfShot()
            d.state = "doneattacking"
        end

        if d.target:IsDead() or (d.target:GetData().rotShots and d.target:GetData().rotShots >= d.max) then
            d.target = mod:GetEntInRoom(npc, true, npc)
            d.target:GetData().rotShots = d.target:GetData().rotShots or 0
        end

        if sprite:IsFinished("Attack") then
            d.state = "idle"
        end
    end
end

function mod.SyntheticHorfShot(p, d)
    if d.type == "SyntheticHorf" then
        local room = game:GetRoom()
        local target = d.Baby
        p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        if not d.init then
            target:GetData().rotShots = target:GetData().rotShots or 0
            target:GetData().rotShots = target:GetData().rotShots + 1
            d.init = true
        else
            d.StateFrame = d.StateFrame + 1
        end
        if target:IsDead() or (d.shouldFall and d.StateFrame > d.shouldFall) then
            p.Velocity = p.Velocity * 0.9
			p.FallingAccel = 0.1
        else
            p.Height = -20
            d.newpos = target.Position
        end
        p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        if d.StateFrame > 20 and p.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        d.moveoffset = 0
        d.wobb = d.wobb or 0
        d.moveit = d.moveit or 0
        if d.moveit >= 360 then d.moveit = 0 else d.moveit = d.moveit + 0.03 end
        d.wobb = d.wobb + math.pi/math.random(3,12)
        local vel = mod:GetCirc((d.offyourfuckingheadset or 75) + math.sin(d.wobb), d.moveit)
        if room:IsClear() then
            p.Velocity = p.Velocity * 0.9
			p.FallingAccel = 0.1
        end
        if d.state == "circling" then
            if d.newpos then
                p.Velocity = mod:Lerp(p.Velocity, Vector(d.newpos.X - vel.X, d.newpos.Y - vel.Y) - p.Position, 0.1)
            end
        else
            p.Velocity = mod:Lerp(p.Velocity,(target.Position - p.Position):Resized(15), 0.1)
            if p.Position:Distance(target.Position) < 40 then
                d.state = "circling"
            end
        end        if p:IsDead() and d.Baby:GetData().rotShots then
            d.Baby:GetData().rotShots = d.Baby:GetData().rotShots - 1
        end
    end
end

--u should make a gas themed enemy that leaves a trail
--sure, thx euan