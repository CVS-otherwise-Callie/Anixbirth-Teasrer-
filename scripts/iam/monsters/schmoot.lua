local mod = FHAC
local game = Game()
local rng = RNG()

function mod:SchmootAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (targetpos - npc.Position):GetAngleDegrees()

    if not d.init then
        npc.SpriteOffset = Vector(0,-20)
        d.coolaccel = 1
        if not d.state == "Deathin" then
            d.state = "idle"
        end
        sprite:SetFrame(rng:RandomInt(1, 6))
        npc.StateFrame = 0
        npc.SplatColor = FHAC.Color.Charred
        if not npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
            if not d.hasplayeddeath then
                mod:spritePlay(sprite, "Death")
                d.hasplayeddeath = true
            end
        else
            if rng:RandomInt(1, 2) == 2 then
                d.isburning = true
            else
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/schmoot/shmoot_put_out", 1)
                mod:ReplaceEnemySpritesheet(npc, "gfx/nothing", 0)
                d.isburning = false
            end
            npc:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS | EntityFlag.FLAG_NO_KNOCKBACK)
        end
        d.lerpnonsense = 0.06
        d.shootinit = false
        d.init = true
    else
        if not (d.state == "Deathin" or d.state == "fallin" or d.state == "rollin") then
            npc.Velocity = npc.Velocity * 0.5
        end
    end

    if sprite:IsFinished("Appear") then
        if d.state ~= "Deathin" then
        mod:spritePlay(sprite, "Idle")
        d.state = "idle"
        end
    end


    if (npc.HitPoints) > (npc.MaxHitPoints/2) and d.state == "idle" then
        if (target.Position - npc.Position):Length() < 150 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            if not d.shootinit and not mod:isScareOrConfuse(npc) then
                d.state = "BeginShoot"
                mod:spritePlay(sprite, "BeginShoot")
                d.shootinit = true
            end
        else
            d.shootinit = false
            npc.StateFrame = 0
            d.state = "idle"
            mod:spritePlay(sprite, "Idle")
        end
    end

    if d.state == "BeginShoot" then
        if sprite:IsFinished("BeginShoot") then
            sprite:Play("WaitShoot")
            if d.isburning == false then
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/schmoot/shmoot_up", 1)
                mod:ReplaceEnemySpritesheet(npc, "gfx/effects/rebirth/effect_005_fire", 0)
            end
        end
        npc.StateFrame = npc.StateFrame + 1
        if npc.StateFrame >= 40 or (target.Position - npc.Position):Length() > 200 or not game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            if d.isburning == false then
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/schmoot/shmoot_put_out", 1)
                mod:ReplaceEnemySpritesheet(npc, "gfx/nothing", 0)
            end
            npc.StateFrame = 0
            mod:spritePlay(sprite, "Shoot")
            if not d.hasmovedaway then
                local fire
                if (target.Position - npc.Position):Length() > 100 then
                    local targetvelocity = (targetpos - npc.Position)
                    FHAC:ShootFire(npc.Position, Vector(5, 0):Rotated(enemydir), {scale = 1.1, timer = 150, hp = 2, radius = 19})
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.08)
                else
                    local targetvelocity = (targetpos - npc.Position)
                    FHAC:ShootFire(npc.Position, Vector(3, 0):Rotated(enemydir), {scale = 1.1, timer = 150, hp = 2, radius = 19})
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.04)
                end
                d.hasmovedaway = true
            end
        end

        if sprite:IsFinished("Shoot") then
            d.hasmovedaway = false
            d.shootinit = false
            d.state = "idle"
            sprite:Play("Idle")
        end
    end

    function mod:spawnSchmoot(ent)
        local npc = ent:ToNPC()
        local data = npc:GetData()
        local newschmoot = Isaac.Spawn(mod.Monsters.Schmoot.ID, mod.Monsters.Schmoot.Var, 0, npc.Position, npc.Velocity, npc)
        newschmoot.SpriteOffset = Vector(0,-20)
        local newdata = newschmoot:GetData()
        if not d.isburning then
            mod:ReplaceEnemySpritesheet(newschmoot, "gfx/monsters/schmoot/shmoot_put_out", 1)
            mod:ReplaceEnemySpritesheet(newschmoot, "gfx/nothing", 0)
        end
        newdata.state = "Deathin"
        newdata.isDead = true
        newdata.secondinit = true
        newschmoot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        data.noMore = true
    end

    if d.state == "Deathin" then
        if not d.secondinit then
            d.state = "Deathin"
        end
        if sprite:IsFinished("Death") then
            sprite:Play("Roll")
            d.secondinit = true
            d.state ="rollin"
        end
    end

    if d.state == "rollin" then
        npc.SpriteOffset = Vector(0, -8)
        mod:spritePlay(sprite, "Roll")
        if d.coolaccel and d.coolaccel < 5 then
            d.coolaccel = d.coolaccel + 0.1
        end
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        end
        npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
        if npc:CollidesWithGrid() then
            d.coolaccel = 1
        end
        mod:CatheryPathFinding(npc, target.Position, {
            Speed = d.coolaccel,
            Accel = d.lerpnonsense,
            GiveUp = true
        })
        if rng:RandomInt(1, 2) == 2 then
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
        else
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
        end
    else
        d.coolaccel = 1
    end
    
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt, flag, source)
    if npc.Variant == mod.Monsters.Schmoot.Var then
        if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then return false end
        return true
    end
end, mod.Monsters.Schmoot.ID)

function mod.SchmootDeath(ent)
    if ent.Type == 161 and ent.Variant == mod.Monsters.Schmoot.Var then
    local ent = ent:ToNPC()
    local sprite = ent:GetSprite()
    local d = ent:GetData()
    if ent.Variant ~= mod.Monsters.Schmoot.Var then return end
    if d.isDead or sprite:IsPlaying("Death") or sprite:IsPlaying("Roll") then return end
        mod:ReplaceEnemySpritesheet(ent, "gfx/nothing", 0)
        mod:ReplaceEnemySpritesheet(ent, "gfx/nothing", 1)
        ent.Velocity = Vector.Zero
        mod:spawnSchmoot(ent)
        ent:Remove()
    end
end