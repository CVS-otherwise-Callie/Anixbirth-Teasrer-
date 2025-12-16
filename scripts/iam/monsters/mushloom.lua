local mod = FHAC
local game = Game()
local rng = RNG()

function mod:MushLoomAI(npc, sprite, d)

    local tab = {
        "normal",
        "pretty",
        "shaded pretty"
    }
    mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/mushloom/".. tab[mod.DSSavedata.prettyMushlooms or 1] .. "mushloom", 0)
    
    if not d.init then
        if npc.SubType == 0 then
            d.waittime = rng:RandomInt(30, 50)
        else
            d.waittime = npc.SubType * 3
        end
        d.shoottype = 1
        d.state = "Hide"
        d.offset = math.random(-360, 360)
        d.oldpos = npc.Position
        d.idonttakealotofdamage = false
        npc.Velocity = Vector.Zero
        npc.SpriteOffset = Vector(0, 2)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > d.waittime and d.state == "Hide" then
        d.state = "LookUp"
    elseif npc.StateFrame <= d.waittime - 1 then
        d.state = "Hide"
        npc.Velocity = Vector.Zero
    end

    if d.state == "Hide" then
        d.idonttakealotofdamage = true
    end

    if d.state == "LookUp" then
        d.oldpos = npc.Position
        if not d.lookupinit then
            d.oldwait = npc.StateFrame
            d.lookupinit = true
        end
    end

   --[[ if sprite:IsFinished("LookUp") then
        d.state = "JumpUp"
        npc.Velocity = mod:Lerp(npc.Velocity, npc.Position - (room:GetCenterPos() + Vector(20, 0)):Rotated(d.offset), 0.01, 2, 2)
    end

    if sprite:IsFinished("JumpUp") then
        d.state = "Peak"
        npc.Velocity = mod:Lerp(npc.Velocity, npc.Position - (room:GetCenterPos() + Vector(20, 0)):Rotated(d.offset), 0.1, 2, 2)
    end

    if d.state == "Peak" then
        if npc.StateFrame > 80 then
            d.state = "FallDown"
        end
        if npc.StateFrame < 60 then
            npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, npc.SpriteOffset - Vector(0, 20), 0.05)
        else
            npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, d.oldspriteoffset, 0.05)
        end
    end

    if d.state == "FallDown" then
        npc.Velocity = npc.Velocity * 0.01
    end

    if sprite:IsFinished("FallDown") then
        npc.StateFrame = 0
    end]]

    if sprite:IsFinished("LookUp") then
        d.idonttakealotofdamage = false
        if npc.StateFrame >= d.oldwait + (d.waittime/ 2) then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL
            d.state = "Jump"
            npc.Velocity = mod:Lerp(npc.Velocity, mod:freeGrid(npc, false, 300, 200) - npc.Position, 0.15, 2, 2)
        else
            npc.Velocity = Vector.Zero
        end
    end

    if sprite:IsEventTriggered("shoot") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.GridCollisionClass = 5
        local params = ProjectileParams()
        params.HeightModifier = -1
        params.Scale = 1
        if d.shoottype == 1 then
            d.shoottype = 2
            d.shootoffset = 45
        else
            d.shoottype = 1
            d.shootoffset = 90
        end
        for i = 0, 4 do
            npc:FireProjectiles(npc.Position, Vector(0, 10):Rotated(((i * 90) + d.shootoffset)), 0, params)
        end
        d.lookupinit = false
        d.offset = math.random(-20, 20)
        npc.Velocity = npc.Velocity * 0.1
    end

    if sprite:IsFinished("Jump") then
        npc.StateFrame = 0
    end

    mod:spritePlay(sprite, d.state)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc:ToNPC():GetData().idonttakealotofdamage then
        return {Damage=0.5}
    end
end, mod.Monsters.MushLoom.ID)

