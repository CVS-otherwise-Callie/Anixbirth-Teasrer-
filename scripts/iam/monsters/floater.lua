local mod = FHAC
local game = Game()
local rng = RNG()
local room = Game():GetRoom()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Floater.Var then
        mod:FloaterAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
    end
end, mod.Monsters.Floater.ID)

        --thx fiend folio
function mod:FloaterAI(npc, sprite, d, r)

    local target = npc:GetPlayerTarget()
    local boost = rng:RandomInt(1, 3)
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
        
        if not d.init then
            npc.StateFrame = 0
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc.GridCollisionClass = (EntityCollisionClass.ENTCOLL_PLAYEROBJECTS)
            npc.EntityCollisionClass = (EntityCollisionClass.ENTCOLL_ALL)
            d.targetvelocity = (targetpos - npc.Position):Resized(boost*-1)
            d.dashper = 70
            d.state = "avoid"
            d.avoid = false
            d.animinit = false
            d.dashinit = false
            npc.SpriteOffset = Vector(0,-10 - boost)
            d.diranim = ""
            d.init = true
            d.moveval = 0
            d.enemydir = (target.Position - npc.Position):GetAngleDegrees()
        else
            d.moveval = 0
            d.enemydir = (target.Position - npc.Position):GetAngleDegrees()
        end

        --animations first
        d.oldanim = d.diranim
            
        if d.enemydir > -90 and d.enemydir < -67.5 then
            d.diranim = "North"
            elseif d.enemydir > -67.5 and d.enemydir < -45 then
            d.diranim = "NorthWest"
            elseif d.enemydir > -45 and d.enemydir < -22.5 then
            d.diranim = "NorthWest2"
            elseif d.enemydir > -22.5 and d.enemydir < 0 then
            d.diranim = "West"
            elseif d.enemydir > 0 and d.enemydir < 22.5 then
            d.diranim = "West"
            elseif d.enemydir > 22.5 and d.enemydir < 45 then
            d.diranim = "SouthWest2"
            elseif d.enemydir > 45 and d.enemydir < 67.5 then
            d.diranim = "SouthWest"
            elseif d.enemydir > 67.5 and d.enemydir < 90 then
            d.diranim = "South"
            elseif d.enemydir > 90 and d.enemydir < 112.5 then
            d.diranim = "South"
            elseif d.enemydir > 112.5 and d.enemydir < 135 then
            d.diranim = "SouthWest"
            elseif d.enemydir > 135 and d.enemydir < 157.5 then
            d.diranim = "SouthWest2"
            elseif d.enemydir > 157.5 and d.enemydir < 180 then
            d.diranim = "West"
            elseif d.enemydir > -180 and d.enemydir < -157.7 then
            d.diranim = "West"
            elseif d.enemydir > -157.5 and d.enemydir < -135 then
            d.diranim = "NorthWest2"
            elseif d.enemydir > -135 and d.enemydir < -112.5 then
            d.diranim = "NorthWest"
            elseif d.enemydir > -112.5 and d.enemydir < -90 then
            d.diranim = "North"
        end

        if d.animinit == false or not d.oldanim == d.diranim then
            d.animinit = true
            sprite:Play(d.diranim, true)
            boost = 4
        end

        if d.state == "chase" or d.state == "avoid" then  
        if d.state == "chase" then
            d.targetvelocity = (targetpos - npc.Position):Resized(boost)
            d.avoidinit = false
        elseif d.state == "avoid" then

            d.moveval = Vector.Zero

            if (d.enemydir > 135 and d.enemydir < 180) or (d.enemydir > 0 and d.enemydir < 45) then
                d.moveval = d.moveval + Vector(0, -1 * d.dashper)
            end
            if (d.enemydir > -180 and d.enemydir < -135) or (d.enemydir < 0 and d.enemydir > -45) then
                d.moveval = d.moveval + Vector(0, 1 * d.dashper)
            end
            if (d.enemydir < -90 and d.enemydir > -135) or (d.enemydir > 90 and d.enemydir < 135) then
                d.moveval = d.moveval + Vector(1 * d.dashper, 0)
            end
            if (d.enemydir < -45 and d.enemydir > -90) or (d.enemydir > 45 and d.enemydir < 90) then
                d.moveval = d.moveval + Vector(-1 * d.dashper, 0)
            end
            d.targetvelocity = (targetpos + d.moveval - npc.Position):Resized(boost)
        end

        --moving
            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.25)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, boost/5)
            end
        end
        

        if target.Position.X < npc.Position.X then --future me pls don't fuck this up
            sprite.FlipX = false
            else
            sprite.FlipX = true
        end

        --Other bullshit
        if sprite:IsFinished() then
            --boost = boost - 2
            local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
            creep.Scale = creep.Scale * 0.4
            creep:SetTimeout(creep.Timeout - 45)
            creep:Update()
            d.animinit = false
        end

        if d.dashinit == true then
            npc.StateFrame = npc.StateFrame + 1
            if npc.StateFrame >= 50 then
                d.dashinit = false
                npc.StateFrame = 0
            end
        end
        
    mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
        d.moveverp = 0
        d.movevel = 0
        if not npc:IsDead() and  d.dashinit == false then
        if ((target.Position - tear.Position):GetAngleDegrees() - (target.Position - npc.Position):GetAngleDegrees()) < 20 and tear.Position:Distance(npc.Position) < 100 and not tear:IsDead() and d.state ~= "avoid" then
            d.dashinit = true
            d.state = "avoiddash"
            --ig this is kinda old but eh
            --omfg i have to so this AGAIN?!
            --sbyil pseodurelgaia, thank you
            if d.enemydir > -90 and d.enemydir < -45 or d.enemydir > 45 and d.enemydir < 90 then
                d.moveval = 90
                elseif d.enemydir > -45 and d.enemydir < 0 or d.enemydir > 135 and d.enemydir < 180 then
                d.moveval = 0
                elseif d.enemydir > 0 and d.enemydir < 45 or d.enemydir > -180 and d.enemydir < -135 then
                d.moveval = 180
                elseif d.enemydir > 90 and d.enemydir < 135 or d.enemydir > -135 and d.enemydir < -90 then
                d.moveval = -90
                else
                d.moveval = 0
            end            
            d.moveverp = 20
            --thx erflyyyyy ily
            d.movevel = Vector(0, d.moveverp):Rotated(d.moveval)
            d.toverp = npc.Position + d.movevel
            npc.Velocity = mod:Lerp(npc.Velocity, d.movevel, 1)
        end

    end

    end)

    d.entcount = 0
    local roomEntities = Isaac.GetRoomEntities()
    if not npc:IsDead() then
    for i, entity in ipairs(roomEntities) do
        if entity.Position:Distance(npc.Position) < 50 then
        if entity.Type == 2 and entity.Variant == 0 then
            if d.toverp and (d.toverp:Distance(npc.Position) < 20 or entity.Position:Distance(npc.Position)) and math.abs(math.abs((target.Position - entity.Position):GetAngleDegrees())) - math.abs((target.Position - npc.Position):GetAngleDegrees()) < 20 then
                d.entcount = d.entcount + 1
            end
        else
        end
        end
    end
    
    if not d.entcount or d.entcount == 0 then
        d.state = "chase"
    elseif d.entcount ~= 0 and d.toverp and not d.avoidinit then
        d.avoidinit = true
        d.state = "avoid"
    end
    end
end

