local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dried.Var then
        mod:DriedAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dried.ID)

function mod:DriedAI(npc, sprite, d)
local room = game:GetRoom()
    if d.flip == 1 then
        d.flip = true
    else
        d.flip = false
    end

    local driedsubtypes = {
        {
            --black
            creep = 26,
            creepsec = 1,
            splat = Color(0, 0, 0, 1),
            speed = 2,
            PlaybackSpeed = 0.5,
        },
        {
            --white
            creep = 25,
            creepsec = 1,
            splat = Color(255, 255, 255, 1),
            speed = 3,
            PlaybackSpeed = 0.7,
        },
        {
            --slippy brown
            creep = 94,
            creepsec = 1,
            splat = Color(126, 97, 9, 1),
            speed = 2,
            PlaybackSpeed = 0.9,
        },
        {
            --green
            creep = 23,
            creepsec = 0.5,
            splat = Color(18, 143, 31, 1),
            speed = 4,
            PlaybackSpeed = 0.2,
        },
        {
            --yellow
            creep = 24,
            creepsec = 1,
            splat = Color(240, 235, 0, 1),
            speed = 6,
            PlaybackSpeed = 1,
        },
        {
            --red
            creep = 22,
            creepsec = 1,
            speed = 1,
            PlaybackSpeed = 0.8,
        }  
    }

    mod:SaveEntToRoom(npc)

    if not d.init then
        if d.isPrevEntCopy then
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        d.entitypos = 500
        d.baganim = math.random(3)
        d.bagcostume = d.bagcostume or 1
        d.flip = d.flip or rng:RandomInt(1,2)
        sprite.FlipX = d.flip
        sprite:Play("BagIdle"..d.baganim, true)
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dried/dried" .. d.bagcostume, 0)
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dried/dried" .. d.bagcostume, 1)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER)
        npc.GridCollisionClass = (GridCollisionClass.COLLISION_NONE)
        npc.EntityCollisionClass = (EntityCollisionClass.ENTCOLL_NONE)
        d.creepsec = d.creepsec or rng:RandomInt(1, 12)
        d.mynumber = d.mynumber or math.random(1, #driedsubtypes)
        d.offset = d.offset or Vector(math.random(-5, 5), math.random(-30, -20))
        npc.SpriteOffset = d.offset
        local tab
        if npc.SubType == nil or npc.SubType == 0 then
            tab= driedsubtypes[d.mynumber]
        else
            tab = driedsubtypes[npc.SubType]
        end
        for h, g in pairs(tab) do
            if not d[h] then
                d[h] = g
            end
        end
        d.creepsec = d.creepsec + (math.random(-10, 10))
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    if not room:IsClear() then

        if sprite:IsFinished("BagIdle" .. d.baganim) then
            d.baganim = math.random(3)
        end

        npc.Velocity = npc.Velocity:Rotated(d.entitypos)
        if not d.creep == 22 then
            npc.SplatColor = d.splat
        end

        if npc.StateFrame >= (50+d.creepsec)/d.speed then
            local drip = Isaac.Spawn(1000, EffectVariant.RAIN_DROP, 0, npc.Position + Vector(math.random(-10, 10) - npc.SpriteOffset.X, math.random(-10, 0)), Vector.Zero, npc)
            drip:GetSprite():SetFrame(12)
            drip:GetData().type = "Dried"
            drip.Color = d.splat or Color(240, 0, 0, 1)
            drip.Parent = npc
            drip:Update()
            npc.StateFrame = 0
        end
        --just to make sure it doesnt keep changing since it's annoying when it does
    else
        sprite:Stop()
    end
end

function mod:PostDriedDripUpdate(ef, sprite, d)
    if ef.Variant == EffectVariant.RAIN_DROP and d.type == "Dried" then
        local crepe
        if sprite:GetFrame() >= 19 then
            crepe = Isaac.Spawn(1000, ef.Parent:GetData().creep,  0, ef.Position, Vector(0, 0), ef.Parent):ToEffect()
            crepe:GetData().type = "DriedCreep"
            crepe.Scale = crepe.Scale * 0.5
            crepe:Update()
        end
        if crepe then crepe.Scale = crepe.Scale * 0.5 end
    end
    if d.type == "DriedCreep" then
        ef:SetTimeout(1000)
    end
end

