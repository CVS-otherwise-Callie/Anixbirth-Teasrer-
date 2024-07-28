local mod = FHAC
local game = Game()
local rng = RNG()
local room = game:GetRoom()

mod.DrossletDirs = {
    {"Up", false, 1},
    {"Hori", false, 2},
    {"Down", false, 3},    
    {"Hori", true, 4},
}

mod.MoveDirs = {
    Vector(-2.5,2.5),
    Vector(-2.5,-2.5),
    Vector(2.5,-2.5),
    Vector(2.5,2.5),
}

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Drosslet.Var then
        mod:DrossletAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Drosslet.ID)

function mod:DrossletAI(npc, sprite, d)

    if not d.init then
        d.veloctime = math.random(10, 50)
        d.tosharting = 0
        d.boost = 0
        d.spritedir = 0
        d.mycoolclouds = {}
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        d.drossletdir = math.random(4)
        d.waittime = math.random(1, 5)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        d.mycoolclouds = d.mycoolclouds or {}
        if not d.state and npc.StateFrame > d.veloctime/10 then
            d.state = "idle"
        end
    end

    --misc, thanks ff for the cool color
    local ffcoolcolor = Color(1,1,1,1,0,0,0)
	ffcoolcolor:SetColorize(1.3, 1.8, 0.5, 1)

    function mod:DrossletShart(npc, rotation, fall)
        rotation = rotation or 180
        local projectile = Isaac.Spawn(9, 0, 0, npc.Position, npc.Velocity:Rotated(rotation), npc):ToProjectile()
        d.tosharting = 0
        projectile.FallingSpeed = fall or -10
        projectile.Color = ffcoolcolor
        projectile.FallingAccel = 0.5
        projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.EXPLODE
        if npc.IsFriendly then
            projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
        elseif npc.IsCharmed then
            projectile.ProjectileFlags = projectile.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER
        end
    end
    --stuff
    if npc:CollidesWithGrid() and npc.Position then
        local directon = {} --sh- shuddap about my spelling !!!
        for i = 1, 4 do
            if room and room:CheckLine(npc.Position, npc.Position+Vector(20,20):Rotated(90*i),0,1,false,false) then --struggle
                table.insert(directon, i)
            end
        end
        if #directon ~= 0 then
            d.drossletdir = directon[math.random(#directon)]
        else
            d.drossletdir = mod.DrossletDirs[d.drossletdir][3]
        end

        if d.mycoolclouds and #d.mycoolclouds > d.waittime then
            mod:DrossletShart(npc, 90)
            for k in pairs (d.mycoolclouds) do
                d.mycoolclouds [k] = nil
            end
            d.waittime = math.random(1, 5)
        end

        for i = 1, #d.mycoolclouds do
            d.mycoolclouds[i]:SetTimeout(120)
        end
    end
    if mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, mod.MoveDirs[d.drossletdir], -0.5):Resized(d.boost)
    else
        npc.Velocity = mod:Lerp(npc.Velocity, mod.MoveDirs[d.drossletdir], 0.5):Resized(d.boost)
    end
    --anims
    if not d.canceldirectionchange then
        if npc.Position.Y+mod.MoveDirs[d.drossletdir].Y < npc.Position.Y then
            d.spritedir = "Up"
        else
            d.spritedir = "Down"
        end
        if npc.Position.X+mod.MoveDirs[d.drossletdir].X < npc.Position.X then
            if d.spritedir == "Up" then
                sprite.FlipX = false
            else
                sprite.FlipX = true
            end
        else
            if d.spritedir == "Up" then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end    
        end 
    end
    if d.state == "idle" then
        d.fartinit = false
        mod:spritePlay(sprite, "Idle" .. d.spritedir)
        if npc.StateFrame > d.veloctime then
                if rng:RandomInt(100) > 70 then
                    d.drossletdir = math.random(4)
                end
                d.veloctime = math.random(10, 50)
                d.state = "fart"
        end
        if not (d.boost <= 0) then
            d.boost = d.boost - 0.1
        end
    end
    if d.state == "fart" then
        if not d.fartinit then
            mod:spritePlay(sprite, "Fart" .. d.spritedir)
            d.canceldirectionchange = true
            d.fartinit = true
        end
        if not (d.boost <= 0) then
            d.boost = d.boost - 0.1
        end
    end
    if sprite:IsEventTriggered("Fart") then
        d.tosharting = d.tosharting + 1
        local cloud = Isaac.Spawn(1000, 141, 1, npc.Position, npc.Velocity:Resized(3), npc):ToEffect()
        table.insert(d.mycoolclouds, cloud)
        cloud.Scale = 120
        cloud:Update()
        d.boost = 5
        npc.StateFrame = 0
    end
    if sprite:IsFinished("Fart" .. d.spritedir) then
        d.canceldirectionchange = false
        d.boost = 5
        npc.StateFrame = 0
        d.state = "idle"
    end


    --so it doesnt blow itself up
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
        if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and mod:IsSourceofDamagePlayer(source, true) == false then
            return false
        end
    end, mod.Monsters.Drosslet.ID )

    if npc:IsDead() then
        mod:DrossletShart(npc, 180, -20)
    end

end

    --and also to protect other mobs
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and source and source.Entity and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Type == mod.Monsters.Drosslet.ID and source.Entity.SpawnerEntity.Variant == mod.Monsters.Drosslet.Var then
        if not npc.Type == mod.Monsters.Drosslet.ID and npc.Variant ==  mod.Monsters.Drosslet.Var then
        npc:TakeDamage(damage*0.05, flag & ~DamageFlag.DAMAGE_EXPLOSION, source, 0)
        return false
        end
    end
end)

