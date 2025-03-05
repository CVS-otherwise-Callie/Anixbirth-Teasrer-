local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.HorfOnAStick.Var then
        mod:HorfOnAStickAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.HorfOnAStick.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc:GetData().type == "horfonastick" and (npc.Parent and npc:Exists() and not npc.Parent:IsDead()) then
        mod:HorfOnAStickFlyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, EntityType.ENTITY_FLY)

local function GetFliesWithSameDataAsHOAS(npc)
    local tab = {}
    for k, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_FLY)) do
        if poop:GetData().InitSeed == npc:GetData().InitSeed then
            table.insert(tab, poop)
        end
    end
    for k, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_ATTACKFLY)) do
        if poop:GetData().InitSeed == npc:GetData().InitSeed and poop.Position:Distance(npc.Position) > 0 then
            table.insert(tab, poop)
        end
    end
    return tab
end

function mod:HorfOnAStickAI(npc, sprite, d)

    local room = game:GetRoom()

    mod:SaveEntToRoom({
        Name="Horf On A Stick",
        NPC = npc,
    })

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        d.over = math.random(-10, 10)
        d.InitSeed = math.random(1000000, 2000000)
        d.state = "idle"
        npc.StateFrame = 89 + d.over
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    if d.state == "idle" then

        local var = EntityType.ENTITY_FLY
        if d.isPissed then
            var = EntityType.ENTITY_ATTACKFLY
        end

        if npc.StateFrame ~= 0 and npc.StateFrame%90+d.over == 0 and #GetFliesWithSameDataAsHOAS(npc) <= 2 then
            local poop = Isaac.Spawn(var,0,0,npc.Position + RandomVector():Resized(10), Vector.Zero, npc)
            poop:ToNPC().CanShutDoors = false
            poop.Parent = npc
            poop:GetData().type = "horfonastick"
            poop:GetData().InitSeed = d.InitSeed
        end
    end

end

function mod:HorfOnAStickFlyAI(npc, sprite, d)

    local targ = npc.Parent
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.newpos = targ.Position + RandomVector():Resized(math.random(8, 12))
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame%13 == 0 then
        d.newpos = targ.Position + Vector(10, 0):Rotated(math.random(180))
    end

    if mod:isScare(npc) then
        local targetvelocity = (d.newpos - npc.Position):Resized(-2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
    elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
        local targetvelocity = (d.newpos - npc.Position):Resized(2)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
    else
        path:FindGridPath(d.newpos, 1.3, 1, true)
    end
    
end

