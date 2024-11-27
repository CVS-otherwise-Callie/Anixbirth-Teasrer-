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

        local newgrid = 10^10
        for i = 1, 4 do
            local attachPos = room:GetLaserTarget(npc.Position, npc.V1:Rotated(i))
            if attachPos:Distance(npc.Position) < newgrid then
                newgrid = attachPos
            end
        end


        d.mynewPos = mod:freeGrid(npc, false, 100, 1)
        d.npcinit = true
    else
        npc.StateFrame = npc.StateFrame + 1
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

