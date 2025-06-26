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

function mod:OGWilloWalkerNPC(npc, sprite, d) --the text box and font are in the TJP folder
    d.script = {
        {
            [[These \Ywillos \Ware \YPissing \Wme off...]]
        }
        ,
        {
            [[I'm the original   \YWillowalker]]
        }
    }
    npc.CanShutDoors = false

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        mod:spritePlay(sprite, "Idle")
        d.state = "talking"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.box and d.boxdat.init and d.boxdat.isspeaking then
        d.boxdat.currentletter = d.boxdat.currentletter + 1
    end

   -- mod:SaveEntToRoom(npc, false)

end

function mod:OGWilloWalkerNPCColl(npc, sprite, d, coll)
    if not d.isspeaking then
        d.isspeaking = true
    else
        return
    end

    if not npc.Child then
        local center = StageAPI.GetScreenCenterPosition()
	    local bottomright = StageAPI.GetScreenBottomRight()
	    local bcenter = Vector(center.X, bottomright.Y - 300)
        d.box = Isaac.Spawn(1000, 429, 55, Vector(bcenter.X, Isaac.GetScreenHeight() - 35), Vector.Zero, npc):ToEffect()
        d.box.Parent = npc
        npc.Child = d.box
        d.boxdat = npc.Child:GetData()
    end

end