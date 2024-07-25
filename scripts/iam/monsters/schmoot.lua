local mod = FHAC
local game = Game()
local rng = RNG()
local room = game:GetRoom()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Schmoot.Var then
        mod:SchmootAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Schmoot.ID)

function mod:SchmootAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (targetpos - npc.Position):GetAngleDegrees()
    local path = npc.Pathfinder

    if not d.init then
        if rng:RandomInt(1, 2) == 2 then
            mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/schmoot/shmoot_put_out", 1)
            mod:ReplaceEnemySpritesheet(npc, "gfx/nothing", 0)
            d.isburning = false
        else
            d.isburning = true
        end
        npc.SpriteOffset = Vector(0,-20)
        d.state = "idle"
        mod:spritePlay(sprite, "Idle")
        sprite:SetFrame(rng:RandomInt(1, 6))
        npc.StateFrame = 0
        npc.SplatColor = FHAC.Color.Charred
        d.shootinit = false
        d.init = true
    end

    npc.Velocity = npc.Velocity * 0.5

    if (npc.HitPoints) > (npc.MaxHitPoints/2) and d.state == "idle" then
        if (target.Position - npc.Position):Length() < 150 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            if not d.shootinit then
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
        if npc.StateFrame >= 30 or (target.Position - npc.Position):Length() > 200 or not game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
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
                    fire = Isaac.Spawn(33, 10, 0, npc.Position, Vector(5, 0):Rotated(enemydir), npc)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.08)
                else
                    local targetvelocity = (targetpos - npc.Position)
                    fire = Isaac.Spawn(33, 10, 0, npc.Position, Vector(3, 0):Rotated(enemydir), npc)
                    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.04)
                end
                fire.Size = fire.Size / 5
                mod:ReplaceEnemySpritesheet(fire, "gfx/effects/rebirth/effect_005_fire", 0)
                fire:GetSprite().Scale = fire:GetSprite().Scale / 100
                fire:Update()
                d.hasmovedaway = true
            end
        end

        if sprite:IsFinished("Shoot") then
            d.hasmovedaway = false
            d.shootinit = false
            if (npc.HitPoints) < (npc.MaxHitPoints/2) then
                d.state = "fallin"
                sprite:Play("Fall")
            else
                d.state = "idle"
                sprite:Play("Idle")
            end
        end
    end

    if d.state == "fallin" then
        if not d.secondinit then
            npc:AddHealth(15)
            d.state = "fallin"
        end
        if sprite:IsFinished("Fall") then
            sprite:Play("Roll")
            d.secondinit = true
            d.state ="rollin"
        end
    end

    if d.state == "rollin" then
        npc.SpriteOffset = Vector(0, -8)
        mod:spritePlay(sprite, "Roll")
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(15)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        else
            path:FindGridPath(targetpos, 0.9, 1, true)
        end
    end
end

