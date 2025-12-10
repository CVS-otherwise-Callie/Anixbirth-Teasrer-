local mod = FHAC
local game = Game()
local rng = RNG()

function mod:BumblingSooterAI(npc, sprite, d)

    local anmaddend = ""

    if not d.init then
        d.newpos = Vector(3, 0):Rotated(math.random(1, 360))
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if target.Velocity:Length() > 0 and game:GetRoom():CheckLine(npc.Position, (target.Position + target.Velocity:Resized(10)), 0, 1, false, false) and npc.Position:Distance((targetpos + target.Velocity:Resized(30))) < 160 then
        d.newpos = (targetpos + target.Velocity:Resized(30))
    end

    if math.abs(npc.Velocity.Y) > 1 then
        if npc.Velocity.Y < 0 then
            anmaddend = "Up"
        else
            anmaddend = "Down"
        end
    end

    if npc.Velocity.X < 0 then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    if sprite:IsEventTriggered("Bounce") then
        npc.Velocity = mod:Lerp(npc.Velocity, (d.newpos - npc.Position):Resized(6), 0.3)
    elseif sprite:IsEventTriggered("Land") then
        npc:MultiplyFriction(0.3)
        d.newpos = Vector(3, 0):Rotated(math.random(1, 360))
    end

    mod:spritePlay(sprite, "Bounce" .. anmaddend)

    if npc:CollidesWithGrid() then
        d.newpos = d.newpos:Rotated(90)
    end

end

function mod.BumblingSootDeath(npc)
    local d = npc:GetData()

    if not (npc.Type == mod.Monsters.BumblingSooter.ID and npc.Variant == mod.Monsters.BumblingSooter.Var) then return end

    d.rngshoot = d.rngshoot or 0
    for i = 1, math.random(20, 30) do
        d.rngshoot = d.rngshoot + math.random(1, 30)
        local proj = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(math.random(80, 120)/100, 0):Rotated((60*i+d.rngshoot)), npc):ToProjectile()
        proj.Height = -5
        proj.FallingSpeed = (math.random(30, 45) * -1)
        proj.FallingAccel = (math.random(8, 12)*0.1)

        proj:GetData().sootstumbleproj = true
        proj:Update()
    end
end

function mod.BumblingSootProjAI(v, d)
    if d.sootstumbleproj then

        v:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/ember.png")
        v:GetSprite():LoadGraphics()

        if v.Height < -100 and not d.hasChanged then
            d.hasChanged = true
        end
        if d.hasChanged then
            v.FallingSpeed = v.FallingSpeed*0.7
            v.FallingAccel = v.FallingAccel*0.7

            v:MultiplyFriction(0.995 - (math.random(1, 4)/1000))

            if math.abs(v.FallingSpeed) < 0.3 then
                d.hasChanged = false
            end
        end

        if v:IsDead() then
            v:Remove()
            v:GetSprite():ReplaceSpritesheet(0, "gfx/nothing.png")
            v:GetSprite():LoadGraphics()

            local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, v.Position + Vector(0, -10),Vector.Zero, nil):ToEffect()
            ef:SetTimeout(10)
            ef.SpriteScale = Vector(0.07,0.07)
            ef:Update()
            ef.Color = Color(0.1, 0.1, 0.1, 1)
            ef:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end

    end
end
