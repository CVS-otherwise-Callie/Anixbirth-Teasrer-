local mod = FHAC
local game = Game()
local room = game:GetRoom()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.MushLoom.Var then
        mod:MushLoomAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.MushLoom.ID)

function mod:MushLoomAI(npc, sprite, d)
    if not d.init then
        if npc.SubType == 0 then
            d.waittime = rng:RandomInt(30, 50)
        else
            d.waittime = npc.SubType
        end
        d.shoottype = 1
        d.state = "Hide"
        d.offset = math.random(-360, 360)
        d.oldpos = npc.Position
        d.idonttakealotofdamage = false
        npc.Velocity = Vector.Zero
        npc.SpriteOffset = Vector(0, 2)
        d.TrueFart = true --look dont ask
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
        mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
            if npc:ToNPC():GetData().idonttakealotofdamage then
                return {Damage=0.5}
            end
        end, mod.Monsters.MushLoom.ID)
    end

    if d.state == "LookUp" then
        d.oldpos = npc.Position
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

    function mod:mushloomFind(far, close)
        local tab = {}
        for i = 0, room:GetGridSize() do
            if room:GetGridPosition(i):Distance(npc.Position) < far and room:GetGridPosition(i):Distance(npc.Position) > close and room:GetGridEntity(i) == nil and room:IsPositionInRoom(room:GetGridPosition(i), 0) then
                table.insert(tab, room:GetGridPosition(i))
            end
        end
        if #tab == 0 then
            return npc.Position
        end
        return tab[rng:RandomInt(1, #tab - 1)]
    end

    if sprite:IsFinished("LookUp") then
        d.idonttakealotofdamage = false
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL
        d.state = "Jump"
        npc.Velocity = mod:Lerp(npc.Velocity, mod:mushloomFind(250, 200) - npc.Position, 0.15, 2, 2)
    end

    if sprite:IsEventTriggered("shoot") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
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
        d.offset = math.random(-20, 20)
        npc.Velocity = npc.Velocity * 0.1
    end

    if sprite:IsFinished("Jump") then
        npc.StateFrame = 0
    end

    mod:spritePlay(sprite, d.state)
end

