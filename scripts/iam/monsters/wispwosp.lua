local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.WispWosp.Var and npc.SubType == 0 then
        mod:PinprickAI(npc, npc:GetSprite(), npc:GetData())
        local d = npc:GetData()
        local s = npc:GetSprite()

        if not d.wispwospInit then
            d.newpos = npc.Position
            d.moveit = 0
            d.wobb = 0
            d.funnyasslerp = 0.06
            d.coolaccel = 0.5
            d.pinPrickDash = -30
            d.wispwospInit = true
        end

        mod:spritePlay(s, "Idle")


        d.newpos = npc:GetPlayerTarget().Position
        npc.SpriteOffset = Vector(0,0)
        npc.Velocity = mod:Lerp(npc.Velocity, (d.newpos - npc.Position):Resized(d.coolaccel*10), 0.025 + d.moveoffset)


        if d.coolaccel and d.coolaccel < 10 then
            d.coolaccel = d.coolaccel + 0.1
        else
            d.coolaccel = 0.5
        end
        if rng:RandomInt(1, 2) == 2 then
            d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.1, 0.55)
        else
            d.funnyasslerp = mod:Lerp(d.funnyasslerp, 0.01, 0.02)
        end
    
    end
end, mod.Monsters.WispWosp.ID)

