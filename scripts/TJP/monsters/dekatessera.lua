local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dekatessera.Var then
        mod:DekatesseraAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dekatessera.ID)

function mod:DekatesseraAI(npc, sprite, d)
    local room = game:GetRoom()
    local player = npc:GetPlayerTarget()

    if npc.StateFrame > 100 then
        d.targetpos =  mod:freeGrid(npc, false, 200, 100)
        npc.StateFrame = 0
    end

    if not d.init then
        npc.GridCollisionClass = 0

        d.cooldown = 0
        d.targetpos =  mod:freeGrid(npc, false, 200, 100)
        d.state = "Idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        d.cooldown = d.cooldown + 1
    end

    if d.state == "Idle" then
        d.targetvelocity = (d.targetpos - npc.Position):Resized(7)
        mod:spritePlay(sprite, "Idle")
        if npc.Position:Distance(d.targetpos) > 5 then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.1)
        end

        if d.cooldown > 200 then
            d.state = "Attack"
        end


    end

    if d.state == "Attack" then
        npc.Velocity = npc.Velocity/2
        mod:spritePlay(sprite, "Attack")
        if sprite:IsFinished() then
            d.cooldown = 0
            d.state = "Recharge"
        end
    end

    if d.state == "Recharge" then

        if d.cooldown > 200 then
            mod:spritePlay(sprite, "Reset")
            if sprite:IsFinished() then
                d.cooldown = 0
                d.state = "Idle"
            end
        else
            mod:spritePlay(sprite, "Recharge")
        end
    end
end

