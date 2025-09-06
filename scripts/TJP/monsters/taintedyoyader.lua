local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedYoyader.Var then
        mod:TaintedYoyaderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedYoyader.ID)

if REPENTOGON then
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Monsters.TaintedYoyader.Var then
        mod:TaintedYoyaderBeamAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.TaintedYoyader.ID)
end

function mod:TaintedYoyaderAI(npc, sprite, d)
    
    print(d.state)

    local player = npc:GetPlayerTarget()
    local playerpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    local speed = 2

    if not d.init then
        d.init = true
        d.redirecttimer = 0
        if npc.Parent then
            npc.Parent:GetData().spideramount = npc.Parent:GetData().spideramount + 1
            d.state = "spider"
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        else
            d.state = "chase"
            d.spideramount = 0
        end
        d.wait = math.random(25)
    else
        npc.StateFrame = npc.StateFrame + 1
        d.redirecttimer = d.redirecttimer - 1
    end

    if d.state == "chase" then

        if mod:isScare(npc) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed * -1)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        elseif room:CheckLine(npc.Position,playerpos,0,1,false,false) then
            local targetvelocity = (playerpos - npc.Position):Resized(speed)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
        else
            path:FindGridPath(playerpos, 0.3, 1, true)
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
        if npc.StateFrame > 75 + d.wait then
            d.wait = math.random(15)
            if d.spideramount < 3 then
                if npc.Position.X < playerpos.X then
                    sprite.FlipX = true
                else
                    sprite.FlipX = false
                end
                d.state = "throwstart"
            else
                d.spideramount = d.spideramount + 1
                sprite.FlipX = false
                d.state = "redirect"
            end
        end
    end

    if d.state == "throwstart" then

        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "Throw")
        sprite:RemoveOverlay()
        if sprite:IsFinished("Throw") then
            npc.StateFrame = 0
            d.state = "throwend"
        end
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

    if d.state == "redirect" then
        npc.Velocity = npc.Velocity * 0.4
        mod:spritePlay(sprite, "RedirectSpiders")
        sprite:RemoveOverlay()

        if sprite:IsFinished("RedirectSpiders") then
            sprite.FlipX = false
            npc.StateFrame = 0
            d.state = "chase"
        end
    end

    if d.state == "spider" then
        npc.GridCollisionClass = 3

        if npc.StateFrame % 10 == 1 then
            npc:PlaySound(mod.Sounds.SpinSound, 0.6, 2, false, 0.6)
        end

        if not npc.Parent or npc.Parent:IsDead() or not npc.Parent.Position then
            npc:Kill()
        else
            mod:spritePlay(sprite, "SpinningSpider")

            local targetvelocity
            if not d.redirectplayerpos then
                d.redirectplayerpos = playerpos + Vector(math.random(-50,50),math.random(-50,50))
            end
            if npc.Parent and npc.Parent:GetData().redirecttimer > 0 then
                targetvelocity = (d.redirectplayerpos - npc.Position):Resized(14)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.005)
            else
                d.redirectplayerpos = playerpos + Vector(math.random(-50,50),math.random(-50,50))
                targetvelocity = npc.Velocity:Resized(7)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
            end


            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)

            if REPENTOGON then
                local bsprite = Sprite()
                bsprite:Load("gfx/monsters/taintedyoyader/taintedyoyader.anm2", true)
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

        npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, 0.6)
        npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, 1, 5, false, 0.6)

        if sprite.FlipX then
            d.startingvelocity = Vector(35,1)
        else
            d.startingvelocity = Vector(-35,1)
        end
        local spider = Isaac.Spawn(mod.Monsters.TaintedYoyader.ID, mod.Monsters.TaintedYoyader.Var, mod.Monsters.TaintedYoyader.Sub, npc.Position + d.startingvelocity, (playerpos - (npc.Position+d.startingvelocity)):Resized(14), npc)
        spider.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        spider.Parent = npc
        spider.EntityCollisionClass = 1
        local spidersprite = spider:GetSprite()
        spidersprite:Play("SpinningSpider")
        --mod:AttachCord(npc, spider, 0, "Cord", Color.Default, d.startingvelocity, Vector.Zero)
    end

    if sprite:IsEventTriggered("Redirect") then
        npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_B, 1, 2, false, 1)
        d.redirecttimer = 15
    end
end

function mod:TaintedYoyaderBeamAI(npc, sprite, d)

    if d.beam and npc.Parent and not npc.Parent:IsDead() and npc.Parent:Exists() then

        local off = -1

        if npc.Parent.FlipX then
            off = 1
        end

        if not d.originoffset then
            d.originoffset = Vector(math.random(-13,13), math.random(-24,-10))
        end

        local origin = Isaac.WorldToScreen(npc.Parent.Position + (d.originoffset * npc.Scale))
        local target = Isaac.WorldToScreen(npc.Position+Vector(0,-8) * npc.Scale)

        d.beam:Add(origin,0)
        d.beam:Add(target,64)


        d.beam:Render()

    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_DEVOLVE, function(_, npc)
    if npc.Type == mod.Monsters.TaintedYoyader.ID and npc.Variant == mod.Monsters.TaintedYoyader.Var and npc:GetData().state == "spider" then
        return true
    end
end, 426)