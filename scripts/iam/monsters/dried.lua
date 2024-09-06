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
    if not d.init then
        if d.isPrevEntCopy then
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        d.entitypos = 500
        d.bagcostume = d.bagcostume or math.random(4)
        d.flip = d.flip or rng:RandomInt(1,2)
        sprite:Play("rope", true)
        sprite:PlayOverlay("bag" .. d.bagcostume, true)
        d.Yoffset = d.Yoffset or (-80 + rng:RandomInt(-10, 10))
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.GridCollisionClass = (GridCollisionClass.COLLISION_NONE)
        npc.EntityCollisionClass = (EntityCollisionClass.ENTCOLL_NONE)
        d.creepsec = d.creepsec or rng:RandomInt(1, 12)
        d.mynumber = d.mynumber or math.random(1, #driedsubtypes)
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
        d.creepsec = d.creepsec + (rng:RandomInt(-2, 2) * 0.5)
        mod:SaveEntToRoom({
            Name="Dried",
            NPC = npc,
        })
        npc.SpriteOffset = Vector(0, d.Yoffset)
        d.init = true
    else
        if room:IsClear() then npc.StateFrame = npc.StateFrame + 1 end
    end


    if not room:IsClear() then
   
        npc.Velocity = npc.Velocity:Rotated(d.entitypos)

        sprite.FlipX = d.flip

        if not d.creep == 22 then
            npc.SplatColor = d.splat
        end
        --just to make sure it doesnt keep changing since it's annoying when it does

        if sprite:GetOverlayFrame("drip" .. d.bagcostume) == 17 or (npc.StateFrame > 3 * d.creepsec and room:IsClear()) then
            d.creepsec = d.creepsec or driedsubtypes[d.mynumber].creepsec or 1 + (rng:RandomInt(-2, 2) * 0.5)
            local crepe = Isaac.Spawn(1000, d.creep,  0, npc.Position, Vector(0, 0), npc):ToEffect()
            crepe.Scale = crepe.Scale --* d.creepsec
            if not crepe.Timeout == nil then
                if room:IsClear() then
                    crepe:SetTimeout(crepe.Timeout + (45 * d.creepsec))
                else
                    crepe:SetTimeout(crepe.Timeout - (45 * d.creepsec))
                end
            end
            crepe:Update()
            --sprite:PlayOverlay("bag" .. d.bagcostume, true)
            npc.StateFrame = 0
        end
    else
        sprite:Stop()
    end
end

