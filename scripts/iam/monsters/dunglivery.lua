local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dunglivery.Var then
        mod:DungliveryAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dunglivery.ID)

function mod:DungliveryAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.state = "idle"
        d.speed = 1
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc:MultiplyFriction(0.5)

        if npc.StateFrame > 30 then
            d.state = "moving"
        end

    else

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(2)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
            path:FindGridPath(target.Position, 0.5, 1, true)
        end   

    end

    if npc.Velocity:Length() > 1 and d.state == "idle" or d.state == "moving" then
        mod:spritePlay(sprite, "FlySide")
    end
end

