local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SyntheticHorf.Var then
        mod:SyntheticHorfAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SyntheticHorf.ID)

function mod:SyntheticHorfAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()

    if not d.init then
        d.state = "idle"
        d.shootoffset = 20 + rng:RandomInt(1, 20)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Shake")
    end

    if d.state == "idle" and npc.StateFrame > d.shootoffset and 
    (target.Position - npc.Position):Length() < 300 then
        d.state = "attacking"
        sprite:Play("Attack", true)
    end 

    if d.state == "attacking" then
        npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-6)
        effect.DepthOffset = npc.Position.Y * 1.25
        d.shootoffset = 20 + rng:RandomInt(1, 20)


        local p = Isaac.Spawn(9, 0, 0, npc.Position, Vector(1, 0):Rotated((target.Position - npc.Position):GetAngleDegrees()):Resized(1), npc):ToProjectile()
        p.Parent = npc
        p.ChangeTimeout = p.ChangeTimeout * 13.4
        p:GetData().type = "SyntheticHorf"
        p:GetData().offyourfuckingheadset = 120 + rng:RandomInt(-10, 10)
        p:GetData().StateFrame = 0
        d.state = "doneattacking"
    end

    if sprite:IsFinished("Attack") then
        npc.StateFrame = 0
        d.state = "idle"
    end
end

function mod.SyntheticHorfShot(p, d)
    if d.type == "SyntheticHorf" and p.Parent then
        local par = p.Parent
        local room = game:GetRoom()
        local npc = par:ToNPC()
        local target = npc:GetPlayerTarget()
        if d.StateFrame > 300 then
            if d.offyourfuckingheadset < 200 and d.Peak == false then
                d.offyourfuckingheadset = d.offyourfuckingheadset + 10
            elseif d.offyourfuckingheadset >= 200 or d.Peak == true then
                d.Peak = true
                d.offyourfuckingheadset = d.offyourfuckingheadset - 5
            end
        else
            d.newpos = target.Position
        end

        if d.StateFrame < 20 then
            p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        d.StateFrame = d.StateFrame + 1

        d.moveoffset = 0
        d.wobb = d.wobb or 0
        d.moveit = d.moveit or 0
        p.Height = -20
        if d.moveit >= 360 then d.moveit = 0 else d.moveit = d.moveit + 0.07 end
        d.wobb = d.wobb + math.pi/math.random(3,12)
        local vel = mod:GetCirc((d.offyourfuckingheadset or 75) + math.sin(d.wobb), d.moveit)
        
        if room:IsClear() and p.Parent:IsDead() then
            p.Velocity = p.Velocity * 0.9
			p.FallingAccel = 0.1
        end
        if p.Parent then
            p.Velocity = mod:Lerp(p.Velocity, Vector(d.newpos.X - vel.X, d.newpos.Y - vel.Y) - p.Position, 0.1)
        end
    end
end
