local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Pallun.Var then
        mod:PallunAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Pallun.ID)

function mod:PallunAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        mod:spritePlay(sprite, "Appear")
        d.showoffset = math.random(-10, 10)
        d.state = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if sprite:IsFinished("Appear") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if d.state == "idle" and not sprite:IsPlaying("Appear") then
        mod:spritePlay(sprite, "Idle")
    end

    if d.state == "hiding" then
        if npc.StateFrame > 60 then
            d.state = "idle"
            npc.StateFrame = 0
            npc.Position = PallunFindNewGrid()
            mod:spritePlay(sprite, "Appear")
            d.hidinginit = false
        end
    end

    if npc.StateFrame > 20 + d.showoffset and d.state ~= "shooting" and d.state ~= "hiding" and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) and (not d.shotAlive or d.p:IsDead()) then
        d.state = "shooting"
        mod:spritePlay(sprite, "Shoot")
    elseif npc.StateFrame > 45 + d.showoffset and d.state ~= "shooting" and d.state ~= "hiding"  then
        d.state = "hiding"
        mod:spritePlay(sprite, "Leave")
        npc.StateFrame = 0
    end

    if sprite:IsFinished("Shoot") then
        if math.random(2) ~= 2 then
            d.state = "idle"
        else
            mod:spritePlay(sprite, "Leave")
        end
        npc.StateFrame = 0
    end

    if sprite:IsFinished("Leave") and d.state ~= "hiding" then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        d.state = "hiding"
        npc.StateFrame = 0
    end

    function PallunFindNewGrid()
        local newpos = mod:freeGrid(npc, false, 250, 50)
        if newpos:Distance(targetpos) < 50 then
            return PallunFindNewGrid()
        else
            return newpos
        end
    end

    if sprite:IsEventTriggered("Shoot") then
        npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,1,0,false,1)
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-6)
        effect.DepthOffset = npc.Position.Y * 1.25
        d.p = Isaac.Spawn(9, 0, 0, npc.Position, Vector(1, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()):Normalized(), npc):ToProjectile()
        d.p.Parent = npc
        d.p.Scale = 2.3
        d.p:GetData().type = "Pallun"
        d.p:GetData().target = target
        d.p:GetData().targpos = target.Position
        d.p:GetData().Parent = npc
        d.p:GetData().offset = math.random(10, 30) 
        d.p:GetData().myrand1 = Vector(math.random(-30, 30), math.random(-30, 30))
        if npc:IsChampion() then
            d.p.ProjectileFlags = ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.RED_CREEP
        end
    end

    if targetpos.X < npc.Position.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    npc:MultiplyFriction(0.1)

end


function mod.PallunShot(v, d)
    if d.type == "Pallun" then
        if not d.Parent:IsDead() then
            v.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            d.StateFrame = d.StateFrame or 0
            d.StateFrame = d.StateFrame + 1

            if d.StateFrame > d.offset then
                d.targpos = d.target.Position
                d.myrand1 = Vector(math.random(-30, 30), math.random(-30, 30))
                d.StateFrame = 0
            end
            v.Height = -20
            v.Velocity = mod:Lerp(d.Parent.Velocity, (d.targpos - v.Position) + (d.targpos - v.Position):Normalized()*1.05 + d.myrand1 , 100/1000)

            if v:IsDead() then
                d.Parent:GetData().shotAlive = false
            else
                d.Parent:GetData().shotAlive = true
            end
        else
            v.Velocity = v.Velocity * 0.9
            v.FallingAccel = 0.1  
        end
    end
end

function mod:PallunLeaveWhenHit(npc)
    if npc.Type == mod.Monsters.Pallun.ID and  npc.Variant == mod.Monsters.Pallun.Var then
        local sprite = npc:GetSprite()
        if math.random(1, 3) == 3 then
            if npc:GetData().state ~= "hiding" then
                mod:spritePlay(sprite, "Leave")
                npc:ToNPC().StateFrame = 0
            end
        end
    end
end

