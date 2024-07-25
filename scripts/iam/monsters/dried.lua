local mod = FHAC
local game = Game()
local rng = RNG()

StageAPI.AddEntityPersistenceData({
    Type = mod.Monsters.Dried.ID,
    Variant = mod.Monsters.Dried.Var,
    RemoveOnRemove = true,
    RemoveOnDeath = true,
    UpdateSubType = true
})

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dried.Var then
        mod:DriedAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dried.ID)

function mod:DriedAI(npc, sprite, d)
local room = game:GetRoom()
local targs = {}
    if not d.init then
        d.creepsec = 1
        local delay = 0
        d.entitypos = 500
        d.bagcostume = math.random(4)
        d.flip = rng:RandomInt(1,2)
        if d.flip == 1 then
            d.flip = true
        else
            d.flip = false
        end
        sprite:Play("rope", true)
        d.Yoffset = -80 + rng:RandomInt(-10, 10)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.GridCollisionClass = (GridCollisionClass.COLLISION_NONE)
        npc.EntityCollisionClass = (EntityCollisionClass.ENTCOLL_NONE)
        d.creepsec = rng:RandomInt(1, 12)
        d.speed = rng:RandomInt(1, 10)
        --100% not stolen from the github wiki
        local room = game:GetRoom()
        local roomEntities = room:GetEntities()
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            if entity.Position:Distance(npc.Position) < d.entitypos then
            table.insert(targs, entity.Position:Distance(npc.Position))
            --very funy
            end
        end
        --ig this is kinda old but eh
        d.entitypos = targs[math.random(#targs)]
        if npc.SubType == nil or npc.SubType == 0 then
        if d.creepsec == 3 then
            --black
            d.creep = 26
            d.creepsec = 1
            d.splat = Color(0, 0, 0, 1)
            d.speed = 2
            sprite.PlaybackSpeed = 0.5
        elseif d.creepsec == 4 then
            --white
            d.creep = 25
            d.creepsec = 1
            d.splat = Color(255, 255, 255, 1)
            d.speed = 3
            sprite.PlaybackSpeed = 0.7
        elseif d.creepsec == 5 then
            --brown
            d.creep = 94
            d.creepsec = 1
            d.splat = Color(126, 97, 9, 1)
            sprite.PlaybackSpeed = 0.9
            d.speed = 2
        elseif d.creepsec == 6 then
            --green
            d.creep = 23
            d.creepsec = 0.5
            d.splat = Color(18, 143, 31, 1)
            sprite.PlaybackSpeed = 0.2
            d.speed = 4
        elseif d.creepsec == 7 then
            --yellow
            d.creep = 24
            d.creepsec = 1
            d.splat = Color(240, 235, 0, 1)
            sprite.PlaybackSpeed = 1
            d.speed = 6
        else
            --red
            d.creep = 22
            d.creepsec = 1
            sprite.PlaybackSpeed = 0.8
            d.speed = 1
        end
        elseif npc.SubType == 1 then
            d.creep = 26
            d.creepsec = 1
            d.splat = Color(0, 0, 0, 1)
            sprite.PlaybackSpeed = 0.5
            d.speed = 2
        elseif npc.SubType == 2 then
            d.creep = 25
            d.creepsec = 1
            d.splat = Color(255, 255, 255, 1)
            d.speed = 3
            sprite.PlaybackSpeed = 0.7
        elseif npc.SubType == 3 then
            d.creep = 94
            d.creepsec = 1
            d.splat = Color(126, 97, 9, 1)
            sprite.PlaybackSpeed = 0.9
            d.speed = 2
        elseif npc.SubType == 4 then
            d.creep = 23
            d.creepsec = 0.5
            d.splat = Color(18, 143, 31, 1)
            d.speed = 4
            sprite.PlaybackSpeed = 0.2
        elseif npc.SubType == 5 then
            d.creep = 24
            d.creepsec = 1
            d.splat = Color(240, 235, 0, 1)
            d.speed = 6
            sprite.PlaybackSpeed = 1
        elseif npc.SubType == 6 then
            d.creep = 22
            d.creepsec = 1
            sprite.PlaybackSpeed = 0.8
            d.speed = 1
        end
        sprite:PlayOverlay("bag" .. d.bagcostume, true)
        d.creepsec = d.creepsec + (rng:RandomInt(-2, 2) * 0.5)
        d.init = true
    end
    if d.creepsec == 0 then
        d.creepsec = 1
    end
    npc.SpriteOffset = Vector(0, d.Yoffset)

    if not room:IsClear() then
    if mod:isScare(npc) then
        npc.Velocity = npc.Velocity * (d.speed * 0.1)
    else
        npc.Velocity = npc.Velocity * (d.speed * 0.1)
    end
   
    npc.Velocity = npc.Velocity:Rotated(d.entitypos)

    if d.creep == 26 or d.creep == 94 then
        npc.Velocity = npc.Velocity * 0.4
    end

    sprite.FlipX = d.flip

    if not d.creep == 22 then
    npc.SplatColor = d.splat
    end
    --just to make sure it doesnt keep changing since it's annoying when it does


    --the loop just doesn;t work and idk why
    if sprite:GetOverlayFrame("drip" .. d.bagcostume) == 17 then
        local crepe = Isaac.Spawn(1000, d.creep,  0, npc.Position, Vector(0, 0), npc):ToEffect()
        crepe.Scale = crepe.Scale --* d.creepsec
        if not crepe.Timeout == nil then
        crepe:SetTimeout(crepe.Timeout - (45 * d.creepsec))
        end
        crepe:Update()
        --sprite:PlayOverlay("bag" .. d.bagcostume, true)
    end

    if d.Yoffset >= -60 then
        npc.GridCollisionClass = (GridCollisionClass.COLLISION_OBJECT)
        npc.EntityCollisionClass = (EntityCollisionClass.ENTCOLL_PLAYEROBJECTS)
    end

    --uhhhhhhhhhhhhhhhhhhhhhhhhh
    if npc.Position.X < -100 or npc.Position.X > room:GetGridWidth()*40+100 or npc.Position.Y > room:GetGridHeight()*40+300 or npc.Position.Y < -300 then
        print("ah")
        npc.Position = room:ScreenWrapPosition(npc.Position, 0)
        npc.Velocity = Vector(0, 0)
    end
    else
    npc.Velocity = npc.Velocity * 0
    sprite:Stop()
    end
end

