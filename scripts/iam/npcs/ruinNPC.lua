local game = Game()
local mod = FHAC

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.NPCS.RuinNPC.Var then
        mod:ruinNPC(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.NPCS.RuinNPC.ID)

function mod:ruinNPC(npc, sprite, d)

    local rDat = {}

    if npc.SubType > 0 then
        local ruinData = include("scripts.dialogue.ruindialogue")
        rDat = ruinData[npc.SubType]
    end

    local animPre = rDat.animPre or ""

    if not rDat.animation then error("no animation given!") end

    if not d.init then
        sprite:Load(rDat.animation, true)
        sprite:Play(rDat.initanim or sprite:GetDefaultAnimation())
        d.animation = d.animation or "gfx/npcs/ruin/skeletons/skeletons.anm2"
        d.Dia1 = d.Dia1 or rDat.Dia1
        d.init = true
    end

    if sprite:IsPlaying() and not string.find(sprite:GetAnimation(), animPre) then
        sprite:Play(animPre .. sprite:GetAnimation())
    end

    if rDat ~= {} and rDat.func(npc) then
        rDat.func(npc)
    end

end