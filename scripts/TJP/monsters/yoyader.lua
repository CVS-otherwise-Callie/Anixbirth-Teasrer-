local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Yoyader.Var then
        mod:YoyaderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Yoyader.ID)

if REPENTOGON then
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.Yoyader.Var then
        mod:YoyaderBeamAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Yoyader.ID)
end

function mod:YoyaderAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 3

    local range = 125 * npc.Scale

    if not d.init then
        d.init = true
        if npc.Parent then
            d.state = "spider"
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        else
            d.state = "chase"
        end
        d.wait = math.random(25)
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "chase" then

        if mod:isScare(npc) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        else
            path:FindGridPath(playerpos, 0.7, 1, true)
        end

        sprite:SetOverlayFrame("Head", 0)
        if npc.Velocity:Length() > 1 then
            if mod:ConvertVectorToWordDirection(npc.Velocity) == "Up" or mod:ConvertVectorToWordDirection(npc.Velocity) == "Down" then
                mod:spritePlay(sprite, "WalkVert")
            else
                mod:spritePlay(sprite, "Walk"..mod:ConvertVectorToWordDirection(npc.Velocity))
            end
        else
            sprite:SetFrame("WalkVert", 0)
        end
        if npc.StateFrame > 75 + d.wait and npc.Position:Distance(playerpos) < range then
            d.wait = math.random(25)
            if npc.Position.X < playerpos.X then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end
            d.state = "throwstart"
        end
    end

    if d.state == "throwstart" then

        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "Throw")
        sprite:RemoveOverlay()
        if sprite:IsFinished("Throw") then
            npc.StateFrame = 0
            d.state = "throwloop"
        end
    end

    if d.state == "throwloop" then

        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "ThrowLoop")
        sprite:RemoveOverlay()

        if npc.StateFrame > 125 + d.wait then
            d.wait  = math.random(1)
            d.state = "waitforreturn"
        end
    end

    if d.state == "waitforreturn" then

        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "ThrowLoop")
        sprite:RemoveOverlay()

    end

    if d.state == "throwend" then

        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "ThrowEnd")
        sprite:RemoveOverlay()

        if sprite:IsFinished("ThrowEnd") then
            sprite.FlipX = false
            npc.StateFrame = 0
            d.state = "chase"
        end

        npc:PlaySound(mod.Sounds.SpinSoundEnd, 0.6, 2, false, 1.5)
    end

    if d.state == "spider" then
        npc.GridCollisionClass = 0

        npc:PlaySound(mod.Sounds.SpinSound, 0.6, 2, false, 1)

        if not npc.Parent or npc.Parent:IsDead() or not npc.Parent.Position then
            npc:Kill()
        else
            mod:spritePlay(sprite, "SpinningSpider")

            local targetpos
            local targetvelocity
            if npc.Parent and npc.Parent:GetData().state ~= "waitforreturn" then
                targetpos = mod:GetClosestPositionInArea(npc.Parent.Position + (npc.Parent:GetData().startingvelocity):Resized(26), range, playerpos)
                targetvelocity = (targetpos-npc.Position):Resized(math.min(7, (npc.Position:Distance(targetpos))))
            else
                targetpos = npc.Parent.Position + (npc.Parent:GetData().startingvelocity):Resized(26)
                targetvelocity = (targetpos-npc.Position):Resized(math.min(7, (npc.Position:Distance(targetpos))))
            end

            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)

            if (npc.Position:Distance(targetpos) < 3 and npc.Parent:GetData().state == "waitforreturn") or npc:IsDead() then
                npc.Parent:GetData().state = "throwend"
                npc:Remove()
            end

            if REPENTOGON then
                local bsprite = Sprite()
                bsprite:Load("gfx/monsters/yoyader/yoyader.anm2", true)
                bsprite:Play("Cord", false)

                local beam = d.beam
                if not beam then
                    d.beam = Beam(bsprite, "cord", false, false)
                    beam = d.beam
                end

                d.beam:GetSprite():Update()
            end
        end
    end

    if sprite:IsEventTriggered("Spider") then

        npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, 1)
        npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, 1, 5, false, 1.5)

        if sprite.FlipX then
            d.startingvelocity = Vector(35,1)
        else
            d.startingvelocity = Vector(-35,1)
        end
        local spider = Isaac.Spawn(mod.Monsters.Yoyader.ID, mod.Monsters.Yoyader.Var, mod.Monsters.Yoyader.Sub, npc.Position + d.startingvelocity, d.startingvelocity:Resized(10), npc)
        spider.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        spider.Parent = npc
        spider.EntityCollisionClass = 1
        local spidersprite = spider:GetSprite()
        spidersprite:Play("SpinningSpider")
        --mod:AttachCord(npc, spider, 0, "Cord", Color.Default, d.startingvelocity, Vector.Zero)
    end
end

function mod:YoyaderBeamAI(npc, sprite, d)

    if d.beam and npc.Parent and not npc.Parent:IsDead() and npc.Parent:Exists() then

        local off = -1

        if npc.Parent.FlipX then
            off = 1
        end

        local origin = Isaac.WorldToScreen(npc.Parent.Position + (Vector(25 * off, -8) * npc.Scale))
        local target = Isaac.WorldToScreen(npc.Position+Vector(0,-8) * npc.Scale)

        d.beam:Add(origin,0)
        d.beam:Add(target,64)


        d.beam:Render()

    end
end
