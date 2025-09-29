local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.NPCS.OGWilloWalker.Var then
        mod:OGWilloWalkerNPC(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.NPCS.OGWilloWalker.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, coll)
    if npc.Variant == mod.NPCS.OGWilloWalker.Var and npc:GetData().state == "talking" and coll.Type == 1 then
        mod:OGWilloWalkerNPCColl(npc, npc:GetSprite(), npc:GetData(), coll)
    end
end, mod.NPCS.OGWilloWalker.ID)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
    for _, ent in pairs(Isaac:GetRoomEntities()) do
        if ent.Variant == mod.NPCS.OGWilloWalker.Var and ent:GetData().state == "follow" then
            if ent:GetData().positions then
                for num,_ in ipairs(ent:GetData().positions) do
                    ent:GetData().positions[num] = ent:GetData().player.Position
                end
            end
        end
    end
end, mod.NPCS.OGWilloWalker.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc:IsBoss() and Game():GetRoom():GetType() == 5 then
        for _, ent in pairs(Isaac:GetRoomEntities()) do
            if ent.Variant == mod.NPCS.OGWilloWalker.Var and ent:GetData().state == "follow" then
                ent:GetData().state = "leave"
            end
        end
    end
end)

function mod:OGWilloWalkerNPC(npc, sprite, d)
    d.script = {
            [[These \Ywillos \Ware \YPissing \Wme off...]]
        ,

            [[I'm the original        \YWillowalker]]
    }
    npc.CanShutDoors = false
    d.DSSMenuSafe = true

    if not d.init then
        mod:SaveEntToRoom(npc, false)
        npc.EntityCollisionClass = 5
        d.neednewbox = true
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        mod:spritePlay(sprite, "Idle")
        d.state = "talking"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "follow" then
        npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
        mod:RemoveEntFromRoomSave(npc)
        npc.EntityCollisionClass = 0
        npc.GridCollisionClass = 0

        if not d.positions then
            d.positions = {

            }
            for i = 0, 15 ,1 do
                table.insert(d.positions, Vector(mod:Lerp(npc.Position.X, d.player.Position.X, i/100), mod:Lerp(npc.Position.Y, d.player.Position.Y, i/15)))
            end
        end

        if d.oldpos and (d.oldpos.X ~= math.floor(d.player.Position.X) or d.oldpos.Y ~= math.floor(d.player.Position.Y)) then
            table.remove(d.positions, 1)
            table.insert(d.positions, #d.positions+1, Vector(d.player.Position.X, d.player.Position.Y))
        end
        d.oldpos = Vector(math.floor(d.player.Position.X), math.floor(d.player.Position.Y))

        npc.Position = d.positions[1]
    end

    if d.state == "leave" then
        mod:spritePlay(sprite,"FinishedBusiness")
        if sprite:IsFinished() then
            npc:Remove()
        end
    end
end

function mod:OGWilloWalkerNPCColl(npc, sprite, d, coll)

    d.player = coll

    if not d.isspeaking then
        if npc.Child and npc.Child.Child then
            npc.Child.Child:GetData().sentlen = 1
            npc.Child.Child:GetData().scriptnumber = npc.Child.Child:GetData().scriptnumber + 1
        end
        d.isspeaking = true
    else
        return
    end

    if not npc.Child and d.neednewbox then
        d.neednewbox = false
        d.box = Isaac.Spawn(1000, 429, 55, Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight()*2)-70)), npc.Velocity, npc):ToEffect()
        d.box.Parent = npc
        npc.Child = d.box
        d.boxdat = npc.Child:GetData()
    end

end