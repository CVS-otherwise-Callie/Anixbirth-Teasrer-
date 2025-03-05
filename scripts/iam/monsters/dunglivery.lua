local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dunglivery.Var then
        mod:DungliveryAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dunglivery.ID)

mod.DungliveryEnts = {
    {EntityType.ENTITY_DIP, 0},
    {EntityType.ENTITY_DRIP, 0},
    {EntityType.ENTITY_MAGGOT, -1},
    {EntityType.ENTITY_SMALL_MAGGOT, -1},
    {EntityType.ENTITY_LEECH, 0},
    {EntityType.ENTITY_SPITTY, 0},
    {EntityType.ENTITY_CONJOINED_SPITTY, 0}
}

function mod:DungliveryAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.state = "idle"
        d.speed = 1

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local function GetSmallEnt()
        local tab = {}
        for k, v in ipairs(mod.DungliveryEnts) do
            local ent = mod:GetSpecificEntInRoom({ID = v[1], Var = v[2]}, npc, 1000)
            if not d.specificTargTypeIsPlayer then
                if not ent:GetData().DungliveryParent then
                    table.insert(tab, ent)
                end
            end
        end
        return tab[math.random(#tab)]
    end

    if d.ent and (d.ent:IsDead() or not d.ent:Exists()) then
        d.state = "idle"
    elseif d.state == "idle" and d.ent then
        d.state = "moving"
        npc.StateFrame = 0
    elseif d.state == "moving" then

        targetpos = d.ent.Position

        if npc.Position:Distance(d.ent.Position) < 10 then
            mod:spritePlay(sprite, "GoDown")
            npc.Position = d.ent.Position
        else
            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-7)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
            elseif room:CheckLine(target.Position,npc.Position,3,900,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(7)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
            else
                local targetvelocity = (targetpos - npc.Position):Resized(2)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
                path:FindGridPath(target.Position, 0.5, 1, true)
            end
        end

    elseif d.state == "pickup" then

        npc:MultiplyFriction(0.95)

        local targetvelocity = (targetpos - npc.Position):Resized(100)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.0075)

        if math.abs(math.abs(npc.Velocity:GetAngleDegrees()) - math.abs((targetpos - npc.Position):GetAngleDegrees())) < 20 and npc.Velocity:Length() > 5 then
            mod:spritePlay(sprite, "Sling")
            npc.StateFrame = 0
        end

    elseif d.state == "throwtime" then


    end

    if targetpos.X < npc.Position.X then --future me pls don't fuck this up
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    if d.state == "idle" then
        d.ent = nil
        npc:MultiplyFriction(0.9)

        if npc.StateFrame > 30 then
            d.ent = GetSmallEnt():ToNPC()
            if d.ent and not d.ent.Type == 1 then d.ent:GetData().DungliveryParent = npc end
        end
    end

    if npc.Velocity:Length() > 1 and sprite:GetAnimation() ~= "GoDown" and sprite:GetAnimation() ~= "Sling" then
        if not sprite:IsFinished("FlySideInit") and not d.isFinishedFlySideInit then
            mod:spritePlay(sprite, "FlySideInit")
        else
            d.isFinishedFlySideInit = true
            mod:spritePlay(sprite, "FlySide")
        end
    elseif sprite:GetAnimation() ~= "GoDown" and (d.state == "idle" or d.state == "moving") then
        d.isFinishedFlySideInit = false
        mod:spritePlay(sprite, "Idle")
    end

    if sprite:IsFinished("GoDown") and d.state == "moving" then
        
        d.state = "pickup"
        mod:spritePlay(sprite, "FlySideInit")

    end

    if sprite:IsEventTriggered("Pickup") and not d.ent:GetData().isbeingPickedUpByDunglivery then

        d.ent:GetData().oldGridColl = d.ent.GridCollisionClass
        d.ent:GetData().oldEntColl = d.ent:ToNPC().EntityCollisionClass
        d.ent.GridCollisionClass = npc.GridCollisionClass
        d.ent.EntityCollisionClass = npc.EntityCollisionClass
        d.ent:GetData().isbeingPickedUpByDunglivery = true

    elseif sprite:IsEventTriggered("Launch") then

        d.ent.GridCollisionClass = d.ent:GetData().oldGridColl
        d.ent.EntityCollisionClass = d.ent:GetData().oldEntColl
        d.ent.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 20
        d.ent:GetData().isbeingPickedUpByDunglivery = false
        d.ent = nil

        npc:MultiplyFriction(0.6)
        npc.StateFrame = 0
        d.state = "idle"

    end
    
    if d.ent then
        if d.ent:GetData().isbeingPickedUpByDunglivery then
            d.ent.Position = npc.Position
        end
    end
end

