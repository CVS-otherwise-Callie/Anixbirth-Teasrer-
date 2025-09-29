local game = Game()
local mod = FHAC

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.NPCS.RuinNPC.Var then
        mod:ruinNPC(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.NPCS.RuinNPC.ID)

function mod:ruinNPC(npc, sprite, d)

    local rDat = {}

    npc.CanShutDoors = false
    d.DSSMenuSafe = true

    mod:SaveEntToRoom(npc, true)

    if npc.SubType > 0 then
        local ruinData = include("scripts.dialogue.ruindialogue")
        rDat = ruinData[npc.SubType]
    end

    if not rDat or not rDat.animation then error("no data given!") return end

    local animPre = rDat.animPre or ""

    if not d.init then
        sprite:Load(rDat.animation, true)
        sprite:Play(rDat.initanim or sprite:GetDefaultAnimation())
        d.animation = d.animation or "gfx/npcs/ruin/skeletons/skeletons.anm2"
        d.Dia1 = d.Dia1 or rDat.Dia1

        d.curDia = 1
        d.subTable = 0

        d.init = true
    end

    if d.isTalking then
        
        if d.shouldClose then
            d.isTalking = false
            d.shouldClose = false
            d.currentdialouge = nil
        else
            d.currentdialouge = d.currentdialouge or mod:NPCDialouge(rDat["Dia" .. tostring(d.curDia)][d.subTable], npc.Position, {anchor=2}, npc)

            d.curPar = rDat["Dia" .. tostring(d.curDia)][d.subTable]

            if not d.shouldClose then
                if d.currentdialouge:GetSprite():IsPlaying("Close") then
                    d.shouldClose = true
                end
            end
        end
    end

    if d.currentdialouge and not (d.currentdialouge:IsDead() or not d.currentdialouge:Exists()) then
        d.currentdialouge.Position = npc.Position + Vector(30, -20)
    end

    if sprite:IsPlaying() and not string.find(sprite:GetAnimation(), animPre) then
        sprite:Play(animPre .. sprite:GetAnimation())
    end

    if rDat ~= {} and rDat.func(npc) then
        rDat.func(npc)
    end

end

mod.onNPCTouch("RuinNPC", function(player, npc)
    local sd = npc:GetData()

    local rDat = {}

    if npc.SubType > 0 then
        local ruinData = include("scripts.dialogue.ruindialogue")
        rDat = ruinData[npc.SubType]
    end

    if not sd.isTalking then

        if rDat["Dia" .. tostring(sd.curDia)][sd.subTable + 1] then
            sd.subTable = sd.subTable + 1
        end

        sd.isTalking = true
    end
end)