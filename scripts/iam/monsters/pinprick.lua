local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Pinprick.Var and npc.SubType >= 1 then
        mod:PinprickSpawnerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Pinprick.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Pinprick.Var and npc.SubType == 0 then
        mod:PinprickAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Pinprick.ID)

function mod:PinprickSpawnerAI(npc, sprite, d)
    if not d.spawnerinit then
        npc.Visible = true
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        for i = 0, npc.SubType - 2 do
            local prick = Isaac.Spawn(Isaac.GetEntityTypeByName("Pinprick"),  Isaac.GetEntityVariantByName("Pinprick"), Isaac.GetEntitySubTypeByName("Pinprick"), npc.Position, Vector.Zero, npc)
            prick:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            prick:GetData().dashoffset = rng:RandomInt(0, 10)
        end
        npc.SubType = 0
        d.spawnerinit = true
    end
end

function mod:PinprickAI(npc, sprite, d)

    local room = game:GetRoom()
    local target = Game():GetNearestPlayer(npc.Position)
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local cos = math.cos(npc.FrameCount / 15) * 80
    local sin = math.sin(npc.FrameCount / 15) * 80

    if not d.firstinit then
        d.moveoffset = 0
        d.dashoffset = rng:RandomInt(0, 10)
        npc.SpriteOffset = Vector(0,-20)
        d.Trail = Isaac.Spawn(1000,166,0,npc.Position,Vector.Zero,npc):ToEffect() -- to learn how to do trails specifically like this, i consulted erfly and he told me to check the tricko code
        d.Trail:FollowParent(npc)
        d.Trail.ParentOffset = Vector(0,-32)
        local color = Color(1,1,1,1,0.6,0.5,0.05)
        npc.SplatColor = color
        color:SetColorize(1, 0.8, 0.1, 3)
        d.Trail.Color = color
        d.newpos = npc.Position
        npc.Position = (room:GetCenterPos() + d.newpos):Rotated((targetpos - npc.Position):GetAngleDegrees() + 180 + rng:RandomInt(-20, 20))
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        d.firstinit = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.Position:Distance(d.newpos) < 30 and not d.init then
        npc.StateFrame = 31
        d.init = true
    end

    if npc.StateFrame > 30 + d.dashoffset and d.init then
        if d.moveoffset < 0.02 then
        d.dashoffset = rng:RandomInt(0, 10)
        d.newpos = targetpos - Vector(10, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() + rng:RandomInt(-5, 5))
        d.moveoffset = 0
        npc.StateFrame = 0
        else
            d.moveoffset = d.moveoffset - 0.005
        end
    else
        d.moveoffset = d.moveoffset + 0.001
        if not game:GetRoom():IsPositionInRoom(npc.Position, 0) then
            npc.StateFrame  = npc.StateFrame + 3
        end
    end
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    if mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, d.newpos - npc.Position, 0.005 + d.moveoffset):Rotated(rng:RandomInt(1, 360))
    else
        npc.Velocity = mod:Lerp(npc.Velocity, (d.newpos - npc.Position):Resized(30),  0.025 + d.moveoffset + (npc.StateFrame/1000)%30)
    end
end

