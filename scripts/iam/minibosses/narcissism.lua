local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.MiniBosses.Narcissism.Var then
        mod:NarcissismAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.MiniBosses.Narcissism.ID)

function mod:NarcissismAI(npc, sprite, d)

    local path = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local sfx = SFXManager
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (targetpos - npc.Position):GetAngleDegrees()
    local projparams = ProjectileParams()

    local function NarcCheckDirs(enemydir)
        for i in ipairs(mod.StonerDirs) do
            if enemydir > mod.StonerDirs[i][2] and enemydir < mod.StonerDirs[i][3] then
                return mod.StonerDirs[i][1]
            end
        end
        return mod.StonerDirs[1][1]
    end
    local direction = NarcCheckDirs(enemydir)

    local mirror
    local mirrorsprite
    local mirrord
    if d.personalMirror then
        mirror = d.personalMirror
        mirrorsprite = d.personalMirror:GetSprite()
        mirrord = d.personalMirror:GetData()
    end

    local function SpawnMirror(state)

        if state == "summon" then
            d.personalMirror = Isaac.Spawn(mod.Monsters.NarcissismMirror.ID, mod.Monsters.NarcissismMirror.Var, -1, npc.Position + Vector(10, 0):Rotated(direction), Vector.Zero, npc):ToNPC()
            d.personalMirror.Parent = npc
            d.personalMirror:GetData().state = "hangingmidair"
            d.personalMirror:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            mirror = d.personalMirror
            mirrorsprite = d.personalMirror:GetSprite()
            mirrord = d.personalMirror:GetData()

        end

    end

    if not d.init then
        d.state = "idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "chill" then

        d.newpos = d.newpos or mod:GetNewPosAligned(targetpos, false)

        if npc.Position:Distance(d.newpos) > 10 then
            local targetvelocity = (d.newpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
        else
            if not d.personalMirror then
                mod:spritePlay(sprite, "summon")
                d.state = "summon"
                npc.StateFrame = 0
            end
            npc.Velocity = Vector.Zero
        end

    elseif d.state == "wanderlegacy" then --sadly never used
        if mod:isCharm(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
            else
                path:FindGridPath(targetpos, 0.85, 1, true)
            end
        elseif mod:isScare(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
            else
                path:FindGridPath(targetpos, -0.85, 1, true)
            end
        else
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:MoveRandomly(false)
        end
        npc:MultiplyFriction(0.65+(0.016))
    elseif d.state == "throwmirror" then
        mod:spritePlay(sprite, "MirrorThrow")
    elseif d.state == "summon" then
        
    else
        if not sprite:IsOverlayPlaying() then sprite:SetOverlayFrame("Head", 0) end
        sprite:SetFrame("WalkVert", 0)
        if path:HasPathToPos(targetpos) then
            d.state = "chill"
        end
    end

    if sprite:IsEventTriggered("throwmirror") and d.personalMirror then
        local mirrordir = (targetpos - d.personalMirror.Position):GetAngleDegrees() 
        d.personalMirror.Velocity = mod:Lerp(d.personalMirror.Velocity, Vector(10, 0):Rotated(mirrordir), 1)
        d.personalMirror:GetData().state = "thrown"
        if targetpos.X < npc.Position.X then --future me pls don't fuck this up
            d.personalMirror:GetSprite().FlipX = true
        else
            d.personalMirror:GetSprite().FlipX = false
        end
    elseif sprite:IsEventTriggered("summon") then
            SpawnMirror(d.state)
    end

    if d.personalMirror then

        if direction == 1 then
            mirrorsprite:SetFrame("mirror", 6)
            mirrord.frame = 6
        elseif direction == -90 then
            mirrorsprite:SetFrame("mirror", 12)
            mirrord.frame = 12
        elseif direction == 90 then
            mirrorsprite:SetFrame("mirror", 10)
            mirrord.frame = 10
        elseif direction == 180 then
            mirrorsprite:SetFrame("mirror", 3)
            mirrord.frame = 3
        end

        if mirrord.state == "hangingmidair" then

            mirror.Position = npc.Position + Vector(30, 0):Rotated(direction)

        end
    end

    if sprite:IsFinished("MirrorThrow") then
        d.state = "chill"
        d.newpos = nil
    end

    if targetpos.X < npc.Position.X then
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end

    if d.state == "chill" or d.state == "wanderlegacy" then
        if npc.Velocity:Length() > 1.3 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        end
                
        sprite:Update()
    end

end

