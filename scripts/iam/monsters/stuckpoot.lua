local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Stuckpoot.Var then
        mod:StuckpootAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Stuckpoot.ID)

function mod:StuckpootAI(npc, sprite, d)

    local room = game:GetRoom()

    if not d.npcinit then
        d.state = "idle"
        d.mynewPos = mod:freeGrid(npc, false, 100, 1)
        d.npcinit = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    npc.State = 8

    if npc.StateFrame > 100 and d.state == "idle" then
        d.state = "moving"
        npc.StateFrame = 50
    end
    
    if d.state == "idle" or d.state == "moving" then
        sprite:Play("Idle")
    end

    if d.state == "moving" then
        if sprite.FlipY == 90 or sprite.FlipY == -90 then
            npc.Velocity = mod:Lerp(npc.Velocity, (Vector(0, d.mynewPos.Y)), 0.05)
            if math.abs(npc.Position.Y - d.mynewPos.Y) < 22 then
                d.state = "shoot"
            else
                print(math.abs(npc.Position.Y - d.mynewPos.Y))
            end
        else
            npc.Velocity = mod:Lerp(Vector.Zero, Vector(npc.Position.X + d.mynewPos.X, 0), 0.05)
            if math.abs(d.mynewPos.X - npc.Position.X) < 10 then
                d.state = "shoot"
                d.pos = npc.Position
            else
                print(npc.Position.X, d.mynewPos.X)
            end
        end
    end

    if d.state == "shoot" then
        mod:spritePlay(sprite, "Attack")
        npc.Position = d.pos
    end

    if sprite:IsFinished("Attack") then
        d.mynewPos = mod:freeGrid(npc, false, 1000, 1)
        d.state = "idle"
    end
end

function mod:StuckpootShartProjectile(p, d)
    local npc = p.Parent:ToNPC()
    if p.Parent.Type == 240 and p.Parent.Variant == 167 then
        local room = game:GetRoom()
        local ffcoolcolor = Color(1,1,1,1,0,0,0)
        ffcoolcolor:SetColorize(1.3, 1.8, 0.5, 1)
        
        local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated((room:GetCenterPos() - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        projectile.FallingSpeed = -10
        projectile.Color = ffcoolcolor
        projectile.FallingAccel = 0.5
        projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.EXPLODE
        if npc.IsFriendly then
            projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
        elseif npc.IsCharmed then
            projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER
        end
    end
end

