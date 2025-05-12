local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Woodhead.Var then
        mod:WoodheadAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Woodhead.ID)

function mod:WoodheadAI(npc, sprite, d)

    if not d.init then
        sprite:PlayOverlay("Head")
        d.wait = math.random(-5, 5)
        d.newpos = mod:freeGrid(npc, true, 400, 0)
        d.state = "alive"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local path = npc.Pathfinder
    local teartab = {}

    local closesttear
    local initdis = 10^10

    local isBurningBasement = (room:GetBackdropType() == BackdropType.BURNT_BASEMENT)

    if isBurningBasement then
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/woodhead/woodheadbodyburningbase", 1)
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/woodhead/woodheadburningbase", 1)
    end

    if d.state == "alive" then

        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 2 then
                table.insert(teartab, v)
            end
        end


        for k, v in ipairs(teartab) do
            local dis = npc.Position:Distance(v.Position)
            if dis < initdis then
                closesttear = v
            end
        end

        if closesttear then
            path:EvadeTarget(closesttear.Position)
        end


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
            if npc.Position:Distance(d.newpos) < 20 then
                d.wait = 0
                d.newpos = mod:freeGrid(npc, true, 400, 0)
                npc.StateFrame = 0
            elseif npc.StateFrame > 25 + d.wait then
                if mod:isScare(npc) then
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(-7, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 0.2)
                elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(7, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 0.2)
                else
                    path:FindGridPath(d.newpos, 0.7, 1, true)
                end
            end
        end

        path:EvadeTarget(targetpos)


        if npc.Velocity:Length() > 0.2 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
            sprite:PlayOverlay("Head")
        else
            sprite:SetFrame("WalkHori", 0)
        end
    end

    if d.state == "dead" then
        npc.GridCollisionClass = 0
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.Velocity = Vector.Zero
        sprite:RemoveOverlay()
        mod:spritePlay(sprite, "Death")
        if sprite:IsEventTriggered("Shoot") then
            for i = 1, math.random(5, 7) do
                local realshot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10, 0):Rotated(math.random(1,360)), npc):ToProjectile()
                realshot.FallingAccel = 0.01
                realshot.FallingSpeed = 0.1
                realshot:GetData().type = "woodhead"
            end
        end
        if sprite:IsFinished() then
            npc:Remove()
        end
    end
end

function mod.WoodheadShots(v, d)
    if d.type == "woodhead" then
        v.SpriteRotation = v.Velocity:GetAngleDegrees()
        local psprite = v:GetSprite()
        psprite:ReplaceSpritesheet(0, "gfx/projectiles/woodplanklegacy_projectile.png")
        psprite:LoadGraphics()

        v.Height = -20

        if v:IsDead() then
            local ef = Isaac.Spawn(1000, EffectVariant.WOOD_PARTICLE, 0, v.Position, Vector.Zero, v):ToEffect()
            ef:GetData().type = "temp"
            v:Remove()
        end


    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
    if npc.Type == mod.Monsters.Woodhead.ID and npc.Variant == mod.Monsters.Woodhead.Var and npc.HitPoints - dmg <= 0 then
        npc:GetData().state = "dead"
        return false
    end
end, mod.Monsters.Woodhead.ID)