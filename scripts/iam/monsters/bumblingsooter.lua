local mod = FHAC
local game = Game()
local rng = RNG()

local function GetInRoomPos(position, add)
    local room = Game():GetRoom()

    if not room:IsPositionInRoom((position + add), 10) then
        local newpos = add:Rotated(math.random(-40, 40))

        if room:IsPositionInRoom(position + newpos, 10) then
            return position + newpos
        else
            return GetInRoomPos(position, newpos)
        end
    else
        return position + add
    end
end

function mod:BumblingSooterAI(npc, sprite, d)

    local anmaddend = ""

    if not d.init then
        d.newpos = GetInRoomPos(npc.Position, Vector(0, 3):Rotated(math.random(-40, 40)))
        d.state = "land"
        d.walkCy = 0
        npc.SplatColor = FHAC.Color.Charred
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if target.Velocity:Length() > 0 and game:GetRoom():CheckLine(npc.Position, (target.Position + target.Velocity:Resized(10)), 0, 1, false, false) and npc.Position:Distance((targetpos + target.Velocity:Resized(30))) < 160 then
        d.newpos = (targetpos + target.Velocity:Resized(30))
    end

    if not d.haslanded or (d.haslanded and npc.Velocity:Length() > 2.4) then

        if math.abs(npc.Velocity.Y) > 1 then
            if npc.Velocity.Y < 0 then
                anmaddend = "Up"
            else
                anmaddend = "Down"
            end
        end

        mod:spritePlay(sprite, "Bounce" .. anmaddend)

    elseif npc.Velocity:Length() > 0.05 and d.haslanded then

        d.walkCy = d.walkCy + math.min(npc.Velocity:Length(), 0.2)

        if d.walkCy > 4 then
            d.walkCy = 1
        end
        
        sprite:SetFrame("Walk", math.floor(d.walkCy))

    else
        sprite:Play("Idle")
        d.state = "land"
    end

    if npc.Velocity.X < 0 then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    if d.state == "move" then
        
        npc.Velocity = mod:Lerp(npc.Velocity, (d.newpos - npc.Position):Resized(6), 0.3)

        if npc.StateFrame > 2 then
            d.state = nil
            npc.StateFrame = 0
        end
    elseif d.state == "land" then
        npc:MultiplyFriction(0.94)

        if npc.StateFrame > 50 and math.random(1, 100) < 70 then
            d.state = "move"
            npc.StateFrame = 0
        end
    else
        if npc.StateFrame > 50 and math.random(1, 100) < 75 then
            d.state = "move"
            npc.StateFrame = 0
        end

        d.newpos = GetInRoomPos(npc.Position, Vector(0, 3):Rotated(math.random(-360, 360)))
    end

    if sprite:IsEventTriggered("Land") then
        npc.StateFrame = 0
        d.state = "land"
        d.haslanded = true
    elseif sprite:IsEventTriggered("Bounce") then
        d.haslanded = false
    end

    for _, ent in ipairs(Isaac.FindInCapsule(npc:GetCollisionCapsule())) do
        if ent.Type > 10 and ent.Type < 1000 and ent.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
            local vel = (npc.Position - ent.Position) * 0.1
            npc.Velocity = npc.Velocity + vel
            ent.Velocity = ent.Velocity - vel
        end
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

        local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, nil):ToEffect()
        ef:SetTimeout(50)
        ef.SpriteScale = Vector(0.05,0.05)
        ef:Update()
        ef.Color = Color(0.1, 0.1, 0.1, 0.4)

    end

    for i = 1, math.random(3, 5) do
        local soot = Isaac.Spawn(mod.Monsters.Soot.ID, mod.Monsters.Soot.Var, 0, npc.Position, Vector(2, 0):Rotated(math.random(1, 360)), nil)
        soot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        soot.HitPoints = soot.MaxHitPoints/2
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
